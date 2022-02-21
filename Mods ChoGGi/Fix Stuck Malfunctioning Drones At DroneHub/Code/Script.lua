-- See LICENSE for terms

local GetRandomPassableAround = GetRandomPassableAround
local table = table
local tostring = tostring
local radius = 100 * guim
local InvalidPos = ChoGGi.Consts.InvalidPos

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

	local positions = {}

	local objs = MainCity.labels.DroneHub or ""
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
