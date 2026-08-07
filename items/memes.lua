-- 梗线 · 快乐与传播（设计文档 §2.4）
-- e：自然常数。核弹定位；商店池门槛：连续 3 手牌得分递增 + 累计 $27 利息
-- （连续递增 = (1+1/n)ⁿ 单调逼近 e 的极限；利息呼应 e 在连续复利中的地位）。

-- 奇变偶不变：奇数牌 +1 永久变偶（3→4、5→6、7→8、9→10、J→Q、K→A）
local function is_odd_card(c)
    local id = c:get_id()
    return id == 3 or id == 5 or id == 7 or id == 9 or id == 11 or id == 13
end

local function odd_to_even(card)
    local id = card:get_id()
    local new_rank
    if id == 3 then new_rank = "4"
    elseif id == 5 then new_rank = "6"
    elseif id == 7 then new_rank = "8"
    elseif id == 9 then new_rank = "10"
    elseif id == 11 then new_rank = "Queen"
    elseif id == 13 then new_rank = "Ace" end
    if new_rank then
        for _, base_card in pairs(G.P_CARDS) do
            if base_card.value == new_rank and base_card.suit == card.base.suit then
                card:set_base(base_card)
                if G.GAME and G.GAME.blind then
                    G.GAME.blind:debuff_card(card)
                end
                return true
            end
        end
    end
    return false
end

-- ===== e 的解锁门槛钩子 =====
-- 每手牌结算后：连续得分递增追踪（方案 A：连续 3 手每手都高于上一手）
local evaluate_play_ref = G.FUNCS.evaluate_play
function G.FUNCS.evaluate_play(e)
    evaluate_play_ref(e)
    if G.GAME and G.GAME.current_round and G.GAME.current_round.current_hand then
        local score = G.GAME.current_round.current_hand.chip_total or 0
        local last = G.GAME.unprv_e_last_score
        if last == nil then
            G.GAME.unprv_e_streak = 1
        elseif score > last then
            G.GAME.unprv_e_streak = (G.GAME.unprv_e_streak or 1) + 1
        else
            G.GAME.unprv_e_streak = 1
        end
        G.GAME.unprv_e_last_score = score
        if G.GAME.unprv_e_streak >= 3 then
            G.GAME.unprv_e_streak_met = true
        end
    end
end

-- 记录每回合开始时的余额（用于推算本回合利息；new_round 才是回合初始化）
local new_round_ref = new_round
function new_round()
    new_round_ref()
    if G.GAME then
        G.GAME.unprv_round_start_dollars = G.GAME.dollars
        G.GAME.unprv_shop_pending = true
    end
end

-- 进商店前：累计利息 + 更新 e 的入池门槛（banned_keys 会过滤商店与小丑包）
local game_update_shop_ref = Game.update_shop
function Game:update_shop(dt)
    if G.GAME then
        if G.GAME.unprv_shop_pending then
            local base = G.GAME.unprv_round_start_dollars or G.GAME.dollars
            local interest = 0
            if base >= 5 and not (G.GAME.modifiers and G.GAME.modifiers.no_interest) then
                interest = G.GAME.interest_amount * math.min(math.floor(base / 5), G.GAME.interest_cap / 5)
            end
            G.GAME.unprv_interest_total = (G.GAME.unprv_interest_total or 0) + interest
            G.GAME.unprv_shop_pending = false
        end
        if G.GAME.unprv_e_streak_met and (G.GAME.unprv_interest_total or 0) >= 27 then
            G.GAME.banned_keys["j_unprv_euler"] = nil
        else
            G.GAME.banned_keys["j_unprv_euler"] = true
        end
    end
    game_update_shop_ref(self, dt)
end

return {
    items = {
        SMODS.Joker({
            key = "euler",
            config = {
                extra = {
                    e = 2.718281828459045,
                    chips_chance = 0.73,
                },
            },
            rarity = 3,          -- Rare（核弹定位，价格显示 ≈3，UI 层暂按 $3）
            cost = 3,
            -- 占位：原版 Joker（$1 基础小丑），美术图集完成后换 unprv_jokers
            pos = { x = 0, y = 0 },
            blueprint_compat = true,   -- 蓝图/头脑风暴不禁用（定稿）
            eternal_compat = true,
            perishable_compat = true,
            order = 3,

            calculate = function(self, card, context)
                if context.joker_main then
                    local e = card.ability.extra.e
                    local hand = context.full_hand
                    -- 彩蛋：2、7、A（视作 1）、8 同场必触发（2.718…）
                    local has2, has7, hasA, has8 = false, false, false, false
                    for _, played_card in ipairs(hand) do
                        local id = played_card:get_id()
                        if id == 2 then
                            has2 = true
                        elseif id == 7 then
                            has7 = true
                        elseif id == 1 or id == 14 then
                            hasA = true
                        elseif id == 8 then
                            has8 = true
                        end
                    end
                    local trigger = (has2 and has7 and hasA and has8)
                        or (pseudorandom("unprv_euler") < math.min(1, e / #hand))
                    if trigger then
                        local cur = G.GAME.current_round.current_hand
                        local n = #hand
                        local cur_chips = UNPRV.num(cur.chips)
                        local cur_mult = UNPRV.num(cur.mult)
                        if pseudorandom("unprv_euler_choice") < card.ability.extra.chips_chance then
                            return {
                                message = localize("unprv_e_chips"),
                                chips = (cur_chips ^ e - cur_chips) * n,
                                colour = G.C.CHIPS,
                            }
                        else
                            return {
                                message = localize("unprv_e_mult"),
                                mult = (cur_mult ^ e - cur_mult) * n,
                                colour = G.C.MULT,
                            }
                        end
                    end
                end
            end,
        }),
        SMODS.Joker({
            key = "seventythree",
            config = {
                extra = { x_mult = 4.73 },
            },
            rarity = 2,          -- Uncommon
            cost = 5,
            -- 占位：原版 Odd Todd（7、3 都是奇数）
            pos = { x = 9, y = 3 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 10,
            calculate = function(self, card, context)
                if context.joker_main then
                    local has7, has3 = false, false
                    for _, c in ipairs(context.full_hand) do
                        local id = c:get_id()
                        if id == 7 then
                            has7 = true
                        elseif id == 3 then
                            has3 = true
                        end
                    end
                    if has7 and has3 then
                        return {
                            message = localize{ type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } },
                            xmult = card.ability.extra.x_mult,
                            colour = G.C.MULT,
                        }
                    end
                end
            end,
        }),
        SMODS.Joker({
            key = "nines",
            config = {
                extra = { chips = 10 },
            },
            rarity = 2,          -- Uncommon
            cost = 6,
            -- 占位：原版 Misprint（数字错印 = 0.999 梗）
            pos = { x = 6, y = 2 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 11,
            calculate = function(self, card, context)
                if context.joker_main then
                    local hand = context.full_hand
                    local all_nines = #hand > 0
                    for _, c in ipairs(hand) do
                        if c:get_id() ~= 9 then
                            all_nines = false
                            break
                        end
                    end
                    if all_nines then
                        return {
                            message = "+" .. card.ability.extra.chips,
                            chips = card.ability.extra.chips,
                            colour = G.C.CHIPS,
                        }
                    end
                end
            end,
        }),
        SMODS.Joker({
            key = "oneten",
            config = {
                extra = { per_ace = 10 },
            },
            rarity = 2,          -- Uncommon
            cost = 5,
            -- 占位：原版 Scholar（A 主题）
            pos = { x = 0, y = 4 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 12,
            calculate = function(self, card, context)
                if context.joker_main then
                    local aces = 0
                    for _, c in ipairs(context.full_hand) do
                        if c:get_id() == 14 then
                            aces = aces + 1
                        end
                    end
                    if aces >= 2 then
                        local bonus = aces * card.ability.extra.per_ace
                        return {
                            message = "+" .. bonus,
                            chips = bonus,
                            colour = G.C.CHIPS,
                        }
                    end
                end
            end,
        }),
        SMODS.Joker({
            key = "symmetry",
            config = {
                extra = { x_mult = 2 },
            },
            rarity = 2,          -- Uncommon
            cost = 6,
            -- 占位：原版 Seeing Double
            pos = { x = 4, y = 4 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 13,
            calculate = function(self, card, context)
                if context.joker_main then
                    local ids = {}
                    for _, c in ipairs(context.full_hand) do
                        ids[#ids + 1] = c:get_id()
                    end
                    if #ids >= 3 then
                        local pal = true
                        for i = 1, math.floor(#ids / 2) do
                            if ids[i] ~= ids[#ids - i + 1] then
                                pal = false
                                break
                            end
                        end
                        if pal then
                            return {
                                message = localize{ type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } },
                                xmult = card.ability.extra.x_mult,
                                colour = G.C.MULT,
                            }
                        end
                    end
                end
            end,
        }),
        SMODS.Joker({
            key = "oddeven",
            config = {
                extra = { sell_increase = 2 },
            },
            rarity = 3,          -- Rare（升级为转换引擎）
            cost = 12,
            -- 占位：原版 Half
            pos = { x = 7, y = 0 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 14,
            loc_vars = function(self, info_queue, center)
                return { vars = { center.ability.extra.sell_increase } }
            end,
            calculate = function(self, card, context)
                -- 每回合第一手牌：保证最多 3 张奇数（牌堆有就补），并全部变偶
                if context.first_hand_drawn then
                    local hand = G.hand.cards
                    local odds, non_odds = {}, {}
                    for _, c in ipairs(hand) do
                        if is_odd_card(c) then
                            odds[#odds + 1] = c
                        else
                            non_odds[#non_odds + 1] = c
                        end
                    end
                    local needed = math.max(0, 3 - #odds)
                    if needed > 0 and #non_odds > 0 and G.deck and G.deck.cards then
                        local deck_cards = G.deck.cards
                        local i = #deck_cards
                        while needed > 0 and i >= 1 do
                            local dc = deck_cards[i]
                            if is_odd_card(dc) and dc.area then
                                local swap_out = table.remove(non_odds)
                                if swap_out.area then
                                    swap_out.area:remove_card(swap_out)
                                    dc.area:remove_card(dc)
                                    swap_out:add_to_deck()
                                    G.deck:emplace(swap_out)
                                    dc:add_to_deck()
                                    G.hand:emplace(dc)
                                    odds[#odds + 1] = dc
                                    needed = needed - 1
                                end
                            end
                            i = i - 1
                        end
                    end
                    local transformed = 0
                    for _, c in ipairs(odds) do
                        if is_odd_card(c) and not c.unprv_oddeven then
                            c.unprv_oddeven = true
                            transformed = transformed + 1
                            -- 变化动画：先翻面（露出奇数原样）→ 牌背朝上时变牌 → 翻回揭示新点数
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after', delay = 0.8,
                                func = function()
                                    c:flip()
                                    return true
                                end
                            }))
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after', delay = 1.15,
                                func = function()
                                    odd_to_even(c)
                                    c:flip()
                                    c:juice_up(0.2, 0.3)
                                    play_sound('magic_crumple2')
                                    return true
                                end
                            }))
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after', delay = 1.5,
                                func = function()
                                    card_eval_status_text(c, 'extra', nil, nil, nil, { message = "+1", colour = G.C.CHIPS })
                                    return true
                                end
                            }))
                        end
                    end
                    if transformed > 0 then
                        card.ability.extra_value = (card.ability.extra_value or 0) + card.ability.extra.sell_increase * transformed
                        card:set_cost()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = "$+" .. card.ability.extra.sell_increase * transformed,
                            colour = G.C.MONEY,
                        })
                    end
                end
            end,
        }),
        SMODS.Joker({
            key = "montecarlo",
            config = {
                extra = { samples = 100, min_mult = 1, max_mult = 3 },
            },
            rarity = 2,          -- Uncommon
            cost = 6,
            -- 占位：原版 Lucky Cat（赌场主题）
            pos = { x = 5, y = 14 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 15,
            calculate = function(self, card, context)
                if context.joker_main then
                    local e = card.ability.extra
                    local seed_key = "unprv_montecarlo_" .. G.GAME.round_resets.ante .. "_" .. (G.GAME.current_round.hands_played or 0)
                    local inside = 0
                    for i = 1, e.samples do
                        local x = pseudorandom(seed_key .. "_x" .. i)
                        local y = pseudorandom(seed_key .. "_y" .. i)
                        if x * x + y * y <= 1 then
                            inside = inside + 1
                        end
                    end
                    local est = 4 * inside / e.samples
                    local acc = math.max(0, 1 - math.abs(est - math.pi) / 0.5)
                    local xmult = e.min_mult + (e.max_mult - e.min_mult) * acc
                    return {
                        message = string.format("π≈%.3f", est),
                        xmult = xmult,
                        colour = G.C.MULT,
                    }
                end
            end,
        }),
        SMODS.Joker({
            key = "pareto",
            config = {
                extra = { x_mult = 4 },
            },
            rarity = 2,          -- Uncommon
            cost = 6,
            -- 占位：原版 Ice Cream
            pos = { x = 4, y = 10 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 16,
            calculate = function(self, card, context)
                -- 二八定律：本手牌只打出 1 张 → X4
                if context.joker_main and #context.full_hand == 1 then
                    return {
                        message = localize{ type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } },
                        xmult = card.ability.extra.x_mult,
                        colour = G.C.MULT,
                    }
                end
            end,
        }),
        SMODS.Joker({
            key = "centrallimit",
            config = {
                extra = {
                    bonus = { [7] = 8, [6] = 6, [8] = 6, [5] = 4, [9] = 4, [4] = 2, [10] = 2 },
                },
            },
            rarity = 2,          -- Uncommon
            cost = 6,
            -- 占位：原版 Blue Joker
            pos = { x = 7, y = 10 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 17,
            calculate = function(self, card, context)
                -- 中心极限：点数越接近均值 7，奖励越高
                if context.joker_main then
                    local total = 0
                    for _, c in ipairs(context.full_hand) do
                        total = total + (card.ability.extra.bonus[c:get_id()] or 0)
                    end
                    if total > 0 then
                        return {
                            message = "+" .. total,
                            mult = total,
                            colour = G.C.MULT,
                        }
                    end
                end
            end,
        }),
        SMODS.Joker({
            key = "notice",
            config = {
                extra = { x_mult = 2 },
            },
            rarity = 2,          -- Uncommon（梗线招牌）
            cost = 5,
            -- 占位：原版（1,4）帧，美术图集完成后换 unprv_jokers
            pos = { x = 1, y = 4 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 18,
            calculate = function(self, card, context)
                -- 注意到：每回合第一手牌抽齐后随机“注意到”1 张手牌，
                -- 直接打上角标贴纸（unprv_notice），该牌本回合计分 X2
                if context.first_hand_drawn and not context.blueprint then
                    local e = card.ability.extra
                    if not e.round_picked then
                        e.round_picked = true
                        if G.hand and #G.hand.cards > 0 then
                            local picked = pseudorandom_element(G.hand.cards, "unprv_notice_" .. G.GAME.round)
                            if picked then
                                if e.noticed_card then
                                    e.noticed_card:remove_sticker('unprv_notice')
                                end
                                picked:add_sticker('unprv_notice', true)
                                e.noticed_card = picked
                                picked:juice_up(0.2, 0.3)
                            end
                        end
                    end
                end
                if context.individual and context.cardarea == G.play then
                    if context.other_card.ability.unprv_notice then
                        return {
                            message = localize{ type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } },
                            xmult = card.ability.extra.x_mult,
                            colour = G.C.MULT,
                        }
                    end
                end
                if context.end_of_round and not context.blueprint and not context.retrigger_joker then
                    local e = card.ability.extra
                    e.round_picked = nil
                    if e.noticed_card then
                        e.noticed_card:remove_sticker('unprv_notice')
                    end
                    e.noticed_card = nil
                end
            end,
        }),
        SMODS.Joker({
            key = "q84",
            config = {
                extra = { x_mult = 1984 },
            },
            rarity = 3,          -- Rare
            cost = 8,
            -- 占位：原版（1,1）帧
            pos = { x = 1, y = 1 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 47,
            calculate = function(self, card, context)
                -- 隐藏条件：打出的牌严格按 1984（A-9-8-4）或 1Q84（A-Q-8-4）顺序
                if context.joker_main then
                    local ids = {}
                    for _, c in ipairs(context.full_hand or {}) do
                        ids[#ids + 1] = c:get_id()
                    end
                    if #ids == 4 then
                        local ok1984 = ids[1] == 14 and ids[2] == 9 and ids[3] == 8 and ids[4] == 4
                        local ok1q84 = ids[1] == 14 and ids[2] == 12 and ids[3] == 8 and ids[4] == 4
                        if ok1984 or ok1q84 then
                            return {
                                message = 'X1984',
                                xmult = card.ability.extra.x_mult,
                                colour = G.C.XMULT,
                            }
                        end
                    end
                end
            end,
        }),
    },
}
