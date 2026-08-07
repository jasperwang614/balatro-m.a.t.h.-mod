-- 数学家线 · 群英会（2026-08-04 批次）
-- 毕达哥拉斯：每张计分牌 + 点数² 筹码（A=1、4、9…K=169），万物皆数
-- 黎曼：每手牌结束 +10 倍率 × 本手牌张数（黎曼和：积分累加）
-- 庞加莱：打出 3 张牌时 +25 倍率；佩雷尔曼在场则 X2（猜想已被证明）
-- 哥德尔：每手牌结束 +4 倍率；累计倍率首次超过 50 时 X2（此后不可证明）
-- 希尔伯特：手牌上限 +2（原版 h_size 机制）；回合结束随机一张手牌获得随机版本（希尔伯特旅馆）
-- 菲尔兹奖：每有 1 张数学家小丑 +30 倍率、+15 筹码；回合结束每张 +$1

local function unprv_has_joker(key)
    for _, j in ipairs(G.jokers and G.jokers.cards or {}) do
        if j.config.center.key == key then
            return true
        end
    end
    return false
end

-- 菲尔兹奖的“数学家”注册表：新增数学家卡时记得同步这里（伯努利家族按 8 位计）
local MATH_JOKERS = {
    ["j_unprv_chen"] = true,
    ["j_unprv_gauss"] = true,
    ["j_unprv_wiles"] = true,
    ["j_unprv_euler"] = true,
    ["j_unprv_ramanujan"] = true,
    ["j_unprv_galois"] = true,
    ["j_unprv_zhang"] = true,
    ["j_unprv_perelman"] = true,
    ["j_unprv_calabiyau"] = true,
    ["j_unprv_margin"] = true,
    ["j_unprv_shannon"] = true,
    ["j_unprv_pythagoras"] = true,
    ["j_unprv_riemann"] = true,
    ["j_unprv_poincare"] = true,
    ["j_unprv_godel"] = true,
    ["j_unprv_hilbert"] = true,
    ["j_unprv_vonneumann"] = true,
    ["j_unprv_lovelace"] = true,
    ["j_unprv_newton"] = true,
    ["j_unprv_leibniz"] = true,
    ["j_unprv_bernoulli"] = true,
}

local function unprv_count_mathematicians()
    local n = 0
    for _, j in ipairs(G.jokers and G.jokers.cards or {}) do
        local key = j.config.center.key
        if key == 'j_unprv_bernoulli' then
            -- 伯努利家族：一门八杰，按 8 位数学家计数
            n = n + 8
        elseif MATH_JOKERS[key] then
            n = n + 1
        end
    end
    return n
end

return {
    items = {
        SMODS.Joker({
            key = "pythagoras",
            config = {
                extra = {},
            },
            rarity = 3,          -- Rare
            cost = 8,
            -- 占位：原版图集（3,0）帧，美术图集完成后换 unprv_jokers
            pos = { x = 3, y = 0 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 30,
            calculate = function(self, card, context)
                -- 每张计分牌 + 点数² 筹码（A=14 → 196、K=13 → 169）
                if context.individual and context.cardarea == G.play then
                    local id = context.other_card:get_id()
                    if id then
                        local chips = id * id
                        return {
                            message = "+" .. chips,
                            chips = chips,
                            colour = G.C.CHIPS,
                        }
                    end
                end
            end,
        }),
        SMODS.Joker({
            key = "riemann",
            config = {
                extra = { mult = 0, mult_per_card = 10 },
            },
            rarity = 3,          -- Rare
            cost = 7,
            -- 占位：原版图集（8,0）帧，美术图集完成后换 unprv_jokers
            pos = { x = 8, y = 0 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 31,
            loc_vars = function(self, info_queue, center)
                return { vars = { center.ability.extra.mult_per_card } }
            end,
            calculate = function(self, card, context)
                -- 黎曼和：每手牌结束 +10 倍率 × 本手牌张数（积分累加）
                if context.joker_main then
                    local e = card.ability.extra
                    if not context.blueprint and not context.retrigger_joker then
                        e.mult = e.mult + e.mult_per_card * #(context.full_hand or {})
                    end
                    if e.mult > 0 then
                        return {
                            message = "+" .. e.mult,
                            mult = e.mult,
                            colour = G.C.MULT,
                        }
                    end
                end
            end,
        }),
        SMODS.Joker({
            key = "poincare",
            config = {
                extra = { mult = 25, x_mult = 2 },
            },
            rarity = 3,          -- Rare
            cost = 8,
            -- 占位：原版图集（9,0）帧，美术图集完成后换 unprv_jokers
            pos = { x = 9, y = 0 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 32,
            loc_vars = function(self, info_queue, center)
                return { vars = { center.ability.extra.mult, center.ability.extra.x_mult } }
            end,
            calculate = function(self, card, context)
                -- 打出 3 张牌时 +25 倍率；佩雷尔曼在场则 X2
                if context.joker_main then
                    if #(context.full_hand or {}) == 3 then
                        if unprv_has_joker("j_unprv_perelman") then
                            return {
                                message = localize{ type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } },
                                xmult = card.ability.extra.x_mult,
                                colour = G.C.XMULT,
                            }
                        end
                        return {
                            message = "+" .. card.ability.extra.mult,
                            mult = card.ability.extra.mult,
                            colour = G.C.MULT,
                        }
                    end
                end
            end,
        }),
        SMODS.Joker({
            key = "godel",
            config = {
                extra = { mult = 0, per_hand = 4, threshold = 50, milestone = false },
            },
            rarity = 3,          -- Rare
            cost = 7,
            -- 占位：原版图集（0,1）帧，美术图集完成后换 unprv_jokers
            pos = { x = 0, y = 1 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 33,
            loc_vars = function(self, info_queue, center)
                local e = center.ability.extra
                return { vars = { e.per_hand, e.threshold } }
            end,
            calculate = function(self, card, context)
                -- 每手牌结束 +4 倍率；累计倍率首次超过 50 时 X2（自指梗）
                if context.joker_main then
                    local e = card.ability.extra
                    if not context.blueprint and not context.retrigger_joker then
                        e.mult = e.mult + e.per_hand
                    end
                    if e.mult > 0 then
                        if not e.milestone and e.mult > e.threshold then
                            e.milestone = true
                            return {
                                message = "X2",
                                mult = e.mult,
                                xmult = 2,
                                colour = G.C.XMULT,
                            }
                        end
                        return {
                            message = "+" .. e.mult,
                            mult = e.mult,
                            colour = G.C.MULT,
                        }
                    end
                end
            end,
        }),
        SMODS.Joker({
            key = "hilbert",
            config = {
                h_size = 2,          -- 原版机制：入场自动 +2 手牌上限（Juggler 同款）
                extra = { counted_round = 0 },
            },
            rarity = 2,          -- Uncommon（无联动时版本效果难触发，定为罕见）
            cost = 6,
            -- 占位：原版图集（4,1）帧，美术图集完成后换 unprv_jokers
            pos = { x = 4, y = 1 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 34,
            loc_vars = function(self, info_queue, center)
                return { vars = { center.ability.h_size } }
            end,
            calculate = function(self, card, context)
                -- 回合结束手牌恰好等于上限时（只有中途超过上限才可能）：
                -- 随机一张手牌获得随机版本（闪箔/全息/多彩）
                if context.end_of_round and context.main_eval and not context.individual and not context.blueprint and not context.retrigger_joker then
                    local e = card.ability.extra
                    if e.counted_round ~= G.GAME.round then
                        e.counted_round = G.GAME.round
                        local hand = G.hand and G.hand.cards
                        local total = G.hand and G.hand.config and (
                            (G.hand.config.card_limits and G.hand.config.card_limits.total_slots)
                            or G.hand.config.card_limit or 8)
                        if total and hand and #hand == total then
                            -- 优先挑没有版本的牌，最多试 5 次
                            local picked
                            for i = 1, 5 do
                                local cand = hand[math.random(#hand)]
                                picked = cand
                                if not cand.edition then
                                    break
                                end
                            end
                            local eds = { "holo", "foil", "polychrome" }
                            local ed = eds[math.random(#eds)]
                            picked:set_edition({ [ed] = true }, true)
                            picked:juice_up(0.3, 0.4)
                            return {
                                message = "随机版本",
                                colour = G.C.FILTER,
                            }
                        end
                    end
                end
            end,
        }),
        SMODS.Joker({
            key = "fields",
            config = {
                extra = { mult = 30, chips = 15, counted_round = 0 },
            },
            rarity = 3,          -- Rare
            cost = 10,
            atlas = 'unprv_jokers',
            pos = { x = 0, y = 0 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 35,
            loc_vars = function(self, info_queue, center)
                local n = 0
                if G.jokers and G.jokers.cards then
                    n = unprv_count_mathematicians()
                end
                return { vars = { center.ability.extra.mult, center.ability.extra.chips, n } }
            end,
            calculate = function(self, card, context)
                local e = card.ability.extra
                -- 计分：每张数学家小丑 +30 倍率、+15 筹码
                if context.joker_main then
                    local n = unprv_count_mathematicians()
                    if n > 0 then
                        return {
                            message = "+" .. (e.mult * n) .. " / +" .. (e.chips * n),
                            mult = e.mult * n,
                            chips = e.chips * n,
                            colour = G.C.MULT,
                        }
                    end
                end
                -- 回合结束：每张数学家小丑 +$1
                if context.end_of_round and context.main_eval and not context.individual and not context.blueprint and not context.retrigger_joker then
                    if e.counted_round ~= G.GAME.round then
                        e.counted_round = G.GAME.round
                        local n = unprv_count_mathematicians()
                        if n > 0 then
                            return {
                                message = "+$" .. n,
                                dollars = n,
                                colour = G.C.MONEY,
                            }
                        end
                    end
                end
            end,
        }),
    },
}
