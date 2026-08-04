-- 挑战 · 未证之旅（v1.0 上手导览）
-- 菲尔兹奖 + 3 张随机负片数学家：展示 mod 的数学家流，其余内容留给商店探索。

-- 随机池：排除有解锁门槛的数学家（e=商店门槛、页边太窄=传奇池）
local MATH_TOUR_POOL = {
    'j_unprv_chen', 'j_unprv_gauss', 'j_unprv_wiles', 'j_unprv_ramanujan',
    'j_unprv_galois', 'j_unprv_zhang', 'j_unprv_perelman', 'j_unprv_calabiyau',
    'j_unprv_shannon', 'j_unprv_pythagoras', 'j_unprv_riemann', 'j_unprv_poincare',
    'j_unprv_godel', 'j_unprv_hilbert',
}

local function unprv_tour_add_maths()
    if not (G.jokers and G.jokers.cards) then
        return
    end
    local pool = {}
    for _, k in ipairs(MATH_TOUR_POOL) do
        pool[#pool + 1] = k
    end
    for i = 1, 3 do
        if #pool == 0 then
            break
        end
        local idx = math.random(#pool)
        local key = pool[idx]
        table.remove(pool, idx)
        add_joker(key, 'negative', false)
    end
end

-- 挑战开局：随机负片数学家（菲尔兹奖走原版挑战 jokers 字段，这里补随机 3 张）
local game_start_run_ref = Game.start_run
function Game:start_run(args)
    game_start_run_ref(self, args)
    if G.GAME and G.GAME.challenge == 'c_unprv_tour' then
        unprv_tour_add_maths()
    end
end

return {
    items = {
        SMODS.Challenge({
            key = 'unprv_tour',
            rules = {
                custom = {
                    { id = 'unprv_tour_start' },
                    { id = 'unprv_tour_explore' },
                },
                modifiers = {
                    { id = 'dollars', value = 12 },
                    { id = 'hands', value = 4 },
                    { id = 'discards', value = 3 },
                    { id = 'hand_size', value = 8 },
                },
            },
            jokers = {
                { id = 'j_unprv_fields' },
            },
            consumeables = {
                { id = 'c_unprv_entropy' },
                { id = 'c_unprv_monty' },
            },
            vouchers = {},
            deck = { type = 'Challenge Deck' },
            restrictions = {
                banned_cards = {},
                banned_tags = {},
                banned_other = {},
            },
            unlocked = function()
                return true
            end,
        }),
    },
}
