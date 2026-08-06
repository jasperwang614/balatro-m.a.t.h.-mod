-- EDVAC：存储程序机器——每回合随机加载场上 1 张小丑的程序（本回合复制其效果）

local function unprv_edvac_pick_program()
    if not (G.jokers and G.jokers.cards) then
        return
    end
    local candidates = {}
    for _, j in ipairs(G.jokers.cards) do
        if j.config.center.key ~= 'j_unprv_edvac' then
            candidates[#candidates + 1] = j.config.center.key
        end
    end
    if #candidates == 0 then
        return
    end
    local key = candidates[math.random(#candidates)]
    local center = G.P_CENTERS[key]
    for _, j in ipairs(G.jokers.cards) do
        if j.config.center.key == 'j_unprv_edvac' then
            local e = j.ability.extra
            e.program = key
            -- 把被复制程序的 config.extra 合并进 EDVAC，避免委托 calculate 读不到字段
            if center and center.config and center.config.extra then
                for k, v in pairs(center.config.extra) do
                    if e[k] == nil then
                        e[k] = v
                    end
                end
            end
        end
    end
end

-- 每回合开始加载程序（new_round 才是真正的回合初始化，Game:set_round 在该版本不存在）
local new_round_ref = new_round
function new_round()
    new_round_ref()
    if G.GAME and G.jokers and G.jokers.cards then
        local has_edvac = false
        for _, j in ipairs(G.jokers.cards) do
            if j.config.center.key == 'j_unprv_edvac' then
                has_edvac = true
                break
            end
        end
        if has_edvac then
            unprv_edvac_pick_program()
        end
    end
end

return {
    items = {
        SMODS.Joker({
            key = 'edvac',
            config = {
                extra = { program = nil },
            },
            rarity = 3,          -- Rare
            cost = 8,
            -- 占位：原版（9,1）帧，美术图集完成后换 unprv_jokers
            pos = { x = 9, y = 1 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 39,
            loc_vars = function(self, info_queue, card)
                local e = card.ability.extra
                if e.program then
                    return { vars = { localize{ type = 'name_text', key = e.program, set = 'Joker' } } }
                end
                return { vars = { localize('unprv_edvac_none') } }
            end,
            calculate = function(self, card, context)
                -- 委托：调用被加载程序的 calculate（pcall 兜底，不兼容的程序静默跳过）
                local e = card.ability.extra
                if not e.program then
                    return
                end
                local center = G.P_CENTERS[e.program]
                if center and center.calculate then
                    local ok, ret = pcall(center.calculate, center, card, context)
                    if ok and ret then
                        return ret
                    end
                end
            end,
        }),
    },
}
