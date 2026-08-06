-- Boss 盲注 · 七桥问题（设计文档 §2.2）
-- 每种花色本回合只能计分一次：首次计分后，该花色的所有牌（手牌+牌堆）被 debuff，
-- 下一回合开始自动解禁。（欧拉 1736，图论诞生）

local function unprv_is_konigsberg()
    local b = G.GAME and G.GAME.blind
    if not (b and b.config) then
        return false
    end
    local key = b.config.key or (b.config.blind and b.config.blind.key)
    return key == 'bl_unprv_konigsberg'
end

-- 每手牌结算后：锁定本手已计分花色，并 debuff 手牌/牌堆中该花色的牌
local evaluate_play_ref = G.FUNCS.evaluate_play
function G.FUNCS.evaluate_play(e)
    evaluate_play_ref(e)
    if not (G.GAME and unprv_is_konigsberg()) then
        return
    end
    local suits = G.GAME.unprv_konigsberg_suits
    if not suits then
        suits = {}
        G.GAME.unprv_konigsberg_suits = suits
    end
    if G.play and G.play.cards then
        for _, c in ipairs(G.play.cards) do
            if c.base and c.base.suit then
                suits[c.base.suit] = true
            end
        end
    end
    for _, area in ipairs({ G.hand, G.deck }) do
        if area and area.cards then
            for _, c in ipairs(area.cards) do
                if c.base and c.base.suit and suits[c.base.suit] then
                    c.unprv_konigsberg = true
                    if not c.debuff then
                        c:set_debuff(true)
                    end
                end
            end
        end
    end
end

-- 回合开始：清空锁定并解禁（只解我们自己 debuff 的牌；new_round 才是回合初始化）
local new_round_ref = new_round
function new_round()
    new_round_ref()
    if G.GAME then
        G.GAME.unprv_konigsberg_suits = {}
        for _, area in ipairs({ G.hand, G.deck, G.play, G.discard }) do
            if area and area.cards then
                for _, c in ipairs(area.cards) do
                    if c.unprv_konigsberg then
                        c.unprv_konigsberg = nil
                        if c.debuff then
                            c:set_debuff(false)
                        end
                    end
                end
            end
        end
    end
end

return {
    items = {
        SMODS.Blind({
            key = 'konigsberg',
            pos = { x = 0, y = 27 },
            dollars = 5,
            mult = 2,
            boss = { min = 1, max = 10 },
            boss_colour = HEX('4a7c59'),
        }),
    },
}
