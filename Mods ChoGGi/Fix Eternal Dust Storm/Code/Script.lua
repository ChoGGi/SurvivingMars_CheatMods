-- See LICENSE for terms

local tostring, string = tostring, string

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

function OnMsg.InGameInterfaceCreated()
	if not mod_EnableMod or not g_DustStorm then
		return
	end

	-- ...
	StopDustStorm()

	-- skip working dust storms
	local notes = g_ActiveOnScreenNotifications
	for i = 1, #notes do
		if string.find(tostring(notes[i][1]), "DustStorm") then
			return
		end
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
