-- Kun · 练习时长两年半（2026-08-09，v1.4.1）
-- 核弹级传说小丑：计分牌含 2 和 5（“两年半”）→ 本卡永久 X2.5（可叠加）
-- 彩蛋：与 G2 in box（鸡兔同笼）同场时，每手额外练习一次（“鸡你太美”）

local function unprv_kun_fmt(n)
    local v = 2.5 ^ n
    if v < 10000 then
        local s = string.format('%.4f', v)
        s = s:gsub('0+$', ''):gsub('%.$', '')
        return s
    end
    return string.format('%.3e', v)
end

return {
    items = {
        SMODS.Joker({
            key = 'kun',
            config = {
                extra = { stacks = 0 },
            },
            rarity = 4,          -- Legendary
            cost = 20,
            -- 占位：原版（2,0）帧，美术图集完成后换 unprv_jokers
            pos = { x = 2, y = 0 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 49,
            loc_vars = function(self, info_queue, card)
                local e = card.ability.extra
                if (e.stacks or 0) > 0 then
                    return {
                        key = 'j_unprv_kun_count',
                        vars = { e.stacks, unprv_kun_fmt(e.stacks) },
                    }
                end
                return {}
            end,
            calculate = function(self, card, context)
                if context.joker_main then
                    local e = card.ability.extra
                    local has2, has5 = false, false
                    for _, c in ipairs(context.full_hand or {}) do
                        local id = c:get_id()
                        if id == 2 then
                            has2 = true
                        elseif id == 5 then
                            has5 = true
                        end
                    end
                    if has2 and has5 then
                        e.stacks = (e.stacks or 0) + 1
                        local msg = '两年半'
                        for _, j in ipairs(G.jokers and G.jokers.cards or {}) do
                            if j.config.center.key == 'j_unprv_g2inbox' then
                                e.stacks = e.stacks + 1
                                msg = '鸡你太美'
                                break
                            end
                        end
                        return {
                            message = msg,
                            xmult = 2.5 ^ e.stacks,
                            colour = G.C.XMULT,
                        }
                    end
                end
            end,
        }),
    },
}
