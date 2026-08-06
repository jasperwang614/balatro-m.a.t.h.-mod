-- Attention Is All You Need（Transformer · Vaswani et al., NeurIPS 2017）
-- 自注意力：每张计分牌 +4 倍率 × 本手牌张数（每个位置关注所有位置，O(n²)）

return {
    items = {
        SMODS.Joker({
            key = 'attention',
            config = {
                extra = { mult_per_card = 4 },
            },
            rarity = 3,          -- Rare
            cost = 8,
            -- 占位：原版（8,1）帧，美术图集完成后换 unprv_jokers
            pos = { x = 8, y = 1 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 38,
            loc_vars = function(self, info_queue, center)
                return { vars = { center.ability.extra.mult_per_card } }
            end,
            calculate = function(self, card, context)
                -- 自注意力：每张计分牌 +4 倍率 × 本手牌张数
                if context.individual and context.cardarea == G.play then
                    local n = #(context.full_hand or {})
                    local m = card.ability.extra.mult_per_card * n
                    return {
                        message = '+' .. m,
                        mult = m,
                        colour = G.C.MULT,
                    }
                end
            end,
        }),
    },
}
