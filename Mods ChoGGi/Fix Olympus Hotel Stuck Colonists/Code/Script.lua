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

OnMsg.LoadGame = ChoGGi.ComFuncs.ResetHumanCentipedes
