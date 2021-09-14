-- See LICENSE for terms

local GetTerrainTextureIndex = GetTerrainTextureIndex

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

local mapped_textures
local function AddMap(bad, good)
	mapped_textures[GetTerrainTextureIndex(bad)] = GetTerrainTextureIndex(good)
end

local function UpdateTextures()
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

	mapped_textures = {}

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

	if mod_DustGeysers then
		AddMap("Spider", "RockDark")
		local objs = MapGet("map", "DecSpider")
		for i = 1, #objs do
			objs[i]:SetVisible(false)
		end
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

	if next(mapped_textures) then
		SuspendPassEdits("ChoGGi_FixMirrorGraphics")
		ActiveGameMap.terrain:RemapType(mapped_textures)
		ResumePassEdits("ChoGGi_FixMirrorGraphics")
	end
end


-- fired when settings are changed/init
local function ModOptions()
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

	-- make sure we're in-game
	if not UICity then
		return
	end

	UpdateTextures()
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	-- I'm sure it wouldn't be that hard to only call this msg for the mod being applied, but...
	if id == CurrentModId then
		ModOptions()
	end
end

-- fire when a building is built
OnMsg.BuildingInit = UpdateTextures

OnMsg.CityStart = UpdateTextures
OnMsg.LoadGame = UpdateTextures

function OnMsg.TerrainTexturesChanged()
	if mod_TerraSoil then
--~   local soil_terrain_idx = GetTerrainTextureIndex("TerraSoilQuality")
		local soil_terrain_idx = GetTerrainTextureIndex("SandMIX_01")
		hr.SoilTextureIdx = soil_terrain_idx or -1
		hr.RenderSoilGrid = soil_terrain_idx and 1 or 0
	end
end
