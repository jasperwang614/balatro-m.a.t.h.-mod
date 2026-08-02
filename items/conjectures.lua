-- 猜想线 · 未解之谜（设计文档 §2.1）
-- 冰雹猜想 Hailstone：每张计分数字牌按 3n+1 总停止时间（到 1 的步数）加倍率。
-- 步数表与 OEIS A006577 一致：2→1, 3→7, 4→2, 5→5, 6→8, 7→16, 8→3, 9→19, 10→6。
return {
    items = {
        SMODS.Joker({
            key = "hailstone",
            config = {
                extra = {
                    step_mult = 1,
                    steps = {
                        [2] = 1, [3] = 7, [4] = 2, [5] = 5,
                        [6] = 8, [7] = 16, [8] = 3, [9] = 19, [10] = 6,
                    },
                },
            },
            rarity = 2,          -- Uncommon
            cost = 6,
            -- 占位：不写 atlas（SMODS 默认用原版 Joker 图集），
            -- pos 指向原版 Fibonacci 小丑的帧；美术图集完成后换 unprv_jokers。
            pos = { x = 1, y = 5 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 1,

            loc_vars = function(self, info_queue, center)
                return { vars = { center.ability.extra.step_mult } }
            end,

            calculate = function(self, card, context)
                -- 每张计分数字牌（2~10）按步数表 +N 倍率
                if context.individual and context.cardarea == G.play then
                    local steps = card.ability.extra.steps[context.other_card:get_id()]
                    if steps then
                        return {
                            message = "+" .. steps,
                            mult = steps * card.ability.extra.step_mult,
                            colour = G.C.MULT,
                        }
                    end
                end
                -- 彩蛋：2 与 7 同场计分 → X2.7（致敬 27 的 111 步冰雹之旅）
                if context.joker_main and not context.blueprint then
                    local has2, has7 = false, false
                    for _, scoring_card in ipairs(context.scoring_hand) do
                        local id = scoring_card:get_id()
                        if id == 2 then
                            has2 = true
                        elseif id == 7 then
                            has7 = true
                        end
                    end
                    if has2 and has7 then
                        return {
                            message = localize{ type = 'variable', key = 'a_xmult', vars = { 2.7 } },
                            xmult = 2.7,
                            colour = G.C.MULT,
                        }
                    end
                end
            end,
        }),
        SMODS.Joker({
            key = "goldbach",
            config = {
                extra = {
                    primes = { [2] = true, [3] = true, [5] = true, [7] = true, [11] = true },
                    evens = { [4] = true, [6] = true, [8] = true, [10] = true, [12] = true, [14] = true },
                    x_mult = 2.5,
                    x_mult_chen = 3,   -- 陈景润在场：效果升至 X3（1+2 定理的“助攻”）
                },
            },
            rarity = 2,          -- Uncommon
            cost = 6,
            -- 占位：原版 Even Steven（偶数主题），美术图集完成后换 unprv_jokers
            pos = { x = 8, y = 3 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 2,

            loc_vars = function(self, info_queue, center)
                -- 陈景润在场时描述同步显示 X3
                local x = center.ability.extra.x_mult
                for _, j in ipairs(G.jokers and G.jokers.cards or {}) do
                    if j.config.center.key == "j_unprv_chen" then
                        x = center.ability.extra.x_mult_chen
                        break
                    end
                end
                return { vars = { x } }
            end,

            calculate = function(self, card, context)
                -- 每手判定一次：打出的牌中两张质数牌之和 = 另一张偶数牌 → X2.5（陈景润在场 X3）
                if context.joker_main then
                    local e = card.ability.extra
                    local x = e.x_mult
                    for _, j in ipairs(G.jokers and G.jokers.cards or {}) do
                        if j.config.center.key == "j_unprv_chen" then
                            x = e.x_mult_chen
                            break
                        end
                    end
                    local primes, evens = {}, {}
                    for _, played_card in ipairs(context.full_hand) do
                        local id = played_card:get_id()
                        if e.primes[id] then
                            primes[#primes + 1] = id
                        end
                        if e.evens[id] then
                            evens[id] = true
                        end
                    end
                    for i = 1, #primes do
                        for j = i + 1, #primes do
                            if evens[primes[i] + primes[j]] then
                                return {
                                    message = localize{ type = 'variable', key = 'a_xmult', vars = { x } },
                                    xmult = x,
                                    colour = G.C.MULT,
                                }
                            end
                        end
                    end
                end
            end,
        }),
        SMODS.Joker({
            key = "catalan",
            config = {
                extra = { x_mult = 4 },
            },
            rarity = 3,          -- Rare
            cost = 8,
            -- 占位：原版 8 Ball（8 与 9 主题）
            pos = { x = 0, y = 5 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 3,
            calculate = function(self, card, context)
                if context.joker_main then
                    local has8, has9 = false, false
                    for _, c in ipairs(context.full_hand) do
                        local id = c:get_id()
                        if id == 8 then
                            has8 = true
                        elseif id == 9 then
                            has9 = true
                        end
                    end
                    if has8 and has9 then
                        return {
                            message = localize{ type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } },
                            xmult = card.ability.extra.x_mult,
                            colour = G.C.MULT,
                        }
                    end
                end
            end,
        }),
    },
}
