-- 传承链 · Extinction Chains（设计文档 §3.1）
-- 约率 22/7 → 密率 · √2 → 无理数时代 · 决斗前夜 → 群论（在 events.lua 挂接）

-- 密率入池门槛：约率被超越解锁前，密率不进商店（数学小丑包过滤共用 banned_keys）
local game_update_shop_ref = Game.update_shop
function Game:update_shop(dt)
    if G.GAME then
        if G.GAME.unprv_zuratio_unlocked then
            G.GAME.banned_keys["j_unprv_zuratio"] = nil
        else
            G.GAME.banned_keys["j_unprv_zuratio"] = true
        end
    end
    game_update_shop_ref(self, dt)
end

return {
    items = {
        SMODS.Joker({
            key = 'twoseven',  -- 约率 22/7
            config = {
                extra = { x_mult = 1.5, counted_round = 0 },
            },
            rarity = 1,          -- Common
            cost = 4,
            -- 占位：原版（3,1）帧
            pos = { x = 3, y = 1 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 40,
            calculate = function(self, card, context)
                -- 计分含 2 和 7：X1.5
                if context.joker_main then
                    local has2, has7 = false, false
                    for _, c in ipairs(context.scoring_hand or {}) do
                        local id = c:get_id()
                        if id == 2 then
                            has2 = true
                        elseif id == 7 then
                            has7 = true
                        end
                    end
                    if has2 and has7 then
                        return {
                            message = 'X1.5',
                            xmult = card.ability.extra.x_mult,
                            colour = G.C.MULT,
                        }
                    end
                end
                -- 每回合 1/6 概率被祖冲之超越销毁 → 解锁密率
                if context.end_of_round and context.main_eval and not context.individual and not context.blueprint and not context.retrigger_joker then
                    local e = card.ability.extra
                    if e.counted_round ~= G.GAME.round then
                        e.counted_round = G.GAME.round
                        if pseudorandom('unprv_yuelv') < 1 / 6 then
                            G.GAME.unprv_zuratio_unlocked = true
                            card_eval_status_text(card, 'extra', nil, nil, nil, {
                                message = '被祖冲之超越',
                                colour = G.C.FILTER,
                            })
                            card:start_dissolve(nil, true)
                        end
                    end
                end
            end,
        }),
        SMODS.Joker({
            key = 'sqrt2',  -- √2
            config = {
                extra = { x_mult = 1.414, counted_round = 0 },
            },
            rarity = 2,          -- Uncommon
            cost = 6,
            -- 占位：原版（6,1）帧
            pos = { x = 6, y = 1 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 41,
            calculate = function(self, card, context)
                -- 每张计分 2：X1.414
                if context.individual and context.cardarea == G.play then
                    if context.other_card:get_id() == 2 then
                        return {
                            message = 'X1.414',
                            xmult = card.ability.extra.x_mult,
                            colour = G.C.MULT,
                        }
                    end
                end
                -- 每回合 1/8 概率被扔进海里销毁 → 生成无理数时代
                if context.end_of_round and context.main_eval and not context.individual and not context.blueprint and not context.retrigger_joker then
                    local e = card.ability.extra
                    if e.counted_round ~= G.GAME.round then
                        e.counted_round = G.GAME.round
                        if pseudorandom('unprv_sqrt2') < 1 / 8 then
                            add_joker('j_unprv_irrational', nil, true)
                            card_eval_status_text(card, 'extra', nil, nil, nil, {
                                message = '被扔进海里',
                                colour = G.C.FILTER,
                            })
                            card:start_dissolve(nil, true)
                        end
                    end
                end
            end,
        }),
        SMODS.Joker({
            key = 'irrational',  -- 无理数时代
            config = {
                extra = { x_mult = 14.1 },
            },
            rarity = 3,          -- Rare
            cost = 8,
            -- 占位：原版（5,1）帧
            pos = { x = 5, y = 1 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 42,
            calculate = function(self, card, context)
                -- 每张计分偶数牌（2/4/6/8/10/Q/A）：X14.1（√2 前三位 1、4、1 化作 14.1）
                if context.individual and context.cardarea == G.play then
                    local id = context.other_card:get_id()
                    if id and id % 2 == 0 then
                        return {
                            message = 'X14.1',
                            xmult = card.ability.extra.x_mult,
                            colour = G.C.MULT,
                        }
                    end
                end
            end,
        }),
        SMODS.Joker({
            key = 'group_theory',  -- 群论
            config = {
                extra = { x_mult = 5 },
            },
            rarity = 4,          -- Legendary
            cost = 20,
            -- 占位：原版（4,1）帧
            pos = { x = 4, y = 1 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 43,
            calculate = function(self, card, context)
                -- 仅剩 1 次出牌机会：X5
                if context.joker_main then
                    if G.GAME.current_round and G.GAME.current_round.hands_left == 0 then
                        return {
                            message = 'X5',
                            xmult = card.ability.extra.x_mult,
                            colour = G.C.XMULT,
                        }
                    end
                end
            end,
        }),
    },
}
