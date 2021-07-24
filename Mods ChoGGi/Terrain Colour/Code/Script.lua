-- See LICENSE for terms

--~ local UsedTerrainTextures = ChoGGi.ComFuncs.UsedTerrainTextures

-- remove in 10.1
local UsedTerrainTextures = ChoGGi.ComFuncs.UsedTerrainTextures or function(ret)
	if not UICity then
		return
	end

	-- If fired from action menu
	if IsKindOf(ret, "XAction") then
		ret = nil
	end

	local MulDivRound = MulDivRound
	local TerrainTextures = TerrainTextures

	local tm = terrain.GetTypeGrid()
	local _, levels_info = tm:levels(true, 1)
	local size = tm:size()
	local textures = {}
	for level, count in pairs(levels_info) do
		local texture = TerrainTextures[level]
		if texture then
			local perc = MulDivRound(100, count, size * size)
			if perc > 0 then
				textures[texture.name] = perc
			end
		end
	end

	if ret then
		return textures
	end
end
-- remove in 10.1

local mod_EnableMod
local mod_ChangeColour1
local mod_ChangeColour2
local mod_ChangeColour3
local mod_ChangeColour4

local function RemoveHighestVal(values)
	local value_name
	local highest_value = 0
	for name, count in pairs(values) do
		if count > highest_value then
			highest_value = count
			value_name = name
		end
	end
	values[value_name] = nil

	return value_name
end

local function NewColours()
	if not mod_EnableMod then
		return
	end

	local remaps = {}

	-- make a table of highest counts then grab the three highest from it
	local used = UsedTerrainTextures(true)
	local used_textures = {}
	-- good enough for a small table
	used_textures[1] = RemoveHighestVal(used)
	used_textures[2] = RemoveHighestVal(used)
	used_textures[3] = RemoveHighestVal(used)
	used_textures[4] = RemoveHighestVal(used)

	if mod_ChangeColour1 ~= "Default" then
		remaps[TerrainNameToIdx[used_textures[1]]] = TerrainNameToIdx[mod_ChangeColour1]
	end
	if mod_ChangeColour2 ~= "Default" then
		remaps[TerrainNameToIdx[used_textures[2]]] = TerrainNameToIdx[mod_ChangeColour2]
	end
	if mod_ChangeColour3 ~= "Default" then
		remaps[TerrainNameToIdx[used_textures[3]]] = TerrainNameToIdx[mod_ChangeColour3]
	end
	if mod_ChangeColour4 ~= "Default" then
		remaps[TerrainNameToIdx[used_textures[4]]] = TerrainNameToIdx[mod_ChangeColour4]
	end

	if next(remaps) then
		SuspendPassEdits("ChoGGi_TerrainColour")
		terrain.RemapType(remaps)
		ResumePassEdits("ChoGGi_TerrainColour")
	end

end


-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_ChangeColour1 = CurrentModOptions:GetProperty("ChangeColour1")
	mod_ChangeColour2 = CurrentModOptions:GetProperty("ChangeColour2")
	mod_ChangeColour3 = CurrentModOptions:GetProperty("ChangeColour3")
	mod_ChangeColour4 = CurrentModOptions:GetProperty("ChangeColour4")

	-- make sure we're in-game
	if not UICity then
		return
	end

	NewColours()
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
