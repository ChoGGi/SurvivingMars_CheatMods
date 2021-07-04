-- See LICENSE for terms

local IsValid = IsValid
local table = table

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
