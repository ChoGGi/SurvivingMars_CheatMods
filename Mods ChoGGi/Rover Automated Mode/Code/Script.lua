-- See LICENSE for terms

local function StartupCode()
	if not g_RoverAIResearched then
		Msg("TechResearched", "RoverCommandAI", UIColony)
	end
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
