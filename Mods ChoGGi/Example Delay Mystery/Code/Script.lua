-- See LICENSE for terms

local rule_id = "replace with gamerule id"

local ChoOrig_Mysteries_InitMystery = Mysteries.InitMystery
function Mysteries:InitMystery(...)

	-- abort if gamerule isn't active
	local active_rules = GetActiveGameRules()
	if not table.find(active_rules, rule_id) then
		return ChoOrig_Mysteries_InitMystery(self, ...)
	end

	if self.mystery_id ~= "" then
		-- override the expression before we load the mystery
		local cls_obj = g_Classes[self.mystery_id]
		local scenario = DataInstances.Scenario[cls_obj.scenario_name]
		if scenario then
			-- first table always seems to be the trigger/start table
			local scenario = scenario[1]
			for i = 1, #scenario do
				local sa = scenario[i]
				if sa:IsKindOf("SA_WaitExpression") then
					-- since the expression is a string we can just prefix what we want to check
					sa.expression = "UICity.day >= 100 and" .. sa.expression
					-- got what we wanted so kill the loop (don't want to replace all the expressions)
					break
				end
			end
		end

		cls_obj:new{city = self}
	end
	Msg("MysteryChosen")

end
