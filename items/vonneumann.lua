-- 冯·诺依曼 · 通用构造器（自复制机器，设计 2026-08-06）
-- 每打出一手牌，每张本卡复制 1 张负片（指数增长，本体+复制体最多 29 张）
-- 复制体随机获得 1 个状态词条（共 29 种）；每个词条触发时，本体 X2 倍率 + 29 筹码

local VN_MAX = 29
local VN_AUGMENTS = {
    'prime', 'composite', 'divide', 'modulo', 'limit', 'deriv', 'exponent',
    'axiom', 'lemma', 'theorem', 'corollary', 'conjecture', 'probability',
    'expectation', 'variance', 'chaos', 'squeeze', 'bisect', 'matrix',
    'determinant', 'dot', 'vector', 'group', 'log', 'induction', 'integral',
    'recursion', 'game', 'proof',
}

-- 按计分牌触发的词条（其余词条按手牌触发）
local VN_INDIVIDUAL = {
    prime = true, composite = true, divide = true, modulo = true,
    limit = true, deriv = true, exponent = true,
}

local function unprv_is_prime_id(id)
    return id == 2 or id == 3 or id == 5 or id == 7 or id == 11 or id == 13
end

local function unprv_vn_count()
    local n = 0
    for _, j in ipairs(G.jokers and G.jokers.cards or {}) do
        if j.config.center.key == 'j_unprv_vonneumann' then
            n = n + 1
        end
    end
    return n
end

local function unprv_vn_spawn()
    local c = add_joker('j_unprv_vonneumann', 'negative', true)
    if c then
        c.ability.extra.augment = VN_AUGMENTS[math.random(#VN_AUGMENTS)]
        -- 复制体插到最左，保证本体（最右）在 joker_main 最后触发，能数到全部词条触发
        if c.area then
            c.area:remove_card(c)
        end
        G.jokers:emplace(c, 'front')
        c:juice_up(0.3, 0.4)
    end
end

-- 每手牌结算后：指数复制（上限 29）；顺带记录上一手得分供“博弈”词条使用
local evaluate_play_ref = G.FUNCS.evaluate_play
function G.FUNCS.evaluate_play(e)
    evaluate_play_ref(e)
    if not (G.GAME and G.GAME.current_round and G.GAME.current_round.current_hand) then
        return
    end
    G.GAME.unprv_vn_last_score = UNPRV.num(G.GAME.current_round.current_hand.chip_total)
    G.GAME.unprv_vn_triggers = 0  -- 重置每手牌的词条触发计数
    local count = unprv_vn_count()
    if count > 0 and count < VN_MAX then
        local to_spawn = math.min(count, VN_MAX - count)
        for i = 1, to_spawn do
            unprv_vn_spawn()
        end
    end
end

return {
    items = {
        SMODS.Joker({
            key = 'vonneumann',
            config = {
                extra = { augment = nil, acc = 0, used = false, mult = 0, chips = 0 },
            },
            rarity = 4,          -- Legendary
            cost = 20,
            -- 占位：原版（2,1）帧，美术图集完成后换 unprv_jokers
            pos = { x = 2, y = 1 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 36,
            loc_vars = function(self, info_queue, card)
                local aug = card.ability.extra.augment
                if aug then
                    -- 复制体：显示自己随到的状态词条
                    return { key = 'j_unprv_vonneumann_aug', vars = { localize('unprv_vn_aug_' .. aug) } }
                end
                -- 本体：显示累计倍率/筹码
                local e = card.ability.extra
                return { vars = { e.mult or 0, e.chips or 0 } }
            end,
            calculate = function(self, card, context)
                local e = card.ability.extra
                local aug = card.ability.extra.augment
                local ret
                -- 按计分牌触发的词条
                if context.individual and context.cardarea == G.play then
                    local id = context.other_card and context.other_card:get_id()
                    if aug == 'prime' and unprv_is_prime_id(id) then
                        ret = { message = '素数', mult = 4, colour = G.C.MULT }
                    elseif aug == 'composite' and id and id % 2 == 0 then
                        ret = { message = '合数', chips = 3, colour = G.C.CHIPS }
                    elseif aug == 'divide' and id == 14 then
                        ret = { message = '整除', chips = 8, colour = G.C.CHIPS }
                    elseif aug == 'modulo' and id == 13 then
                        ret = { message = '取模', chips = 8, colour = G.C.CHIPS }
                    elseif aug == 'limit' then
                        ret = { message = '极限', mult = 2, colour = G.C.MULT }
                    elseif aug == 'deriv' then
                        ret = { message = '导数', chips = 3, colour = G.C.CHIPS }
                    elseif aug == 'exponent' and context.full_hand and context.other_card == context.full_hand[1] then
                        ret = { message = '指数', mult = 8, colour = G.C.MULT }
                    end
                    if ret then
                        G.GAME.unprv_vn_triggers = (G.GAME.unprv_vn_triggers or 0) + 1
                        return ret
                    end
                    if VN_INDIVIDUAL[aug] then
                        return nil
                    end
                end
                -- 按手牌触发的词条
                if context.joker_main then
                    -- 本体（无词条）：数复制体词条触发次数，每次永久 +2 倍率 + 29 筹码
                    if aug == nil then
                        local n = G.GAME.unprv_vn_triggers or 0
                        if n > 0 then
                            e.mult = (e.mult or 0) + 2 * n
                            e.chips = (e.chips or 0) + 29 * n
                        end
                        if e.mult > 0 or e.chips > 0 then
                            return {
                                message = '+' .. e.mult .. ' / +' .. e.chips,
                                mult = e.mult,
                                chips = e.chips,
                                colour = G.C.MULT,
                            }
                        end
                        return nil
                    end
                    local hand = context.full_hand or {}
                    if aug == 'axiom' then
                        ret = { message = '公理', mult = 5, colour = G.C.MULT }
                    elseif aug == 'lemma' then
                        ret = { message = '引理', chips = 5, colour = G.C.CHIPS }
                    elseif aug == 'theorem' then
                        ret = { message = '定理', mult = 8, colour = G.C.MULT }
                    elseif aug == 'corollary' then
                        ret = { message = '推论', chips = 8, colour = G.C.CHIPS }
                    elseif aug == 'conjecture' and pseudorandom('unprv_vn_conj') > 0.5 then
                        ret = { message = '猜想', mult = 12, colour = G.C.MULT }
                    elseif aug == 'probability' and pseudorandom('unprv_vn_prob') > 0.75 then
                        ret = { message = 'X2', xmult = 2, colour = G.C.XMULT }
                    elseif aug == 'expectation' then
                        ret = { message = '期望', mult = 6, colour = G.C.MULT }
                    elseif aug == 'variance' then
                        local v = math.random(0, 15)
                        ret = { message = '方差+' .. v, mult = v, colour = G.C.MULT }
                    elseif aug == 'chaos' then
                        local x = 1 + math.random() * 0.5
                        ret = { message = 'X' .. string.format('%.2f', x), xmult = x, colour = G.C.XMULT }
                    elseif aug == 'squeeze' and #hand == 3 then
                        ret = { message = '夹逼', mult = 10, colour = G.C.MULT }
                    elseif aug == 'bisect' and #hand <= 2 then
                        ret = { message = '二分', mult = 15, colour = G.C.MULT }
                    elseif aug == 'matrix' and context.scoring_name == 'Pair' then
                        ret = { message = '矩阵', mult = 12, colour = G.C.MULT }
                    elseif aug == 'determinant' and context.scoring_name == 'Full House' then
                        ret = { message = '行列式', mult = 20, colour = G.C.MULT }
                    elseif aug == 'dot' and context.scoring_name == 'Straight' then
                        ret = { message = '内积', mult = 15, colour = G.C.MULT }
                    elseif aug == 'vector' and context.scoring_name == 'Flush' then
                        ret = { message = '向量', chips = 12, colour = G.C.CHIPS }
                    elseif aug == 'group' and #hand == 5 then
                        ret = { message = '群论', mult = 20, colour = G.C.MULT }
                    elseif aug == 'log' then
                        local m = 2 * #hand
                        ret = { message = '对数+' .. m, mult = m, colour = G.C.MULT }
                    elseif aug == 'induction' then
                        e.acc = (e.acc or 0) + 1
                        ret = { message = '归纳+' .. e.acc, mult = e.acc, colour = G.C.MULT }
                    elseif aug == 'integral' then
                        e.acc = (e.acc or 0) + 5
                        ret = { message = '积分+' .. e.acc, mult = e.acc, colour = G.C.MULT }
                    elseif aug == 'recursion' then
                        e.acc = (e.acc or 0) + 1
                        ret = { message = '递归+' .. e.acc, mult = e.acc, colour = G.C.MULT }
                    elseif aug == 'game' then
                        local cur = G.GAME.current_round and G.GAME.current_round.current_hand
                            and UNPRV.num(G.GAME.current_round.current_hand.chip_total) or 0
                        if G.GAME.unprv_vn_last_score and cur > G.GAME.unprv_vn_last_score then
                            ret = { message = '博弈', mult = 12, colour = G.C.MULT }
                        end
                    elseif aug == 'proof' and not e.used then
                        e.used = true
                        ret = { message = '反证', mult = 6, colour = G.C.MULT }
                    end
                    if ret then
                        G.GAME.unprv_vn_triggers = (G.GAME.unprv_vn_triggers or 0) + 1
                        return ret
                    end
                end
                -- 回合结束：重置回合性状态（递归词条保留）
                if context.end_of_round and not context.blueprint and not context.retrigger_joker then
                    if aug ~= 'recursion' then
                        e.acc = 0
                    end
                    e.used = false
                end
            end,
        }),
    },
}
