-- See LICENSE for terms

-- fired when settings are changed/init
local function ModOptions()
	MaxRouteLength = CurrentModOptions:GetProperty("MaxSafariLength")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end
