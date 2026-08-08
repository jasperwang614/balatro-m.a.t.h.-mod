-- 成就系统（v1.4，8 个已定稿）
-- 触发方式：各卡在达成条件处调用 UNPRV.unlock('ach_unprv_xxx')，防重复弹成就

UNPRV.unlock = function(key)
    if not (G.SETTINGS and G.SETTINGS.ACHIEVEMENTS_EARNED and not G.SETTINGS.ACHIEVEMENTS_EARNED[key]) then
        return
    end
    -- 计分期（HAND_PLAYED）插 unlock_achievement 的 no_delete 事件会卡死结算队列：
    -- 先挂起，等状态安全再补发
    if G.STATE and G.STATE == G.STATES.HAND_PLAYED then
        G.GAME.unprv_pending_achievements = G.GAME.unprv_pending_achievements or {}
        G.GAME.unprv_pending_achievements[key] = true
        return
    end
    pcall(unlock_achievement, key)
end

-- 状态离开计分期后，补发挂起的成就
local game_update_ref = Game.update
function Game:update(dt)
    game_update_ref(self, dt)
    if G.GAME and G.GAME.unprv_pending_achievements and G.STATE and G.STATE ~= G.STATES.HAND_PLAYED then
        local pending = G.GAME.unprv_pending_achievements
        G.GAME.unprv_pending_achievements = nil
        for key in pairs(pending) do
            UNPRV.unlock(key)
        end
    end
end

-- 数学家集结：胜利时持有 5 位不同数学家小丑
local win_game_ref = win_game
function win_game()
    win_game_ref()
    if G.jokers and G.jokers.cards and UNPRV.count_mathematician_cards then
        if UNPRV.count_mathematician_cards() >= 5 then
            UNPRV.unlock('ach_unprv_maths_win')
        end
    end
end

return {
    items = {
        SMODS.Achievement({ key = 'q84', unlock_condition = {} }),
        SMODS.Achievement({ key = 'g2inbox', unlock_condition = {} }),
        SMODS.Achievement({ key = 'chain_galois', unlock_condition = {} }),
        SMODS.Achievement({ key = 'vn29', unlock_condition = {} }),
        SMODS.Achievement({ key = 'bernoulli_fields', unlock_condition = {} }),
        SMODS.Achievement({ key = 'maths_win', unlock_condition = {} }),
        SMODS.Achievement({ key = 'e_gate', unlock_condition = {} }),
        SMODS.Achievement({ key = 'mathpack', unlock_condition = {} }),
    },
}
