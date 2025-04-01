-- See LICENSE for terms

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate

--
-- Copied from ChoGGi_Funcs.Common.SortBuildMenuItems()
local SortBuildMenuItems = rawget(_G, "ChoGGi_Funcs") and ChoGGi_Funcs.Common.SortBuildMenuItems
	or function()
		local templates = Presets.BuildingTemplate
		for i = 1, #templates do
			local items = templates[i]

			table.sort(items, function(a, b)
				return CmpLower(_InternalTranslate(a.display_name), _InternalTranslate(b.display_name))
			end)

			for j = 1, #items do
				items[j].build_pos = j
			end
		end
	end

local mod_EnableMod

local function StartupCode()
	if not mod_EnableMod then
		return
	end

	SortBuildMenuItems()
end


-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- Make sure we're in-game
	if not UIColony then
		return
	end

	StartupCode()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- New games
OnMsg.CityStart = StartupCode
-- Saved ones
OnMsg.LoadGame = StartupCode
