-- 熵线 · 秩序与无序（设计文档 §2.3）
return {
    items = {
        SMODS.Joker({
            key = "shannon",
            config = {
                extra = { per_rank = 6 },
            },
            rarity = 2,          -- Uncommon
            cost = 6,
            -- 占位：原版 Abstract（信息/抽象主题）
            pos = { x = 3, y = 3 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 10,
            calculate = function(self, card, context)
                if context.joker_main then
                    local seen = {}
                    for _, c in ipairs(context.full_hand) do
                        seen[c:get_id()] = true
                    end
                    local n = 0
                    for _ in pairs(seen) do
                        n = n + 1
                    end
                    if n > 0 then
                        return {
                            message = "+" .. n * card.ability.extra.per_rank,
                            mult = n * card.ability.extra.per_rank,
                            colour = G.C.MULT,
                        }
                    end
                end
            end,
        }),
        SMODS.Joker({
            key = "binary",
            config = {
                extra = { shift = 2, odd_mult = 1 },
            },
            rarity = 3,          -- Rare
            cost = 8,
            -- 占位：原版 Blackboard（二进制课堂）
            pos = { x = 2, y = 10 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 11,
            calculate = function(self, card, context)
                -- 左移位：偶数计分牌筹码 ×2；奇数计分牌 +1 倍率。
                -- 硅族（石头、玻璃）双吃两效果——隐藏彩蛋，不进描述。
                if context.joker_main then
                    local evens, odds = 0, 0
                    for _, c in ipairs(context.scoring_hand) do
                        local center_key = c.config.center and c.config.center.key
                        local is_silicon = center_key == "m_stone" or center_key == "m_glass"
                            or (c.config.center and c.config.center.no_rank and c.config.center.no_suit)
                        if is_silicon then
                            evens = evens + 1
                            odds = odds + 1
                        else
                            local id = c:get_id()
                            if id % 2 == 0 then
                                evens = evens + 1
                            else
                                odds = odds + 1
                            end
                        end
                    end
                    if evens > 0 or odds > 0 then
                        local cur = G.GAME.current_round.current_hand
                        local shift = card.ability.extra.shift ^ evens
                        local cur_chips = UNPRV.num(cur.chips)
                        return {
                            message = "+" .. card.ability.extra.odd_mult * odds .. " / ×" .. shift,
                            chips = cur_chips * shift - cur_chips,
                            mult = card.ability.extra.odd_mult * odds,
                            colour = G.C.MULT,
                        }
                    end
                end
            end,
        }),
        SMODS.Joker({
            key = "heatdeath",
            config = {
                extra = { min_mult = 4, max_mult = 12 },
            },
            rarity = 3,          -- Rare
            cost = 8,
            -- 占位：原版 Red Card（热寂主题）
            pos = { x = 7, y = 11 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 12,
            calculate = function(self, card, context)
                -- 热寂：每回合首出随机 X4~X12，之后每次出牌减半（最低 X1），回合结束重置
                if context.end_of_round and not context.retrigger_joker and not context.blueprint then
                    card.ability.extra.round_hands = nil
                    card.ability.extra.current = nil
                end
                if context.joker_main then
                    local e = card.ability.extra
                    e.round_hands = (e.round_hands or 0) + 1
                    if e.round_hands == 1 then
                        e.current = e.min_mult + math.floor(pseudorandom("unprv_heatdeath_" .. G.GAME.round) * (e.max_mult - e.min_mult + 1))
                    else
                        e.current = math.max(1, math.floor(e.current * 0.5))
                    end
                    return {
                        message = "X" .. e.current,
                        xmult = e.current,
                        colour = G.C.MULT,
                    }
                end
            end,
        }),
        SMODS.Joker({
            key = "maxwell",
            config = {
                extra = { count = 5, x_mult = 4 },
            },
            rarity = 3,          -- Rare
            cost = 8,
            -- 占位：原版（6,8）帧，美术图集完成后换 unprv_jokers
            pos = { x = 6, y = 8 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 13,
            calculate = function(self, card, context)
                -- 麦克斯韦妖：5 张计分牌点数严格单调（递增或递减）→ X4
                if context.joker_main then
                    local ids = {}
                    for _, c in ipairs(context.scoring_hand) do
                        ids[#ids + 1] = c:get_id()
                    end
                    if #ids == card.ability.extra.count then
                        local inc, dec = true, true
                        for i = 2, #ids do
                            if ids[i] <= ids[i - 1] then inc = false end
                            if ids[i] >= ids[i - 1] then dec = false end
                        end
                        if inc or dec then
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
    },
}
