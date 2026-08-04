-- 数学小丑包：只出 mod 的小丑牌
-- 小包：3 选 1（p_unprv_mathpack）· 大包：5 选 2（p_unprv_mega_mathpack）

local MATH_POOL = {
    'j_unprv_hailstone', 'j_unprv_goldbach', 'j_unprv_catalan',
    'j_unprv_zuratio', 'j_unprv_euler_identity', 'j_unprv_margin',
    'j_unprv_wiles', 'j_unprv_galois', 'j_unprv_zhang',
    'j_unprv_perelman', 'j_unprv_calabiyau', 'j_unprv_shannon',
    'j_unprv_binary', 'j_unprv_heatdeath', 'j_unprv_maxwell',
    'j_unprv_notice', 'j_unprv_wlog', 'j_unprv_symmetry',
    'j_unprv_oneten', 'j_unprv_nines', 'j_unprv_montecarlo',
    'j_unprv_seventythree', 'j_unprv_oddeven', 'j_unprv_euler',
    'j_unprv_zero', 'j_unprv_wheat', 'j_unprv_kaprekar',
    'j_unprv_phi', 'j_unprv_seven77', 'j_unprv_point24',
    'j_unprv_g2inbox', 'j_unprv_chen', 'j_unprv_gauss',
    'j_unprv_pythagoras', 'j_unprv_riemann', 'j_unprv_poincare',
    'j_unprv_godel', 'j_unprv_hilbert', 'j_unprv_fields',
    'j_unprv_ramanujan', 'j_unprv_pareto', 'j_unprv_centrallimit',
}

local function unprv_pick_math_joker()
    return MATH_POOL[math.random(#MATH_POOL)]
end

return {
    items = {
        SMODS.Booster({
            key = 'mathpack',
            config = { extra = 3, choose = 1 },
            weight = 1,
            cost = 4,
            -- 占位：原版 Buffoon Pack 帧
            pos = { x = 0, y = 8 },
            create_card = function(self, card, i)
                return { key = unprv_pick_math_joker(), area = G.pack_cards, skip_materialize = true }
            end,
        }),
        SMODS.Booster({
            key = 'mega_mathpack',
            config = { extra = 5, choose = 2 },
            weight = 1,
            cost = 8,
            -- 占位：原版 Mega Buffoon Pack 帧
            pos = { x = 3, y = 8 },
            create_card = function(self, card, i)
                return { key = unprv_pick_math_joker(), area = G.pack_cards, skip_materialize = true }
            end,
        }),
    },
}
