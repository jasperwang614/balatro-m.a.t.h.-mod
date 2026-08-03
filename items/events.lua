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

-- 拒领百万：利息与跳过的盲注奖励被拒领，每 $1 → +2 倍率；累计少吃 $100 → X10000
local function unprv_has_perelman()
    return unprv_has_joker('j_unprv_perelman')
end

-- 本回合应发的利息（与结算逻辑同款公式）
local function unprv_perelman_interest()
    if G.GAME.dollars >= 5 and not G.GAME.modifiers.no_interest then
        return G.GAME.interest_amount * math.min(math.floor(G.GAME.dollars / 5), G.GAME.interest_cap / 5)
    end
    return 0
end

-- 被跳过的盲注奖励金额（小 3 / 大 4 / Boss 5）
local function unprv_perelman_skip_reward()
    local skipped = G.GAME.blind_on_deck or 'Small'
    if skipped == 'Small' then
        return G.P_BLINDS.bl_small and G.P_BLINDS.bl_small.dollars or 3
    elseif skipped == 'Big' then
        return G.P_BLINDS.bl_big and G.P_BLINDS.bl_big.dollars or 4
    end
    return 5
end

-- 少吃入账：+2 倍率/$1，累计满 $100 达成 X10000
local function unprv_perelman_grow(e, amount)
    if amount <= 0 then return false end
    e.refused = e.refused + amount
    e.mult = e.mult + amount * 2
    if e.refused >= 100 and not e.milestone then
        e.milestone = true
        return true
    end
    return false
end

-- 拒领百万：结算界面不显示利息行（已被拒领），其余收入行照常
local add_round_eval_row_ref = add_round_eval_row
function add_round_eval_row(config)
    config = config or {}
    if unprv_has_perelman() and config.name == 'interest' then
        return
    end
    if add_round_eval_row_ref then
        add_round_eval_row_ref(config)
    end
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
        SMODS.Joker({
            key = 'perelman',
            config = { extra = { refused = 0, mult = 0, milestone = false, counted_round = 0 } },
            rarity = 3,          -- Rare
            cost = 8,
            -- 占位：原版（5,4）帧，美术图集完成后换 unprv_jokers
            pos = { x = 5, y = 4 },
            -- 拒领百万：无法出售
            can_sell = function(self, card, context)
                return false
            end,
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 16,
            loc_vars = function(self, info_queue, card)
                local e = card.ability.extra
                return { vars = { e.refused, e.mult } }
            end,
            calculate = function(self, card, context)
                local e = card.ability.extra
                -- 利息被拒领：应发的利息不进钱包，转为 +2 倍率/$1
                -- 静默转换 + 按回合去重：end_of_round 一回合会被派发多次（原版 end_round 调两次、
                -- 下回合开局还会再触发一次），消息会排队拖慢结算，这里一律不返回。
                if context.end_of_round and context.main_eval and not context.individual and not context.blueprint and not context.retrigger_joker then
                    if e.counted_round ~= G.GAME.round then
                        e.counted_round = G.GAME.round
                        local amount = unprv_perelman_interest()
                        unprv_perelman_grow(e, amount)
                        if amount > 0 then
                            card:juice_up(0.3, 0.4)
                        end
                    end
                end
                -- 结算总额里扣除利息部分（其余收入照常入袋）
                if context.modify_final_cashout and not context.blueprint then
                    local amount = unprv_perelman_interest()
                    if amount > 0 and SMODS.cashout_dollars then
                        SMODS.cashout_dollars = math.max(0, UNPRV.num(SMODS.cashout_dollars) - amount)
                    end
                end
                -- 跳过盲注：放弃的盲注奖励转为 +2 倍率/$1
                if context.skip_blind and not context.blueprint then
                    local amount = unprv_perelman_skip_reward()
                    local hit_milestone = unprv_perelman_grow(e, amount)
                    return {
                        message = '少吃 $' .. amount .. '：+' .. (amount * 2) .. ' 倍率',
                        colour = G.C.MULT,
                    }
                end
                -- 计分：平铺 +2/$1 倍率；少吃满 $100 后永久 X10000
                if context.joker_main and not context.blueprint then
                    if e.milestone then
                        return {
                            message = 'X10000',
                            mult = e.mult,
                            xmult = 10000,
                            colour = G.C.XMULT,
                        }
                    end
                    if e.mult > 0 then
                        return {
                            message = '+' .. e.mult,
                            mult = e.mult,
                            colour = G.C.MULT,
                        }
                    end
                end
            end,
        }),
        SMODS.Joker({
            key = 'calabiyau',
            config = { extra = { counted_round = 0 } },
            rarity = 3,          -- Rare
            cost = 10,
            -- 占位：原版（5,0）帧，美术图集完成后换 unprv_jokers
            pos = { x = 5, y = 0 },
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            order = 17,
            loc_vars = function(self, info_queue, card)
                local view = ((G.GAME.round or 1) - 1) % 4
                return { vars = { localize('unprv_calabiyau_v' .. view) } }
            end,
            calculate = function(self, card, context)
                -- 视角由回合号决定（跳过盲注也算一回合）：
                -- 第1回合 +100筹码，第2 +20倍率，第3 X2，第4 +$8，四回合循环
                local view = ((G.GAME.round or 1) - 1) % 4
                -- 视角 0/1/2：计分时每手牌生效
                if context.joker_main and not context.blueprint then
                    if view == 0 then
                        return {
                            message = '+100',
                            chips = 100,
                            colour = G.C.CHIPS,
                        }
                    elseif view == 1 then
                        return {
                            message = '+20',
                            mult = 20,
                            colour = G.C.MULT,
                        }
                    elseif view == 2 then
                        return {
                            message = 'X2',
                            xmult = 2,
                            colour = G.C.XMULT,
                        }
                    end
                end
                -- 视角 3：回合结束发 $8（按回合去重，end_of_round 一回合派发多次）
                if context.end_of_round and context.main_eval and not context.individual and not context.blueprint and not context.retrigger_joker then
                    if view == 3 and card.ability.extra.counted_round ~= G.GAME.round then
                        card.ability.extra.counted_round = G.GAME.round
                        return {
                            message = '+$8',
                            dollars = 8,
                            colour = G.C.MONEY,
                        }
                    end
                end
            end,
        }),
    },
}
