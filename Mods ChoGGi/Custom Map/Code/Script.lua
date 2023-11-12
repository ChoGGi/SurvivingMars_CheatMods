-- See LICENSE for terms

local mod_EnableMod
-- Map to change to
local selected_map
-- If certain Msgs fire then we don't want to override func
local abort

-- Build list of mod options
local mod_options = {}
local MapDataPresets = MapDataPresets
for id, item in pairs(MapDataPresets) do
	if item.IsRandomMap then
		mod_options[id] = false
	end
end

local ChoOrig_ChangeMap = ChangeMap
function ChangeMap(map_id, ...)

	if abort or not mod_EnableMod or not selected_map
		-- load game
		or not map_id or map_id == ""
	then
		return ChoOrig_ChangeMap(map_id, ...)
	end

	map_id = selected_map
	return ChoOrig_ChangeMap(map_id, ...)
end

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions

	-- Make sure nothing is selected (if user turned all off)
	selected_map = false

	-- Get first enabled mod option map name
	for id in pairs(mod_options) do
		if options:GetProperty(id) then
			selected_map = id
--~ 			printC(selected_map,"selected_map")
			break
		end
	end

	mod_EnableMod = options:GetProperty("EnableMod")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- Msg is fired from ChangeMap func
function OnMsg.ChangeMap()
	abort = true
end

-- Reset when going back to main menu
function OnMsg.GameStateChanged(changed)
  if changed.gameplay == false then
		abort = false
	end
end

-- Change red texture to ground
local function StartupCode()
	if not mod_EnableMod then
		return
	end
	-- make sure we're in-game
	if not UIColony then
		return
	end

	local mapped_textures = {
		[GetTerrainTextureIndex("Prefab_Red")] = GetTerrainTextureIndex("SandRed_1")
	}
	SuspendPassEdits("ChoGGi_FixMirrorGraphics")
	GetActiveTerrain():RemapType(mapped_textures)
	ResumePassEdits("ChoGGi_FixMirrorGraphics")
end

-- New games
OnMsg.CityStart = StartupCode
-- Saved ones
OnMsg.LoadGame = StartupCode