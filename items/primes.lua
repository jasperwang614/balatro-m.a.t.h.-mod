-- 质数系列（v1.4）：质数牌组 + 格林-陶定理

local PRIME_SET = { [2] = true, [3] = true, [5] = true, [7] = true, [11] = true, [13] = true }
UNPRV.prime_set = PRIME_SET  -- 供优惠券计分效果（UNPRV.calculate）查询

-- selected_back_key 可能是中心表也可能是字符串，兼容两种
local function unprv_is_prime_deck()
    local sb = G.GAME and G.GAME.selected_back_key
    if type(sb) == 'table' and sb.key == 'b_unprv_prime' then
        return true
    end
    if type(sb) == 'string' and sb == 'b_unprv_prime' then
        return true
    end
    return false
end

-- 质数牌组：全副 24 张质数牌（2/3/5/7/J/K × 四花色），开局自带哥德巴赫猜想
local game_start_run_ref = Game.start_run
function Game:start_run(args)
    game_start_run_ref(self, args)
    if G.GAME and unprv_is_prime_deck() and not G.GAME.unprv_prime_deck_built then
        G.GAME.unprv_prime_deck_built = true
        -- 首手牌在回合开始时才发，此时重建牌堆来得及
        for i = #G.deck.cards, 1, -1 do
            G.deck:remove_card(G.deck.cards[i])
        end
        local suits = { 'S', 'H', 'D', 'C' }
        local ranks = { '2', '3', '5', '7', 'J', 'K' }
        for _, s in ipairs(suits) do
            for _, r in ipairs(ranks) do
                local c = SMODS.create_card({ set = 'Playing Card', area = G.deck, front = s .. '_' .. r })
                if c then
                    c:add_to_deck()
                    G.deck:emplace(c)
                end
            end
        end
        G.deck:shuffle()
        G.deck:hard_set_T()
        add_joker('j_unprv_goldbach', nil, true)
    end
end

return {
    items = {
        SMODS.Back({
            key = 'prime',
            name = 'Prime Deck',
            pos = { x = 0, y = 4 },
            config = {},
        }),
        SMODS.Joker({
            key = 'green_tao',
            config = {
                extra = { x_mult = 3 },
            },
            rarity = 3,          -- Rare
            cost = 8,
            -- 占位：原版（3,2）帧
            pos = { x = 3, y = 2 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 48,
            calculate = function(self, card, context)
                -- ≥3 张质数牌成等差（3,5,7 / 3,7,J）：X3
                if context.joker_main then
                    local primes = {}
                    -- 用打出的牌（full_hand）而非计分牌：七桥 debuff 后 3/5 仍算数
                    for _, c in ipairs(context.full_hand or {}) do
                        local id = c:get_id()
                        if PRIME_SET[id] then
                            primes[id] = true
                        end
                    end
                    local ids = {}
                    for id in pairs(primes) do
                        ids[#ids + 1] = id
                    end
                    table.sort(ids)
                    for i = 1, #ids do
                        for j = i + 1, #ids do
                            for k = j + 1, #ids do
                                if ids[j] - ids[i] == ids[k] - ids[j] then
                                    return {
                                        message = 'X3',
                                        xmult = card.ability.extra.x_mult,
                                        colour = G.C.MULT,
                                    }
                                end
                            end
                        end
                    end
                end
            end,
        }),
    },
}
