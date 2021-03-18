-- See LICENSE for terms

local doors = {
	"MegaMallDoor_01",
	"MegaMallDoor_02",
	"MegaMallDoor_03",
	"MegaMallFloorDoor_01",
	"MegaMallFloorDoor_02",
	"MegaMallFloorDoor_03",
}

local DefineClass = DefineClass
for i = 1, #doors do
	local door = doors[i]
	DefineClass[door] = {
		__parents = {"Door"},
		entity = door,
	}
end

local GetPassablePointNearby = GetPassablePointNearby
local point = point
local Random = ChoGGi.ComFuncs.Random

local ResetHumanCentipedes

function OnMsg.ModsReloaded()
	local ModsLoaded = ModsLoaded
	-- no need to check for dependencies
	if ModsLoaded[table.find(ModsLoaded, "id", "ChoGGi_Library")].version > 9.2 then
		ResetHumanCentipedes = ChoGGi.ComFuncs.ResetHumanCentipedes
	else
		ResetHumanCentipedes = function()
			local objs = UICity.labels.Colonist or ""
			for i = 1, #objs do
				local obj = objs[i]
				-- only need to do people walking outside (pathing issue), and if they don't have a path (not moving or walking into an invis wall)
				if obj:IsValidPos() and not obj:GetPath() then
					-- too close and they keep doing the human centipede
					obj:SetCommand("Goto",
						GetPassablePointNearby(obj:GetVisualPos()+point(Random(-1000, 1000), Random(-1000, 1000)))
					)
				end
			end
		end
	end

	OnMsg.LoadGame = ResetHumanCentipedes
end
