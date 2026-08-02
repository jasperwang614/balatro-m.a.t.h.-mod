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

-- 开发期暂用原版图集占位（各 Joker 不写 atlas，SMODS 默认用原版 Joker 图集，
-- 用 pos 指向原版图案）。
-- 美术图集完成后：放 assets/1x/jokers.png 与 assets/2x/jokers.png，启用下面两行，
-- 并把每张卡 atlas 改回 "unprv_jokers"。
-- SMODS.Atlas({ key = "unprv_jokers", path = "jokers.png", px = 71, py = 95 })

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
