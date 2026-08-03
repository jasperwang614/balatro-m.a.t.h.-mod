-- 零 · 名数线（设计文档 §2.5）
-- 交互型小丑：每回合一次，点击本卡进入选择模式 → 点击一张手牌 → 该牌获得“零”标记（永久）。
-- 效果：
--   * 零牌打出时计入牌型判定，且在判定中视为任意点数（0 = 占位符，可补五条/顺子/葫芦缺位）
--   * 零牌完全不参与计分，也不触发“每张计分牌”类小丑
--   * 每零化一张牌：永久 +25 筹码（滚雪球）
--   * 商店出现条件：牌组比开局时少 6 张
-- 实现：
--   * 贴纸 unprv_zero + never_scores = true（SMODS 自动把该牌排除出计分手牌）
--   * 包一层 evaluate_poker_hand：判定前把零牌临时试成最优点数（贪心），判定后恢复
--   * 点击交互链式包一层 Card:click（不妨设的钩子在外层已经挂过，这里插在它前面）

-- 记录开局牌组数量（“牌组比开局少 6 张”判定用）
local game_start_run_ref = Game.start_run
function Game:start_run(args)
    game_start_run_ref(self, args)
    if G.GAME and G.playing_cards then
        G.GAME.unprv_start_deck = #G.playing_cards
    end
end

-- “零”角标贴纸：被标记的牌左上角打常驻标签，复用原版 stickers 图集 (6,0) 帧占位
SMODS.Sticker({
    key = 'unprv_zero',
    pos = { x = 6, y = 0 },
    badge_colour = HEX('8a8a8a'),
    prefix_config = { key = false },
    should_apply = false,
    never_scores = true,
    order = 6,
})

local function unprv_zero_msg(card, text)
    if card and card.area then
        card_eval_status_text(card, 'extra', nil, nil, nil, {
            message = text,
            colour = G.C.MULT,
        })
    end
end

local function unprv_zero_disarm(mute)
    local armed = UNPRV.zero_armed
    UNPRV.zero_armed = nil
    if armed then
        armed.ability.unprv_armed = nil
        if not mute then
            unprv_zero_msg(armed, localize('unprv_wlog_canceled'))
        end
    end
end

-- 零牌 = 万能占位符：牌型判定前逐个零牌尝试 2~A，选牌型最优的点数
local ZERO_RANK_IDS = { 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 }
local ZERO_RANK_VALUES = { '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace' }
local evaluate_poker_hand_ref = evaluate_poker_hand

-- 牌型评分：优先级 *1000 + 计分牌点数总和（同牌型取更高）
-- 注意：G.handlist 从强到弱排列（Flush Five 第 1 位、High Card 第 12 位），
--       所以优先级要取反（#G.handlist - i + 1），越大 = 越强。
local function unprv_zero_hand_score(hand)
    local poker_hands = evaluate_poker_hand_ref(hand)
    for i, name in ipairs(G.handlist) do
        local cards = poker_hands[name]
        if cards and next(cards) then
            local sum = 0
            for _, c in ipairs(cards[1]) do
                sum = sum + (c.base.id or 0)
            end
            return (#G.handlist - i + 1) * 1000 + sum
        end
    end
    return 0
end

local function unprv_zero_evaluate(hand, zero_cards)
    local originals = {}
    for _, zc in ipairs(zero_cards) do
        originals[#originals + 1] = { id = zc.base.id, value = zc.base.value }
    end
    local ok, result = pcall(function()
        -- 贪心：逐个零牌确定最优点数（2 张零牌也只多 13 次判定，开销可控）
        for zi, zc in ipairs(zero_cards) do
            local best_score, best_i = -1, 1
            for i = 1, 13 do
                zc.base.id = ZERO_RANK_IDS[i]
                zc.base.value = ZERO_RANK_VALUES[i]
                local s = unprv_zero_hand_score(hand)
                if s > best_score then
                    best_score, best_i = s, i
                end
            end
            zc.base.id = ZERO_RANK_IDS[best_i]
            zc.base.value = ZERO_RANK_VALUES[best_i]
        end
        return evaluate_poker_hand_ref(hand)
    end)
    for zi, zc in ipairs(zero_cards) do
        zc.base.id = originals[zi].id
        zc.base.value = originals[zi].value
    end
    if ok then
        return result
    end
    -- 异常兜底：恢复原样按普通牌判定
    return evaluate_poker_hand_ref(hand)
end

function evaluate_poker_hand(hand)
    local zero_cards = {}
    if hand then
        for _, c in ipairs(hand) do
            if c.ability and c.ability.unprv_zero then
                zero_cards[#zero_cards + 1] = c
            end
        end
    end
    if #zero_cards == 0 then
        return evaluate_poker_hand_ref(hand)
    end
    return unprv_zero_evaluate(hand, zero_cards)
end

-- 出牌/弃牌时先清理“零”的选择模式，防止状态残留（链式接在不妨设的清理之后）
for _, name in ipairs({ 'play_cards_from_highlighted', 'discard_cards_from_highlighted' }) do
    local ref = G.FUNCS[name]
    if ref then
        G.FUNCS[name] = function(e)
            unprv_zero_disarm(true)
            ref(e)
        end
    end
end

local card_click_ref = Card.click
function Card:click()
    -- 不妨设弹窗打开时一律吞掉点击（交给它的钩子处理）
    if UNPRV.wlog_popup then
        return
    end
    if G.STATE == G.STATES.SELECTING_HAND then
        local center_key = self.config.center and self.config.center.key
        if center_key == 'j_unprv_zero' and self.area == G.jokers then
            if UNPRV.zero_armed == self then
                unprv_zero_disarm()
            elseif self.ability.extra.used then
                unprv_zero_msg(self, localize('unprv_wlog_used'))
            else
                if UNPRV.zero_armed then unprv_zero_disarm(true) end
                UNPRV.zero_armed = self
                self.ability.unprv_armed = true
                self:juice_up(0.3, 0.4)
                unprv_zero_msg(self, localize('unprv_wlog_hint'))
            end
            return
        end
        if UNPRV.zero_armed then
            if self.area == G.hand then
                if not self.ability.unprv_zero then
                    self:add_sticker('unprv_zero', true)
                    local joker = UNPRV.zero_armed
                    joker.ability.extra.used = true
                    joker.ability.extra.count = (joker.ability.extra.count or 0) + 1
                    self:juice_up(0.3, 0.5)
                    play_sound('card1', 0.9, 0.5)
                    unprv_zero_disarm(true)
                    unprv_zero_msg(joker, localize('unprv_zero_done'))
                else
                    unprv_zero_msg(UNPRV.zero_armed, localize('unprv_zero_already'))
                end
                return
            end
            if self == UNPRV.zero_armed then
                unprv_zero_disarm()
                return
            end
        end
    end
    card_click_ref(self)
end

return {
    SMODS.Joker({
        key = 'zero',
        config = { extra = { used = false, count = 0 } },
        rarity = 3,          -- Rare
        cost = 8,
        -- 占位：原版（6,4）帧，美术图集完成后换 unprv_jokers
        pos = { x = 6, y = 4 },
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,
        -- 前置条件：牌组比开局时少 6 张才会出现在商店
        in_pool = function(self, args)
            local start = G.GAME and G.GAME.unprv_start_deck or 52
            local now = G.playing_cards and #G.playing_cards or 52
            return now <= start - 6
        end,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.count, e.count * 25, e.used and localize('unprv_wlog_used') or '' } }
        end,
        calculate = function(self, card, context)
            -- 回合结束重置使用次数，并清理选择状态（重置幂等，无需按回合去重）
            if context.end_of_round and not context.blueprint then
                card.ability.extra.used = false
                if UNPRV.zero_armed == card then unprv_zero_disarm(true) end
            end
            -- 每零化一张牌永久 +25 筹码
            if context.joker_main and card.ability.extra.count > 0 then
                return {
                    message = '+' .. (card.ability.extra.count * 25),
                    chips = card.ability.extra.count * 25,
                    colour = G.C.CHIPS,
                }
            end
        end,
    }),
}
