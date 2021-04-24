-- See LICENSE for terms

if LuaRevision < 1001569 then

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

end

-- If we need to wait for the map
function OnMsg.LoadGame()
	if CurrentModOptions:GetProperty("EnableMod") then
		ChoGGi.ComFuncs.ResetHumanCentipedes()
	end
end
