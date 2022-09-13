-- See LICENSE for terms

local table = table
local tostring = tostring

local mod_MaxRubble

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_MaxRubble = CurrentModOptions:GetProperty("MaxRubble")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local stones = {
	"StonesDarkGroup_01",
	"StonesDarkGroup_02",
	"StonesDarkGroup_03",
	"StonesDarkSmall_01",
	"StonesDarkSmall_02",
	"StonesDarkSmall_03",
	"StonesDarkSmall_04",
	"StonesDarkSmall_05",
	"StonesDarkSmall_06",
	"StonesRedSmall_01",
	"StonesRedSmall_02",
	"StonesRedSmall_03",
	"StonesRedSmall_04",
	"StonesRedSmall_05",
	"StonesSlate_01",
	"StonesSlate_02",
	"StonesSlate_03",
	"StonesSlate_04",
	"StonesSlate_05",
	"StonesSlate_06",
	"StonesSlateSmall_01",
	"StonesSlateSmall_02",
	"StonesSlateSmall_03",
	"StonesSlateSmall_04",
	"StonesSlateSmall_05",
	"StonesSlateSmall_06",
	"RocksLightSmall_01",
	"RocksLightSmall_02",
	"RocksLightSmall_03",
	"RocksLightSmall_04",
	"RocksLightSmall_05",
	"RocksLightSmall_06",
	"RocksLightSmall_07",
	"RocksLightSmall_08",
}

GlobalVar("g_ChoGGi_RockySurface_spawnrocks", false)

local function StartupCode()
	-- abort if not main map (loaded save on asteroid/underground)
	if not GameMaps or g_ChoGGi_RockySurface_spawnrocks or ActiveMapID ~= MainMapID then
		return
	end

	local realm = GameMaps[MainMapID].realm

	local positions = {}
	while true do

		local pos = realm:GetRandomPassablePoint():SetTerrainZ()
		positions[tostring(pos)] = pos

		if table.count(positions) >= mod_MaxRubble then
			break
		end
	end

--~ 	ex(positions)
	local axis_z = axis_z
	local WasteRockObstructor = WasteRockObstructor
	CreateRealTimeThread(function()
		SuspendPassEdits("ChoGGi.RockySurface.spawnrocks")

		for _, pos in pairs(positions) do
			local rock_obj = WasteRockObstructor:new()
			rock_obj:Rotate(axis_z, rock_obj:Random(21600))
			local ent = table.rand(stones)
			rock_obj:ChangeEntity(ent)
			rock_obj:SetPos(pos)
		end
		g_ChoGGi_RockySurface_spawnrocks = true

		ResumePassEdits("ChoGGi.RockySurface.spawnrocks")
	end)
end

-- Wait for a map to spawn rocks on
function OnMsg.CityStart()
	CreateRealTimeThread(function()
		WaitMsg("MapSectorsReady")
		StartupCode()
	end)
end
OnMsg.LoadGame = StartupCode
OnMsg.ChangeMapDone = StartupCode
