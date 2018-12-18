-- See LICENSE for terms

function OnMsg.LoadGame()
	if not g_DustStorm then
		return
	end

	-- ...
	StopDustStorm()

	-- what should be getting called with the above func, but the thread was stopped already without it happening.
	if g_DustStorm.type == "electrostatic" then
		PlayFX("ElectrostaticStorm", "end")
	elseif g_DustStorm.type == "great" then
		PlayFX("GreatStorm", "end")
	else
		PlayFX("DustStorm", "end")
	end
	g_DustStorm = false
	g_DustStormStart = false
	g_DustStormEnd = false

	Msg("DustStormEnded")
end
