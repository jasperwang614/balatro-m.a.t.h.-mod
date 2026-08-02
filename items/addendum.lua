-- 补遗线 · v1.5 扩展包《补遗 Addendum》先行实现
-- 本文件三张：G2 in box（鸡兔同笼）· 陈景润 1+2（哥德巴赫联动）· 高斯求和
-- 设计文档 §3.4（陈景润）/ §8（鸡兔同笼）/ §17（高斯求和）；开发规范 §6

-- 陈景润联动：场上是否有哥德巴赫猜想
local function unprv_has_goldbach()
    for _, j in ipairs(G.jokers and G.jokers.cards or {}) do
        if j.config.center.key == "j_unprv_goldbach" then
            return true
        end
    end
    return false
end

-- 塞一张随机质数牌（2/3/5/7/J）到手牌（陈景润连携：1+2 定理的“助攻”）
local function unprv_add_prime_card()
    local ranks = { "2", "3", "5", "7", "J" }
    local suits = { "S", "H", "C", "D" }
    local new_card = SMODS.create_card({
        set = "Base",
        area = G.hand,
        -- 注意：本版本 pseudorandom(seed, min, max) 参数顺序与老教程不同，
        -- 直接用 pseudorandom_element(表, seed) 挑随机元素最稳
        rank = pseudorandom_element(ranks, "unprv_chen_rank"),
        suit = pseudorandom_element(suits, "unprv_chen_suit"),
        no_edition = true,
        key_append = "unprv_chen",
    })
    if new_card then
        new_card:add_to_deck()
        G.hand:emplace(new_card)
    end
end

-- G2 in box 解方程结果表：值在加载时已写死，计分时纯查表、零实时运算。
-- 行 = 打出牌张数 H，列 = 总点数 L（A 记 1）；值 = { 兔, 鸡 }。
-- 来源公式（设计文档 §15）：可解 = L 为偶数且 2H ≤ L ≤ 4H；
-- 兔 = (L−2H)/2，鸡 = H−兔。打出牌最多 5 张，此表即全集。
local SOLVED = {
    [2] = {
        [4]  = { rabbits = 0, chickens = 2 },  -- X1 +50
        [6]  = { rabbits = 1, chickens = 1 },  -- X2 +25
        [8]  = { rabbits = 2, chickens = 0 },  -- X3
    },
    [3] = {
        [6]  = { rabbits = 0, chickens = 3 },  -- X1 +75
        [8]  = { rabbits = 1, chickens = 2 },  -- X2 +50
        [10] = { rabbits = 2, chickens = 1 },  -- X3 +25
        [12] = { rabbits = 3, chickens = 0 },  -- X4
    },
    [4] = {
        [8]  = { rabbits = 0, chickens = 4 },  -- X1 +100
        [10] = { rabbits = 1, chickens = 3 },  -- X2 +75
        [12] = { rabbits = 2, chickens = 2 },  -- X3 +50
        [14] = { rabbits = 3, chickens = 1 },  -- X4 +25
        [16] = { rabbits = 4, chickens = 0 },  -- X5
    },
    [5] = {
        [10] = { rabbits = 0, chickens = 5 },  -- X1 +125
        [12] = { rabbits = 1, chickens = 4 },  -- X2 +100
        [14] = { rabbits = 2, chickens = 3 },  -- X3 +75
        [16] = { rabbits = 3, chickens = 2 },  -- X4 +50
        [18] = { rabbits = 4, chickens = 1 },  -- X5 +25
        [20] = { rabbits = 5, chickens = 0 },  -- X6
    },
}

return {
    items = {
        -- G2 in box：鸡兔同笼（谜语名：G 谐音鸡、2 念 two 谐音兔、in box=笼子）
        SMODS.Joker({
            key = "g2inbox",
            config = {
                extra = {
                    chips_per_chicken = 25,   -- 每只鸡 +25 筹码
                    rabbit_floor = 1,         -- 每只兔：X(1+兔)
                },
            },
            rarity = 3,          -- Rare（数值草案，实测后可调）
            cost = 8,
            -- 占位：原版图集（5,3）帧，美术图集完成后换 unprv_jokers
            pos = { x = 5, y = 3 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 20,
            loc_vars = function(self, info_queue, center)
                return { vars = { center.ability.extra.chips_per_chicken } }
            end,
            calculate = function(self, card, context)
                -- 纯查表：H=打出牌数，L=点数总和(A=1)；表外组合 = 不可解
                if context.joker_main then
                    local e = card.ability.extra
                    local H = #context.full_hand
                    local L = 0
                    for _, c in ipairs(context.full_hand) do
                        local id = c:get_id()
                        L = L + (id == 14 and 1 or id)  -- A 记 1
                    end
                    local sol = SOLVED[H] and SOLVED[H][L]
                    if sol then
                        return {
                            message = localize{ type = 'variable', key = 'a_xmult', vars = { e.rabbit_floor + sol.rabbits } },
                            chips = e.chips_per_chicken * sol.chickens,
                            xmult = e.rabbit_floor + sol.rabbits,
                            colour = G.C.MULT,
                        }
                    end
                end
            end,
        }),

        -- 陈景润 1+2：哥德巴赫联动线（设计文档 §3.4）
        SMODS.Joker({
            key = "chen",
            config = {
                extra = {
                    combo_mult = 2,            -- 持有哥德巴赫：本卡 X2
                    proving_mult = 1,          -- 未持有：还在证 +1 倍率
                    goldbach_combo_mult = 3,   -- 哥德巴赫本体升至 X3
                },
            },
            rarity = 3,          -- Rare
            cost = 8,
            -- 占位：原版图集（6,10）帧，美术图集完成后换 unprv_jokers
            pos = { x = 6, y = 10 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 21,
            loc_vars = function(self, info_queue, center)
                return {
                    vars = {
                        center.ability.extra.combo_mult,
                        center.ability.extra.proving_mult,
                        center.ability.extra.goldbach_combo_mult,
                    },
                }
            end,
            calculate = function(self, card, context)
                -- 连携：持有哥德巴赫时塞 1 张质数牌 + 本卡 X2；
                -- 未持有：还在证，+1 倍率（哥德巴赫本体的升级在 conjectures.lua）
                if context.joker_main then
                    local e = card.ability.extra
                    if unprv_has_goldbach() then
                        unprv_add_prime_card()
                        return {
                            message = localize{ type = 'variable', key = 'a_xmult', vars = { e.combo_mult } },
                            xmult = e.combo_mult,
                            colour = G.C.MULT,
                        }
                    end
                    return {
                        message = "+" .. e.proving_mult,
                        mult = e.proving_mult,
                        colour = G.C.MULT,
                    }
                end
            end,
        }),

        -- 高斯求和：1+2+3+4+5=15（设计文档 §17，数值草案）
        SMODS.Joker({
            key = "gauss",
            config = {
                extra = {
                    chips = 15,      -- 挂钩 15：+15 筹码
                    x_mult = 1.5,    -- 挂钩 15：X1.5
                },
            },
            rarity = 2,          -- Uncommon（小牌流基调卡）
            cost = 6,
            -- 占位：原版图集（2,5）帧，美术图集完成后换 unprv_jokers
            pos = { x = 2, y = 5 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 22,
            loc_vars = function(self, info_queue, center)
                return { vars = { center.ability.extra.chips, center.ability.extra.x_mult } }
            end,
            calculate = function(self, card, context)
                -- 同手打出 A、2、3、4、5（A=1）→ 奖励挂钩 15
                if context.joker_main then
                    local e = card.ability.extra
                    local found = {}
                    for _, c in ipairs(context.full_hand) do
                        local id = c:get_id()
                        if id == 14 then id = 1 end
                        if id >= 1 and id <= 5 then
                            found[id] = true
                        end
                    end
                    if found[1] and found[2] and found[3] and found[4] and found[5] then
                        return {
                            message = "1+2+3+4+5=15",
                            chips = e.chips,
                            xmult = e.x_mult,
                            colour = G.C.MULT,
                        }
                    end
                end
            end,
        }),
    },
}
