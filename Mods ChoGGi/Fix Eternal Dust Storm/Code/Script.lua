-- See LICENSE for terms

function OnMsg.InGameInterfaceCreated()
	if not g_DustStorm then
		return
	end

	-- ...
	StopDustStorm()

	-- skip working dust storms
	local not_broked
	local notes = g_ActiveOnScreenNotifications
	for i = 1, #notes do
		local id = notes[i][1]
		if type(id) == "string" and id:find("DustStorm") then
			not_broked = true
		end
	end
	if not_broked then
		return
	end

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
