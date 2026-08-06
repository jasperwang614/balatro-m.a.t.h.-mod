-- 悖论/幻灵槽位（设计文档 §2）：
--   悖论（Tarot 槽）：熵增、蒙提霍尔、四色定理 1976
--   幻灵（Spectral 槽）：巴拿赫-塔斯基、罗素的信
-- “下一手牌 X”类一次性效果用 mod 自身的 calculate 实现
-- （SMODS 自定义计分目标：不占卡槽、不触碰 vanilla 评分函数）。

-- 熵增：本回合下一手牌，高牌 X3 / 对子 X2（鬼抽救星）
-- 罗素的信：下一手牌 X2（配合“指定小丑失效”使用）
UNPRV.calculate = function(self, context)
    -- 一次性“下一手牌”倍率：在 initial_scoring_step 触发（该上下文在基础倍率定稿后、逐卡计分前，
    -- 且带 scoring_name）。不能用 before 上下文——那之后基础倍率会被重新赋值，X 会被冲掉。
    if context.initial_scoring_step and context.scoring_name and G.GAME then
        local xmult = nil
        if G.GAME.unprv_entropy then
            G.GAME.unprv_entropy = nil
            if context.scoring_name == 'High Card' then
                xmult = 3
            elseif context.scoring_name == 'Pair' then
                xmult = 2
            end
        elseif G.GAME.unprv_russell then
            G.GAME.unprv_russell = nil
            xmult = 2
        end
        if xmult then
            -- 直接乘全局 mult。mult 可能是普通数字，也可能是 Amulet 大数系统的
            -- OmegaNum 对象（带算术元方法的 table）；只有旧格式字符串需要先转换。
            if type(mult) == 'string' then
                mult = mod_mult(UNPRV.num(mult) * xmult)
            else
                mult = mod_mult(mult * xmult)
            end
            return {
                message = 'X' .. xmult,
                colour = G.C.XMULT,
            }
        end
    end
    -- 回合结束清理未使用的一次性效果
    if context.end_of_round then
        if G.GAME then
            G.GAME.unprv_entropy = nil
            G.GAME.unprv_russell = nil
            -- 罗素的信：回合结束给小丑解禁
            if G.GAME.unprv_russell_joker then
                local j = G.GAME.unprv_russell_joker
                G.GAME.unprv_russell_joker = nil
                if j then
                    if j.debuff then
                        j:set_debuff(false)
                    end
                    j:remove_sticker('unprv_letter')
                end
            end
        end
    end
end

-- 草稿：判定前随机抄同手其他牌的点数（保留自己的花色）
local evaluate_poker_hand_ref = evaluate_poker_hand
function evaluate_poker_hand(cards, ...)
    if G.play and G.play.cards then
        local marked
        for _, c in ipairs(G.play.cards) do
            if c.ability and c.ability.unprv_draft then
                marked = c
                break
            end
        end
        if marked then
            local others = {}
            for _, c in ipairs(G.play.cards) do
                if c ~= marked then
                    others[#others + 1] = c
                end
            end
            if #others > 0 then
                local donor = others[math.random(#others)]
                for _, base_card in pairs(G.P_CARDS) do
                    if base_card.value == donor.base.value and base_card.suit == marked.base.suit then
                        marked:set_base(base_card)
                        break
                    end
                end
            end
        end
    end
    return evaluate_poker_hand_ref(cards, ...)
end

-- 结算后：把被涂改的牌还原成原样（不污染牌组）
local evaluate_play_ref = G.FUNCS.evaluate_play
function G.FUNCS.evaluate_play(e)
    evaluate_play_ref(e)
    if G.play and G.play.cards then
        for _, c in ipairs(G.play.cards) do
            if c.ability and c.ability.unprv_draft then
                local orig = c.ability.unprv_draft_orig
                if orig then
                    for _, base_card in pairs(G.P_CARDS) do
                        if base_card.value == orig and base_card.suit == c.base.suit then
                            c:set_base(base_card)
                            break
                        end
                    end
                end
                c.ability.unprv_draft = nil
                c.ability.unprv_draft_orig = nil
                c:remove_sticker('unprv_draft')
            end
        end
    end
end

return {
    SMODS.Consumable({
        key = 'entropy',
        set = 'Tarot',
        config = { extra = {} },
        cost = 3,
        -- 占位：原版 Tarot 图集（0,2）帧，美术图集完成后换 unprv 图集
        pos = { x = 0, y = 2 },
        can_use = function(self, card)
            return true
        end,
        use = function(self, card, area, copier)
            G.GAME.unprv_entropy = true
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = localize('unprv_entropy_pending'),
                colour = G.C.XMULT,
            })
        end,
    }),
    SMODS.Consumable({
        key = 'fourcolor',
        set = 'Tarot',
        config = { extra = {} },
        cost = 3,
        -- 占位：原版 Tarot 图集（1,2）帧
        pos = { x = 1, y = 2 },
        can_use = function(self, card)
            if not G.hand or #G.hand.cards == 0 then return false end
            local suits = {}
            for _, c in ipairs(G.hand.cards) do
                suits[c.base.suit] = true
                if suits.Hearts and suits.Spades and suits.Diamonds and suits.Clubs then
                    return true
                end
            end
            return false
        end,
        use = function(self, card, area, copier)
            local target = pseudorandom_element(G.hand.cards, 'unprv_fourcolor')
            if target then
                target:set_edition({ polychrome = true }, true)
                target:juice_up(0.3, 0.5)
                play_sound('card1', 0.9, 0.5)
            end
        end,
    }),
    SMODS.Consumable({
        key = 'monty',
        set = 'Tarot',
        config = { extra = {} },
        cost = 3,
        -- 占位：原版 Tarot 图集（9,1）帧
        pos = { x = 9, y = 1 },
        can_use = function(self, card)
            return true
        end,
        use = function(self, card, area, copier)
            local function unprv_monty_draw()
                local c = SMODS.create_card({ set = 'Playing Card', area = G.hand })
                if c then
                    c:add_to_deck()
                    G.hand:emplace(c)
                    c:juice_up(0.3, 0.5)
                end
                return c
            end
            -- 50% 概率“换门”再得一张
            if unprv_monty_draw() and pseudorandom('unprv_monty') > 0.5 then
                unprv_monty_draw()
            end
        end,
    }),
    SMODS.Consumable({
        key = 'banach',
        set = 'Spectral',
        config = { extra = {} },
        cost = 4,
        -- 占位：原版 Spectral Ankh（复制主题）帧
        pos = { x = 0, y = 5 },
        can_use = function(self, card)
            return G.hand and #G.hand.highlighted >= 1
        end,
        use = function(self, card, area, copier)
            local target = G.hand.highlighted[1]
            if not target then
                return
            end
            -- 巴拿赫-塔斯基：销毁 1 张手牌，加入 2 张完全复制
            local copies = { copy_card(target, nil), copy_card(target, nil) }
            if SMODS.shatters(target) then
                target:shatter()
            else
                target:start_dissolve(nil, true)
            end
            for _, c in ipairs(copies) do
                c:add_to_deck()
                G.hand:emplace(c)
                c:juice_up(0.3, 0.5)
            end
            G.hand:unhighlight_all()
        end,
    }),
    SMODS.Consumable({
        key = 'russell',
        set = 'Spectral',
        config = { extra = {} },
        cost = 4,
        -- 占位：原版 Spectral Hex（小丑主题）帧
        pos = { x = 2, y = 5 },
        can_use = function(self, card)
            return G.jokers and #G.jokers.highlighted >= 1
        end,
        use = function(self, card, area, copier)
            local target = G.jokers.highlighted[1]
            if not target then
                return
            end
            -- 罗素的信：指定小丑失效 1 回合（原版 debuff 逻辑），下一手牌 X2
            G.GAME.unprv_russell_joker = target
            if not target.debuff then
                target:set_debuff(true)
            end
            target:add_sticker('unprv_letter', true)
            G.GAME.unprv_russell = true
            target:juice_up(0.3, 0.5)
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = localize('unprv_russell_pending'),
                colour = G.C.MULT,
            })
            G.jokers:unhighlight_all()
        end,
    }),
    SMODS.Consumable({
        key = 'draft',
        set = 'Tarot',
        config = { extra = {} },
        cost = 3,
        -- 占位：原版 Tarot 图集（2,2）帧
        pos = { x = 2, y = 2 },
        can_use = function(self, card)
            return G.hand and #G.hand.highlighted >= 1
        end,
        use = function(self, card, area, copier)
            local target = G.hand.highlighted[1]
            if not target then
                return
            end
            -- 草稿标记：记下原点数，下一次被打出时随机抄同手其他牌的点数，结算后还原
            target.ability.unprv_draft = true
            target.ability.unprv_draft_orig = target.base.value
            target:add_sticker('unprv_draft', true)
            target:juice_up(0.3, 0.5)
            G.hand:unhighlight_all()
        end,
    }),
}
