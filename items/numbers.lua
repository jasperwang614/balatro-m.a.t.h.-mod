-- 名数线 · 改变历史的数字（设计文档 §2.5）
-- 24 点求解器：四数任意括号/运算符组合能否得 24
local function can_make_24(nums)
    if #nums == 1 then
        return math.abs(nums[1] - 24) < 1e-6
    end
    for i = 1, #nums do
        for j = i + 1, #nums do
            local rest = {}
            for k = 1, #nums do
                if k ~= i and k ~= j then
                    rest[#rest + 1] = nums[k]
                end
            end
            local a, b = nums[i], nums[j]
            local vals = { a + b, a - b, b - a, a * b }
            if math.abs(b) > 1e-9 then vals[#vals + 1] = a / b end
            if math.abs(a) > 1e-9 then vals[#vals + 1] = b / a end
            for _, v in ipairs(vals) do
                rest[#rest + 1] = v
                if can_make_24(rest) then return true end
                rest[#rest] = nil
            end
        end
    end
    return false
end

return {
    items = {
        SMODS.Joker({
            key = "seven77",
            config = {
                extra = { x_mult = 7.77, money = 7 },
            },
            rarity = 2,          -- Uncommon
            cost = 6,
            -- 占位：原版 Golden（金钱主题）
            pos = { x = 9, y = 2 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 10,
            calculate = function(self, card, context)
                if context.joker_main then
                    local sevens = 0
                    for _, c in ipairs(context.full_hand) do
                        if c:get_id() == 7 then
                            sevens = sevens + 1
                        end
                    end
                    if sevens >= 3 then
                        return {
                            message = "X" .. card.ability.extra.x_mult .. " +$" .. card.ability.extra.money,
                            xmult = card.ability.extra.x_mult,
                            dollars = card.ability.extra.money,
                            colour = G.C.MULT,
                        }
                    end
                end
            end,
        }),
        SMODS.Joker({
            key = "phi",
            config = {
                extra = { x_mult = 1.618 },
            },
            rarity = 2,          -- Uncommon
            cost = 6,
            -- 占位：原版 Runner（序列/递推主题）
            pos = { x = 3, y = 10 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 11,
            calculate = function(self, card, context)
                -- 斐波那契连续两项：A(1),2 / 2,3 / 3,5 / 5,8
                if context.joker_main then
                    local seen = {}
                    for _, c in ipairs(context.full_hand) do
                        seen[c:get_id()] = true
                    end
                    local pairs = { {14, 2}, {2, 3}, {3, 5}, {5, 8} }
                    for _, p in ipairs(pairs) do
                        if seen[p[1]] and seen[p[2]] then
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
            key = "point24",
            config = {
                extra = { x_mult = 2.4 },
            },
            rarity = 2,          -- Uncommon
            cost = 6,
            -- 占位：原版 Satellite
            pos = { x = 8, y = 7 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 12,
            calculate = function(self, card, context)
                if context.joker_main then
                    local vals = {}
                    for _, c in ipairs(context.full_hand) do
                        local id = c:get_id()
                        vals[#vals + 1] = (id == 14) and 1 or id
                    end
                    local n = #vals
                    if n >= 4 then
                        for i = 1, n do
                            for j = i + 1, n do
                                for k = j + 1, n do
                                    for l = k + 1, n do
                                        if can_make_24({ vals[i], vals[j], vals[k], vals[l] }) then
                                            return {
                                                message = localize{ type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } },
                                                xmult = card.ability.extra.x_mult,
                                                colour = G.C.MULT,
                                            }
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end,
        }),
        SMODS.Joker({
            key = "ramanujan",
            config = {
                extra = { x_mult = 17.29 },
            },
            rarity = 2,          -- Uncommon
            cost = 6,
            -- 占位：原版 Turtle Bean
            pos = { x = 4, y = 13 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 13,
            calculate = function(self, card, context)
                -- 1729 = 1,7,2,9（A 记 1）
                if context.joker_main then
                    local seen = {}
                    for _, c in ipairs(context.full_hand) do
                        seen[c:get_id()] = true
                    end
                    if seen[14] and seen[7] and seen[2] and seen[9] then
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
            key = "wheat",
            config = {
                extra = { mult = 1, limit = 64, money = 64, counted_round = 0 },
            },
            rarity = 3,          -- Rare
            cost = 8,
            -- 占位：原版 Diet Cola
            pos = { x = 8, y = 14 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 14,
            calculate = function(self, card, context)
                -- 棋盘麦粒：+1 倍率每回合翻倍；达到 64 被国库没收（销毁 +$64）
                if context.joker_main then
                    return {
                        message = "+" .. card.ability.extra.mult,
                        mult = card.ability.extra.mult,
                        colour = G.C.MULT,
                    }
                end
                -- end_of_round 一回合会派发多次，必须按回合去重，否则倍率连翻直接冲到 64
                if context.end_of_round and context.main_eval and not context.individual and not context.blueprint and not context.retrigger_joker then
                    local e = card.ability.extra
                    if e.counted_round ~= G.GAME.round then
                        e.counted_round = G.GAME.round
                        local new_mult = e.mult * 2
                        if new_mult >= e.limit then
                            ease_dollars(e.money)
                            card_eval_status_text(card, 'extra', nil, nil, nil, { message = "+$" .. e.money, colour = G.C.MONEY })
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    play_sound('tarot1')
                                    card.T.r = -0.2
                                    card:juice_up(0.3, 0.4)
                                    card.states.drag.is = true
                                    card.children.center.pinch.x = true
                                    G.E_MANAGER:add_event(Event({
                                        trigger = 'after', delay = 0.2,
                                        func = function()
                                            card:remove()
                                            return true
                                        end
                                    }))
                                    return true
                                end
                            }))
                        else
                            e.mult = new_mult
                            card:set_cost()
                        end
                    end
                end
            end,
        }),
        SMODS.Joker({
            key = "kaprekar",
            config = {
                extra = { divide = 100, egg_mult = 6.174 },
            },
            rarity = 2,          -- Uncommon
            cost = 6,
            -- 占位：原版（2,9）帧，美术图集完成后换 unprv_jokers
            pos = { x = 2, y = 9 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 15,
            loc_vars = function(self, info_queue, center)
                return { vars = { center.ability.extra.egg_mult } }
            end,
            calculate = function(self, card, context)
                -- 6174：4 张计分牌重排（降序−升序）÷100 转筹码；
                -- 彩蛋：打出 6、1、7、4（A 记 1）→ X6.174
                if context.joker_main then
                    local e = card.ability.extra
                    local chips, xmult
                    local ids = {}
                    for _, c in ipairs(context.scoring_hand) do
                        ids[#ids + 1] = c:get_id()
                    end
                    if #ids == 4 then
                        table.sort(ids)
                        local asc, desc = 0, 0
                        for _, v in ipairs(ids) do
                            asc = asc * 10 + v
                        end
                        for i = #ids, 1, -1 do
                            desc = desc * 10 + ids[i]
                        end
                        local diff = desc - asc
                        if diff > 0 then
                            chips = diff / e.divide
                        end
                    end
                    local has6, has1, has7, has4 = false, false, false, false
                    for _, c in ipairs(context.full_hand) do
                        local id = c:get_id()
                        if id == 14 then id = 1 end
                        if id == 6 then has6 = true
                        elseif id == 1 then has1 = true
                        elseif id == 7 then has7 = true
                        elseif id == 4 then has4 = true end
                    end
                    if has6 and has1 and has7 and has4 then
                        xmult = e.egg_mult
                    end
                    if chips or xmult then
                        local msg = {}
                        if chips then
                            msg[#msg + 1] = "+" .. number_format(chips)
                        end
                        if xmult then
                            msg[#msg + 1] = "X" .. xmult
                        end
                        return {
                            message = table.concat(msg, " "),
                            chips = chips,
                            xmult = xmult,
                            colour = G.C.MULT,
                        }
                    end
                end
            end,
        }),
    },
}
