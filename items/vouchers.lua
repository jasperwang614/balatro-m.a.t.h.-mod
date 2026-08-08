-- 优惠券链（设计文档 §3.7）：几何原本 → 算术研究 · 数学原理 → GEB
-- 计分效果在 UNPRV.calculate（items/consumables.lua）中按 used_vouchers 生效

return {
    items = {
        SMODS.Voucher({
            key = 'elements',
            config = { extra = 1 },
            cost = 10,
            pos = { x = 2, y = 0 },
            apply_to_run = function(self)
                -- 手牌上限 +1
                G.hand:change_size(1)
            end,
        }),
        SMODS.Voucher({
            key = 'disquisitiones',
            config = { extra = 4 },
            requires = { 'v_unprv_elements' },
            cost = 10,
            pos = { x = 5, y = 0 },
        }),
        SMODS.Voucher({
            key = 'principia',
            config = { extra = 2 },
            cost = 10,
            pos = { x = 6, y = 0 },
        }),
        SMODS.Voucher({
            key = 'geb',
            config = { extra = 2 },
            requires = { 'v_unprv_principia' },
            cost = 10,
            pos = { x = 8, y = 0 },
        }),
    },
}
