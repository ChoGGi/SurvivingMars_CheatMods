-- See LICENSE for terms

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

function OnMsg.LoadGame()
	if not mod_EnableMod then
		return
	end

	local IsValid = IsValid
	local pads = UICity.labels.LandingPad or ""
	for i = 1, #pads do
		local pad = pads[i]
		if pad.rocket_construction and not IsValid(pad.rocket_construction) then
			pad.rocket_construction = false
		end
	end
end
