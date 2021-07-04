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

	local GetRandomPassableAround = GetRandomPassableAround
	local InvalidPos = ChoGGi.Consts.InvalidPos
	local table = table
	local radius = 100 * guim
	local positions = {}

	local objs = UICity.labels.DroneHub or ""
	for i = 1, #objs do
		local hub = objs[i]
		table.clear(positions)
		for j = 1 , #(hub.drones or "") do
			local drone = hub.drones[j]
			local pos = drone:GetPos()
			if pos == InvalidPos and drone.command == "Malfunction" then
				-- don't move more than one malf drone to same pos
				if not positions[tostring(pos)] then
					local new_pos = GetRandomPassableAround(hub:GetPos(), radius)
					drone:SetPos(new_pos:SetTerrainZ())
					positions[tostring(new_pos)] = true
				end
			end
		end
	end
end
