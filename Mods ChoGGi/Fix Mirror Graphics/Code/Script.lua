-- See LICENSE for terms

local mod_EnableMod
local mod_DumpingSites
local mod_DomeGrass
local mod_DomeBeachSand
local mod_DomeRubble
local mod_DustGeysers
local mod_TerraGrass
local mod_TerraLake
local mod_TerraLichen
local mod_TerraMoss
local mod_TerraSoil
local mod_Asteroid
local mod_Underground

local function UpdateTextures()
	-- make sure we're in-game
	if not MainCity then
		return
	end

	if not mod_EnableMod then
		-- show spiders again
		if mod_DustGeysers then
			local objs = MapGet("map", "DecSpider")
			for i = 1, #objs do
				objs[i]:SetVisible(true)
			end
		end

		return
	end

	local mapped_textures = {}
	local GetTerrainTextureIndex = GetTerrainTextureIndex
	local function AddMap(old, new)
		mapped_textures[GetTerrainTextureIndex(old)] = GetTerrainTextureIndex(new)
	end

	if mod_DustGeysers then
		AddMap("Spider", "RockDark")

		local objs = MapGet("map", "DecSpider")
		for i = 1, #objs do
			objs[i]:SetVisible(false)
		end
	end

	if mod_DumpingSites then
		AddMap("WasteRock", "RockLight")
	end

	if mod_DomeGrass then
		AddMap("Grass_01", "Prefab_Green")
		AddMap("Grass_02", "Prefab_Green")
	end
	if mod_DomeBeachSand then
		AddMap("BeachSand", "SandRed_stones_2")
	end
	if mod_DomeRubble then
		AddMap("DomeRubble", "ChaosSet03_02")
		AddMap("DomeDemolish", "ChaosSet03_01")
	end

	if mod_TerraGrass then
		AddMap("TerraGrass_01", "Sand_01")
		AddMap("TerraGrass_02", "Sand_02")
		AddMap("TerraGrass_03", "Gravel_01")
		AddMap("TerraGrassDead_01", "RockRed_1")
		AddMap("TerraGrassDead_02", "RockRed_2")
	end
	if mod_TerraLake then
		AddMap("TerraLake_01", "SandDune_01")
		AddMap("TerraLake_02", "RockDark")
	end
	if mod_TerraLichen then
		AddMap("TerraLichen_01", "GravelDark")
		AddMap("TerraLichen_02", "GravelRed_1")
		-- yep, that's ugly, but it works for the colours (I think they're toxic rain colours)
		AddMap("TerraLichen_03", "Prefab_Orange")
		AddMap("TerraLichen_04", "Prefab_Yellow")
	end
	if mod_TerraMoss then
		AddMap("TerraMoss_01", "SandFrozen")
	end
	if mod_TerraSoil then
		AddMap("TerraSoil_01", "Chaos_light")
		AddMap("TerraSoilQuality", "SandMIX_01")
	end

	if mod_Asteroid then
		AddMap("Asteroid_Gravel_01", "Chaos_light")
		AddMap("Asteroid_Gravel_02", "SandDark_01")
		AddMap("Asteroid_Gravel_03", "Sand_01")
		AddMap("Asteroid_Gravel_04", "SandRed_1")
		AddMap("Asteroid_Gravel_05", "SandDune_01")
		AddMap("Asteroid_Sand_01", "SandFrozen")
		AddMap("Asteroid_Sand_02", "RockRed_1")
		AddMap("Asteroid_Sand_03", "RockRed_2")
		AddMap("Asteroid_Sand_04", "Chaos_light")
		AddMap("Asteroid_Sand_05", "ChaosSet03_01")
		AddMap("Asteroid_Sand_06", "SandRed_stones_2")
		AddMap("Asteroid_Sand_07", "SandDark_02")
		AddMap("Asteroid_Sand_08", "SandRed_stones_1")
		AddMap("Asteroid_Rocks_01", "RockDark")
		AddMap("Asteroid_Rocks_02", "RockLight")
		AddMap("Asteroid_Rocks_03", "SandFrozen")
		AddMap("Asteroid_Rocks_04", "ChaosSet03_01")
		AddMap("Asteroid_Vein_01", "Prefab_Red")
		AddMap("Asteroid_Vein_02", "Prefab_Orange")
		AddMap("Asteroid_Vein_03", "Prefab_Violet")
		AddMap("DustRust_Asteroid", "RockDark")
	end
	if mod_Underground then
		AddMap("Underground_Gravel_01", "Chaos_light")
		AddMap("Underground_Gravel_02", "SandRed_1")
		AddMap("Underground_Rocks_01", "RockDark")
		AddMap("Underground_Rocks_02", "GravelDark")
		AddMap("Underground_Rocks_03", "RockLight")
		AddMap("Underground_Rocks_04", "SandFrozen")
		AddMap("Underground_Sand_01", "SandDark_02")
		AddMap("Underground_Sand_02", "SandDark_01")
		AddMap("DustRust_Underground", "RockDark")
	end

	if next(mapped_textures) then
		SuspendPassEdits("ChoGGi_FixMirrorGraphics")
		GetActiveTerrain():RemapType(mapped_textures)
		ResumePassEdits("ChoGGi_FixMirrorGraphics")
	end
end


local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions
	mod_EnableMod = options:GetProperty("EnableMod")
	mod_DumpingSites = options:GetProperty("DumpingSites")
	mod_DomeGrass = options:GetProperty("DomeGrass")
	mod_DomeBeachSand = options:GetProperty("DomeBeachSand")
	mod_DomeRubble = options:GetProperty("DomeRubble")
	mod_DustGeysers = options:GetProperty("DustGeysers")
	mod_TerraGrass = options:GetProperty("TerraGrass")
	mod_TerraLake = options:GetProperty("TerraLake")
	mod_TerraLichen = options:GetProperty("TerraLichen")
	mod_TerraMoss = options:GetProperty("TerraMoss")
	mod_TerraSoil = options:GetProperty("TerraSoil")
	mod_Asteroid = options:GetProperty("Asteroid")
	mod_Underground = options:GetProperty("Underground")

	UpdateTextures()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- fire when a building is built
OnMsg.BuildingInit = UpdateTextures

OnMsg.CityStart = UpdateTextures
OnMsg.LoadGame = UpdateTextures
-- Switch between different maps (can happen before UICity)
OnMsg.ChangeMapDone = UpdateTextures

function OnMsg.TerrainTexturesChanged()
	-- Update terraformed soil
	if mod_TerraSoil then
		local soil_terrain_idx = GetTerrainTextureIndex("SandMIX_01")
		hr.SoilTextureIdx = soil_terrain_idx or -1
		hr.RenderSoilGrid = soil_terrain_idx and 1 or 0
	end
end

-- ~TerrainTextures

--[[ Sort by alpha and ex as plain table/str
local tbl, str = ChoGGi.ComFuncs.PlainSortTable(table.icopy(TerrainTextures))
ex(tbl)
ex(str)
]]
