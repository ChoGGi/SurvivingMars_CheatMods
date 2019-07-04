-- See LICENSE for terms

function OnMsg.LoadGame()
	local rules = g_CurrentMissionParams.idGameRules or empty_table
	local GameRulesMap = GameRulesMap
	for rule_id in pairs(rules) do
		-- if it isn't in the map then it isn't a valid rule
		if not GameRulesMap[rule_id] then
			rules[rule_id] = nil
		end
	end
end
