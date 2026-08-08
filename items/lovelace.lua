-- 阿达·洛芙莱斯：冯·诺依曼的隔代搭档（设计 2026-08-06）
-- 冯·诺依曼在场时，将其累计倍率 M 转化为本手牌 X(1.01)^M
-- 风味：她为不存在的机器写程序，一百年后机器终于造好了。

return {
    items = {
        SMODS.Joker({
            key = 'lovelace',
            config = {
                extra = { mult = 8, base = 1.01 },
            },
            rarity = 3,          -- Rare
            cost = 8,
            atlas = 'unprv_jokers',
            pos = { x = 3, y = 0 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 37,
            loc_vars = function(self, info_queue, center)
                local e = center.ability.extra
                return { vars = { e.mult, e.base } }
            end,
            calculate = function(self, card, context)
                -- 基础效果：每手牌 +8 倍率（她写下了第一个算法）
                -- 找场上的冯·诺依曼本体（无词条的那张，累计倍率存在它身上）
                if context.joker_main then
                    local vn = nil
                    for _, j in ipairs(G.jokers and G.jokers.cards or {}) do
                        if j.config.center.key == 'j_unprv_vonneumann' and not j.ability.extra.augment then
                            vn = j
                            break
                        end
                    end
                    if vn then
                        local m = vn.ability.extra.mult or 0
                        if m > 0 then
                            local x = card.ability.extra.base ^ m
                            return {
                                message = '+8 / X' .. string.format('%.2f', x),
                                mult = card.ability.extra.mult,
                                xmult = x,
                                colour = G.C.XMULT,
                            }
                        end
                    end
                    return {
                        message = '+' .. card.ability.extra.mult,
                        mult = card.ability.extra.mult,
                        colour = G.C.MULT,
                    }
                end
            end,
        }),
    },
}
