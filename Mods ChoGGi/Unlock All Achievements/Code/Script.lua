-- See LICENSE for terms

CreateRealTimeThread(function()
	local AchievementUnlock = AchievementUnlock
	local EngineCanUnlockAchievement = EngineCanUnlockAchievement
	local XPlayerActive = XPlayerActive
	local WaitMsg = WaitMsg
	local AchievementPresets = AchievementPresets

	for id in pairs(AchievementPresets) do
		if EngineCanUnlockAchievement(XPlayerActive, id) then
			AchievementUnlock(XPlayerActive, id)
			WaitMsg("OnRender")
		end
	end
end)