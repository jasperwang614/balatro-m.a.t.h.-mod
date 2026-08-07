-- 对手戏（设计文档 §3.2）：牛顿 vs 莱布尼茨 · 伯努利家族

local function unprv_has_joker(key)
    for _, j in ipairs(G.jokers and G.jokers.cards or {}) do
        if j.config.center.key == key then
            return true
        end
    end
    return false
end

-- 伯努利家族：每回合随机换一位兄弟（new_round 才是回合初始化）
local new_round_ref = new_round
function new_round()
    new_round_ref()
    if G.jokers and G.jokers.cards then
        for _, j in ipairs(G.jokers.cards) do
            if j.config.center.key == 'j_unprv_bernoulli' then
                local pool = { 'jacob', 'johann', 'daniel' }
                j.ability.extra.brother = pool[math.random(#pool)]
            end
        end
    end
end

return {
    items = {
        SMODS.Joker({
            key = 'newton',
            config = {
                extra = { x_mult = 1 },
            },
            rarity = 3,          -- Rare
            cost = 8,
            -- 占位：原版（0,1）帧
            pos = { x = 0, y = 1 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 44,
            loc_vars = function(self, info_queue, center)
                local e = center.ability.extra
                local halved = unprv_has_joker('j_unprv_leibniz')
                return { vars = { string.format('%.1f', halved and e.x_mult / 2 or e.x_mult) } }
            end,
            calculate = function(self, card, context)
                -- 流数术：每手牌永久 +0.25 X 倍率；莱布尼茨在场时减半
                if context.joker_main then
                    local e = card.ability.extra
                    e.x_mult = (e.x_mult or 1) + 0.25
                    if unprv_has_joker('j_unprv_leibniz') then
                        return {
                            message = 'X' .. string.format('%.2f', e.x_mult / 2),
                            xmult = e.x_mult / 2,
                            colour = G.C.XMULT,
                        }
                    end
                    return {
                        message = 'X' .. string.format('%.2f', e.x_mult),
                        xmult = e.x_mult,
                        colour = G.C.XMULT,
                    }
                end
            end,
        }),
        SMODS.Joker({
            key = 'leibniz',
            config = {
                extra = { chips = 0 },
            },
            rarity = 3,          -- Rare
            cost = 8,
            -- 占位：原版（2,4）帧
            pos = { x = 2, y = 4 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 45,
            loc_vars = function(self, info_queue, center)
                local e = center.ability.extra
                local halved = unprv_has_joker('j_unprv_newton')
                return { vars = { math.floor(halved and e.chips / 2 or e.chips) } }
            end,
            calculate = function(self, card, context)
                -- 积分：每手牌永久 +30 筹码；牛顿在场时减半
                if context.joker_main then
                    local e = card.ability.extra
                    e.chips = (e.chips or 0) + 30
                    if unprv_has_joker('j_unprv_newton') then
                        local c = math.floor(e.chips / 2)
                        return { message = '+' .. c, chips = c, colour = G.C.CHIPS }
                    end
                    return { message = '+' .. e.chips, chips = e.chips, colour = G.C.CHIPS }
                end
            end,
        }),
        SMODS.Joker({
            key = 'bernoulli',
            config = {
                extra = { brother = nil },
            },
            rarity = 2,          -- Uncommon
            cost = 6,
            -- 占位：原版（3,4）帧
            pos = { x = 3, y = 4 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 46,
            loc_vars = function(self, info_queue, card)
                local b = card.ability.extra.brother or 'jacob'
                return { key = 'j_unprv_bernoulli_' .. b }
            end,
            calculate = function(self, card, context)
                local b = card.ability.extra.brother
                if context.joker_main then
                    if b == 'jacob' then
                        return { message = '雅各布 +2', mult = 2, colour = G.C.MULT }
                    elseif b == 'daniel' then
                        if pseudorandom('unprv_bernoulli') > 0.5 then
                            return { message = 'X2', xmult = 2, colour = G.C.XMULT }
                        end
                        return { message = 'X0.5', xmult = 0.5, colour = G.C.XMULT }
                    elseif b == 'johann' then
                        -- 结算为 0 时重算一次：+50 筹码
                        local cur = G.GAME.current_round and G.GAME.current_round.current_hand
                            and UNPRV.num(G.GAME.current_round.current_hand.chip_total) or 0
                        if cur == 0 then
                            return { message = '重算 +50', chips = 50, colour = G.C.CHIPS }
                        end
                    end
                end
            end,
        }),
    },
}
