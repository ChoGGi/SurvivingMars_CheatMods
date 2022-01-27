-- See LICENSE for terms

local IsValid = IsValid
local table = table

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

	local objs = UICity.labels.RCRover or ""
	for i = 1, #objs do
		local attached_drones = objs[i].attached_drones
		for j = #attached_drones, 1, -1 do
			local drone = attached_drones[j]
			if not IsValid(drone) then
				table.remove(attached_drones, j)
			end
		end
	end
end
