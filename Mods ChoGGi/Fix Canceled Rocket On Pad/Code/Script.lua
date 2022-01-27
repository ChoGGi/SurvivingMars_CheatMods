-- See LICENSE for terms

local mod_EnableMod

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

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
