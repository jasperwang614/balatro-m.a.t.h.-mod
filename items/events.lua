-- 大事件线 · 数学史瞬间（设计文档 §2.2）

-- 勾股数检测：打出的牌里是否存在 a²+b²=c²（3,4,5 / 6,8,10 / 5,12,13）
local function unprv_find_triple(hand)
    local seen, ids = {}, {}
    for _, c in ipairs(hand) do
        local id = c:get_id()
        if not seen[id] then
            seen[id] = true
            ids[#ids + 1] = id
        end
    end
    for i = 1, #ids do
        for j = i + 1, #ids do
            local s = ids[i] * ids[i] + ids[j] * ids[j]
            local c = math.floor(math.sqrt(s))
            if c * c == s and c <= 14 and seen[c] and c ~= ids[i] and c ~= ids[j] then
                return ids[i], ids[j], c
            end
        end
    end
    return nil
end

local function unprv_has_joker(key)
    for _, j in ipairs(G.jokers and G.jokers.cards or {}) do
        if j.config.center.key == key then
            return true
        end
    end
    return false
end

-- 蛰伏七年：期满一次性发放负片传奇小丑 + 负片消耗牌（“七年蛰伏，一鸣惊人”）
local function unprv_zhang_spawn(card)
    local e = card.ability.extra
    for i = 1, e.joker_count do
        local j = SMODS.create_card({
            set = 'Joker',
            area = G.jokers,
            legendary = true,       -- 传奇池（含本 mod 的页边太窄与已解锁的其他 mod 传奇）
            edition = 'negative',
            key_append = 'unprv_zhang_joker',
        })
        if j then
            j:add_to_deck()
            G.jokers:emplace(j)
            j:juice_up(0.3, 0.4)
        end
    end
    for i = 1, e.consumable_count do
        local c = SMODS.create_card({
            set = 'Consumeables',
            area = G.consumeables,
            edition = 'negative',
            key_append = 'unprv_zhang_cons',
        })
        if c then
            c:add_to_deck()
            G.consumeables:emplace(c)
            c:juice_up(0.3, 0.4)
        end
    end
    play_sound('tarot1')
end

return {
    items = {
        SMODS.Joker({
            key = "zuratio",
            config = {
                extra = { x_mult = 1.5 },
            },
            rarity = 2,          -- Uncommon
            cost = 6,
            -- 占位：原版 Stuntman
            pos = { x = 8, y = 6 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 10,
            calculate = function(self, card, context)
                if context.joker_main then
                    local has3, has5, hasA = false, false, false
                    for _, c in ipairs(context.full_hand) do
                        local id = c:get_id()
                        if id == 3 then
                            has3 = true
                        elseif id == 5 then
                            has5 = true
                        elseif id == 14 then
                            hasA = true
                        end
                    end
                    if has3 and has5 and hasA then
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
            key = "euler_identity",
            config = {
                extra = { pi_mult = 3.14, epi_mult = 23.14, ulti_mult = 31.4159 },
            },
            rarity = 3,          -- Rare（终极彩蛋；后续可升 Legendary + soul）
            cost = 10,
            -- 占位：原版 Egg
            pos = { x = 0, y = 10 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 11,
            loc_vars = function(self, info_queue, center)
                return {
                    vars = {
                        center.ability.extra.pi_mult,
                        center.ability.extra.epi_mult,
                        center.ability.extra.ulti_mult,
                    },
                }
            end,
            calculate = function(self, card, context)
                -- 欧拉恒等式 e^{iπ}+1=0：每张计分 3（π）X3.14；
                -- 场上有 e 升 X23.14（e^π）；e + 3 + A 触发终极彩蛋 X31.4159
                if context.joker_main then
                    local e = card.ability.extra
                    local has_e = false
                    for _, j in ipairs(G.jokers and G.jokers.cards or {}) do
                        if j.config.center.key == "j_unprv_euler" then
                            has_e = true
                            break
                        end
                    end
                    local threes, hasA = 0, false
                    for _, c in ipairs(context.full_hand) do
                        local id = c:get_id()
                        if id == 3 then
                            threes = threes + 1
                        elseif id == 14 then
                            hasA = true
                        end
                    end
                    if has_e and threes >= 1 and hasA then
                        return {
                            message = "e^{iπ}+1=0",
                            xmult = e.ulti_mult,
                            colour = G.C.MULT,
                        }
                    end
                    if threes > 0 then
                        local m = has_e and e.epi_mult or e.pi_mult
                        return {
                            message = localize{ type = 'variable', key = 'a_xmult', vars = { m } },
                            xmult = m ^ threes,
                            colour = G.C.MULT,
                        }
                    end
                end
            end,
        }),
        SMODS.Joker({
            key = "margin",
            config = {
                extra = { x_mult = 5, proven_mult = 10 },
            },
            rarity = 4,          -- Legendary（招牌）
            cost = 20,
            -- 占位：原版 Constellation
            pos = { x = 9, y = 10 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 12,
            loc_vars = function(self, info_queue, center)
                -- 怀尔斯在场 = 隐藏条件被证明：文案切换为揭示版
                if unprv_has_joker("j_unprv_wiles") then
                    return { key = "j_unprv_margin_proven", vars = { center.ability.extra.proven_mult } }
                end
                return {}
            end,
            calculate = function(self, card, context)
                -- 隐藏条件：计分牌含勾股数（不写进描述，等怀尔斯来证明）
                if context.joker_main then
                    local a, b, c = unprv_find_triple(context.full_hand)
                    if a then
                        local m = unprv_has_joker("j_unprv_wiles") and card.ability.extra.proven_mult or card.ability.extra.x_mult
                        return {
                            message = localize{ type = 'variable', key = 'a_xmult', vars = { m } },
                            xmult = m,
                            colour = G.C.MULT,
                        }
                    end
                end
            end,
        }),
        SMODS.Joker({
            key = "wiles",
            config = {
                extra = { x_mult = 2 },
            },
            rarity = 3,          -- Rare
            cost = 8,
            -- 占位：原版 Bootstraps
            pos = { x = 9, y = 8 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 13,
            calculate = function(self, card, context)
                -- 怀尔斯：勾股数（费马大定理 n=2 的边界特例）→ X2
                if context.joker_main then
                    local a, b, c = unprv_find_triple(context.full_hand)
                    if a then
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
            key = "galois",
            config = {
                extra = { x_mult = 3 },
            },
            rarity = 2,          -- Uncommon
            cost = 6,
            -- 占位：原版（1,10）帧，美术图集完成后换 unprv_jokers
            pos = { x = 1, y = 10 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 14,
            calculate = function(self, card, context)
                -- 决斗前夜：仅剩 1 次出牌机会（本手牌）→ X3
                -- 与原版 Acrobat 同口径：计分时 hands_left 已扣为 0
                if context.joker_main then
                    if G.GAME.current_round.hands_left == 0 then
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
            key = "zhang",
            config = {
                extra = {
                    dormant_rounds = 7,
                    joker_count = 5,        -- 期满发放的负片传奇小丑数
                    consumable_count = 8,   -- 期满发放的负片消耗牌数
                },
            },
            rarity = 3,          -- Rare
            cost = 8,
            -- 占位：原版（2,3）帧，美术图集完成后换 unprv_jokers
            pos = { x = 2, y = 3 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 15,
            loc_vars = function(self, info_queue, center)
                -- 蛰伏中：显示进度；已期满：切换为“蛰伏结束”文案
                local e = center.ability.extra
                if e.triggered then
                    return { key = 'j_unprv_zhang_awake' }
                end
                return { vars = { e.rounds or 0, e.dormant_rounds, e.joker_count, e.consumable_count } }
            end,
            calculate = function(self, card, context)
                -- 蛰伏七年：前 7 回合白板；期满一次性发放战利品，此后不再生效
                if context.end_of_round and not context.blueprint and not context.retrigger_joker then
                    local e = card.ability.extra
                    -- 按回合号去重：同一回合无论 end_of_round 派发几次都只计 1
                    if e.counted_round ~= G.GAME.round then
                        e.counted_round = G.GAME.round
                        e.rounds = (e.rounds or 0) + 1
                        if e.rounds >= e.dormant_rounds and not e.triggered then
                            e.triggered = true
                            unprv_zhang_spawn(card)
                        end
                    end
                end
            end,
        }),
    },
}
