-- See LICENSE for terms

CreateRealTimeThread(function()
	local AchievementUnlock = AchievementUnlock
	local EngineCanUnlockAchievement = EngineCanUnlockAchievement
	local WaitMsg = WaitMsg
	local XPlayerActive = XPlayerActive

	local AchievementPresets = AchievementPresets
	for id in pairs(AchievementPresets) do
		if EngineCanUnlockAchievement(XPlayerActive, id) then
			AchievementUnlock(XPlayerActive, id)
			WaitMsg("OnRender")
		end
	end
end)