-- See LICENSE for terms

local function StartupCode()
	if not g_RoverAIResearched then
		Msg("TechResearched", "RoverCommandAI", UICity)
	end
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
