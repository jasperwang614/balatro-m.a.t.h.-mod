-- 不妨设 WLOG · 梗线（设计文档 §2.4）
-- 交互型小丑：每回合一次，点击本卡进入选择模式 → 点击一张手牌 → 弹出 2~A 点数面板 → 永久改点数。
-- 蓝图/头脑风暴无法复制本卡（本卡没有计分效果，复制无意义；也天然避免“共享次数”问题）。
-- 实现要点：
--   * 钩 Card:click 拦截卡片点击（不破坏原版高亮/选择逻辑）
--   * 弹窗：UIBox + G.FUNCS 按钮回调（参照 Cryptid CHOOSE_CARD 模式）
--   * 改点数：SMODS.change_base（保留花色/增强/版本/封条）

local RANK_KEYS = { '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace' }
local RANK_LABELS = { '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A' }

local function unprv_wlog_close_popup()
    if UNPRV.wlog_popup then
        UNPRV.wlog_popup:remove()
        UNPRV.wlog_popup = nil
    end
end

local function unprv_wlog_msg(card, text)
    if card and card.area then
        card_eval_status_text(card, 'extra', nil, nil, nil, {
            message = text,
            colour = G.C.MULT,
        })
    end
end

local function unprv_wlog_disarm(mute)
    local armed = UNPRV.wlog_armed
    UNPRV.wlog_armed = nil
    if armed then
        armed.ability.unprv_armed = nil
        if not mute then
            unprv_wlog_msg(armed, localize('unprv_wlog_canceled'))
        end
    end
end

local function create_UIBox_unprv_wlog_picker()
    local contents = {
        { n = G.UIT.R, config = { align = 'cm', padding = 0.15 }, nodes = {
            { n = G.UIT.T, config = { text = localize('unprv_wlog_title'), scale = 0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
        }},
        { n = G.UIT.R, config = { align = 'cm', padding = 0.05 }, nodes = {
            { n = G.UIT.T, config = { text = localize('unprv_wlog_target'), scale = 0.38, colour = G.C.GOLD, shadow = true } },
        }},
        { n = G.UIT.R, config = { align = 'cm', padding = 0.04 }, nodes = {} },
    }
    -- 2~A 共 13 键，单行横排（紧凑按钮）
    local rank_row = contents[#contents]
    for i = 1, #RANK_LABELS do
        rank_row.nodes[#rank_row.nodes + 1] = UIBox_button({
            button = 'unprv_wlog_pick_rank',
            ref_table = { rank = RANK_KEYS[i], label = RANK_LABELS[i] },
            label = { RANK_LABELS[i] },
            minw = 0.55,
            maxw = 0.55,
            minh = 0.75,
            scale = 0.4,
            padding = 0.02,
            colour = G.C.SECONDARY_SET.Joker,
            focus_args = { snap_to = true },
        })
    end
    contents[#contents + 1] = { n = G.UIT.R, config = { align = 'cm', padding = 0.12 }, nodes = {
        UIBox_button({
            button = 'unprv_wlog_pick_cancel',
            label = { localize('unprv_wlog_cancel') },
            minw = 2.7,
            colour = G.C.RED,
            focus_args = { snap_to = true },
        }),
    }}
    return create_UIBox_generic_options({
        no_back = true,
        colour = G.C.L_BLACK,
        outline_colour = G.C.SECONDARY_SET.Joker,
        contents = contents,
        minw = 8.2,
    })
end

local function unprv_wlog_open_picker(joker, target)
    UNPRV.wlog_target = target
    UNPRV.wlog_popup = UIBox({
        definition = create_UIBox_unprv_wlog_picker(),
        config = {
            align = 'cm',
            offset = { x = 0, y = 10 },
            major = G.ROOM_ATTACH,
            bond = 'Weak',
            instance_type = 'POPUP',
        },
    })
    UNPRV.wlog_popup.alignment.offset.y = 0
    G.ROOM.jiggle = G.ROOM.jiggle + 1
    UNPRV.wlog_popup:align_to_major()
end

G.FUNCS.unprv_wlog_pick_rank = function(e)
    local joker = UNPRV.wlog_armed
    local target = UNPRV.wlog_target
    local rank = e and e.config and e.config.ref_table and e.config.ref_table.rank
    local label = e and e.config and e.config.ref_table and e.config.ref_table.label
    if not (joker and target and rank) then
        unprv_wlog_close_popup()
        return
    end
    if target.area ~= G.hand then
        -- 目标牌已不在手牌（异常路径），直接关闭
        unprv_wlog_close_popup()
        unprv_wlog_disarm(true)
        return
    end
    SMODS.change_base(target, nil, rank)
    joker.ability.extra.used = true
    target:juice_up(0.3, 0.5)
    play_sound('card1', 0.9, 0.5)
    unprv_wlog_close_popup()
    unprv_wlog_disarm(true)
    unprv_wlog_msg(joker, localize('unprv_wlog_done') .. ' ' .. tostring(label or ''))
end

G.FUNCS.unprv_wlog_pick_cancel = function()
    unprv_wlog_close_popup()
    unprv_wlog_disarm()
end

-- 出牌/弃牌时先清理弹窗与选择模式，防止状态残留
for _, name in ipairs({ 'play_cards_from_highlighted', 'discard_cards_from_highlighted' }) do
    local ref = G.FUNCS[name]
    if ref then
        G.FUNCS[name] = function(e)
            unprv_wlog_close_popup()
            unprv_wlog_disarm(true)
            ref(e)
        end
    end
end

local card_click_ref = Card.click
function Card:click()
    -- 弹窗打开时吞掉卡片点击，避免误选/误高亮
    if UNPRV.wlog_popup then
        return
    end
    -- 仅出牌阶段响应
    if G.STATE == G.STATES.SELECTING_HAND then
        local center_key = self.config.center and self.config.center.key
        if center_key == 'j_unprv_wlog' and self.area == G.jokers then
            if UNPRV.wlog_armed == self then
                unprv_wlog_disarm()
            elseif self.ability.extra.used then
                unprv_wlog_msg(self, localize('unprv_wlog_used'))
            else
                if UNPRV.wlog_armed then unprv_wlog_disarm(true) end
                UNPRV.wlog_armed = self
                self.ability.unprv_armed = true
                self:juice_up(0.3, 0.4)
                unprv_wlog_msg(self, localize('unprv_wlog_hint'))
            end
            return
        end
        if UNPRV.wlog_armed then
            if self.area == G.hand then
                unprv_wlog_open_picker(UNPRV.wlog_armed, self)
                return
            end
            if self == UNPRV.wlog_armed then
                unprv_wlog_disarm()
                return
            end
        end
    end
    card_click_ref(self)
end

return {
    SMODS.Joker({
        key = 'wlog',
        config = { extra = { used = false } },
        rarity = 3,          -- Rare
        cost = 8,
        -- 占位：原版（1,0）帧，美术图集完成后换 unprv_jokers
        pos = { x = 1, y = 0 },
        blueprint_compat = false,
        eternal_compat = true,
        perishable_compat = true,
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.used and localize('unprv_wlog_used') or '' } }
        end,
        calculate = function(self, card, context)
            -- 回合结束重置使用次数，并清理选择状态
            if context.end_of_round and not context.blueprint then
                card.ability.extra.used = false
                if UNPRV.wlog_armed == card then unprv_wlog_disarm(true) end
                unprv_wlog_close_popup()
            end
        end,
    }),
}
