-- See LICENSE for terms

function OnMsg.LoadGame()
	local g_CurrentMissionParams = g_CurrentMissionParams
	local GameRulesMap = GameRulesMap

	local rules = g_CurrentMissionParams.idGameRules
	if rules then
		for rule_id in pairs(rules) do
			-- if it isn't in the map then it isn't a valid rule
			if not GameRulesMap[rule_id] then
				g_CurrentMissionParams.idGameRules[rule_id] = nil
			end
		end
	end

end
