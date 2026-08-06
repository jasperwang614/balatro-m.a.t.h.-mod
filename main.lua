--- 未证之牌 UNPROVEN · main.lua
--- 内容线：猜想 / 大事件 / 熵 / 梗 / 名数
UNPRV = SMODS.current_mod

-- 数值安全转换：兼容 Amulet 大数系统把筹码/倍率存成字符串的情况
function UNPRV.num(v)
    if type(v) == "number" then
        return v
    end
    if type(v) == "string" then
        return tonumber(v:gsub(",", "")) or 0
    end
    return 0
end

-- 开发调试：开新局自动把“当前测试中的卡”加入小丑栏，省去控制台刷卡。
-- 列表里放当前测试卡 + 联动测试用的原版卡（如泼溅 j_splash）；做下一张时改这里。
-- 正式发布时置为 nil 或删掉本段。
local DEBUG_ADD_CARDS = {
    -- 2026-08-06 冯·诺依曼 + 阿达 + Attention + EDVAC 测试
    "j_unprv_riemann",
    "j_unprv_vonneumann",
    "j_unprv_lovelace",
    "j_unprv_attention",
    "j_unprv_edvac",
}

local DEBUG_ADD_CONSUMABLES = {
    -- 全量回归已测完，暂时清空
    "c_unprv_draft",
}

if DEBUG_ADD_CARDS or DEBUG_ADD_CONSUMABLES then
    local game_start_run_ref = Game.start_run
    function Game:start_run(args)
        game_start_run_ref(self, args)
        if G.GAME and not G.GAME.unprv_debug_cards_added and G.GAME.challenge ~= 'c_unprv_tour' then
            G.GAME.unprv_debug_cards_added = true
            if DEBUG_ADD_CARDS then
                for _, center_key in ipairs(DEBUG_ADD_CARDS) do
                    pcall(add_joker, center_key)
                end
            end
            if DEBUG_ADD_CONSUMABLES then
                for _, center_key in ipairs(DEBUG_ADD_CONSUMABLES) do
                    pcall(function()
                        local c = SMODS.create_card({ key = center_key, area = G.consumeables })
                        if c then
                            c:add_to_deck()
                            G.consumeables:emplace(c)
                        end
                    end)
                end
            end
        end
    end
end

-- 调试：开局金币直接设为 25（测拒领百万的利息触发：回合结束钱 > 利息封顶 25），
-- 正式发布时置为 nil 或删掉本段。
local DEBUG_START_MONEY = 25

if DEBUG_START_MONEY then
    local game_start_run_ref = Game.start_run
    function Game:start_run(args)
        game_start_run_ref(self, args)
        if G.GAME and not G.GAME.unprv_debug_money_set and G.GAME.challenge ~= 'c_unprv_tour' then
            G.GAME.unprv_debug_money_set = true
            G.GAME.dollars = DEBUG_START_MONEY
        end
    end
end

-- 调试：第一手牌必含 3 和 A（测欧拉恒等式终极彩蛋 e+3+A），正式发布删掉本段
-- 2026-08-02：欧拉恒等式已实测，关闭以免干扰新卡测试
local DEBUG_RIG_E3A = false

local function debug_ensure_rank(rank_id)
    if not (G.hand and G.hand.cards and G.deck and G.deck.cards) then
        return
    end
    for _, c in ipairs(G.hand.cards) do
        if c:get_id() == rank_id then
            return
        end
    end
    for i = #G.deck.cards, 1, -1 do
        local dc = G.deck.cards[i]
        if dc:get_id() == rank_id then
            for _, hc in ipairs(G.hand.cards) do
                if hc:get_id() ~= rank_id then
                    if hc.area then
                        hc.area:remove_card(hc)
                    end
                    if dc.area then
                        dc.area:remove_card(dc)
                    end
                    hc:add_to_deck()
                    G.deck:emplace(hc)
                    dc:add_to_deck()
                    G.hand:emplace(dc)
                    return
                end
            end
        end
    end
end

if DEBUG_RIG_E3A then
    local set_round_rig_ref = Game.set_round
    function Game:set_round(r)
        set_round_rig_ref(self, r)
        if G.GAME and not G.GAME.unprv_debug_e3a_done then
            G.GAME.unprv_debug_e3a_done = true
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    if not (G.hand and #G.hand.cards >= 2) then
                        return false
                    end
                    debug_ensure_rank(3)
                    debug_ensure_rank(14)
                    return true
                end,
            }))
        end
    end
end

-- 调试：强制 Boss 盲注为七桥问题（get_new_boss 读取原版 G.FORCE_BOSS）
local DEBUG_FORCE_BOSS = true

if DEBUG_FORCE_BOSS then
    if G then
        G.FORCE_BOSS = 'bl_unprv_konigsberg'
    end
    local game_start_run_ref_boss = Game.start_run
    function Game:start_run(args)
        game_start_run_ref_boss(self, args)
        G.FORCE_BOSS = 'bl_unprv_konigsberg'
    end
end

-- 开发期暂用原版图集占位（各 Joker 不写 atlas，SMODS 默认用原版 Joker 图集，
-- 用 pos 指向原版图案）。
-- 美术图集完成后：放 assets/1x/jokers.png 与 assets/2x/jokers.png，启用下面两行，
-- 并把每张卡 atlas 改回 "unprv_jokers"。
SMODS.Atlas({ key = "unprv_jokers", path = "jokers.png", px = 71, py = 95 })

-- “注意到……”的角标贴纸：被注意到的牌在左上角打一个常驻标签，
-- 复用原版 stickers 图集 (5,0) 帧做占位（红系图标=醒目），回合结束摘除。
SMODS.Sticker({
    key = "unprv_notice",
    pos = { x = 5, y = 0 },
    badge_colour = HEX("e04848"),
    prefix_config = { key = false },
    should_apply = false,
    order = 5,
})

-- “罗素的信”的失效角标：被指定的小丑在回合内打上红色角标，
-- 复用原版 stickers 图集 (5,0) 帧做占位，回合结束摘除。
SMODS.Sticker({
    key = "unprv_letter",
    pos = { x = 5, y = 0 },
    badge_colour = HEX("8a2f2f"),
    prefix_config = { key = false },
    should_apply = false,
    order = 6,
})

-- “草稿”的涂改角标：被涂改的牌在左上方打一个铅笔色标签，结算后摘除。
SMODS.Sticker({
    key = "unprv_draft",
    pos = { x = 5, y = 0 },
    badge_colour = HEX("b5a642"),
    prefix_config = { key = false },
    should_apply = false,
    order = 7,
})

local function load_folder(folder)
    local files = NFS.getDirectoryItems(UNPRV.path .. folder)
    table.sort(files)
    for _, f in ipairs(files) do
        if f:match("%.lua$") then
            assert(SMODS.load_file(folder .. "/" .. f))()
        end
    end
end

load_folder("items")
