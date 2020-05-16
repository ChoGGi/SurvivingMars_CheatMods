-- See LICENSE for terms

local mod_TurnOff

-- fired when settings are changed/init
local function ModOptions()
	mod_TurnOff = CurrentModOptions:GetProperty("TurnOff")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end


function OnMsg.ConstructionSitePlaced(site)
	if not mod_TurnOff then
		return
	end

	RebuildInfopanel(site)
	site:SetUIWorking(false)
end
