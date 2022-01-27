-- See LICENSE for terms

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

-- the bugged save I got was on an empty map, so...
function OnMsg.CityStart()
	if not mod_EnableMod then
		return
	end

	LandscapeLastMark = 0
end

function OnMsg.LoadGame()
	if not mod_EnableMod then
		return
	end

	-- If there's placed landscapes grab the largest number
	local Landscapes = Landscapes
	if Landscapes and next(Landscapes) then
		local largest = 0
		for idx in pairs(Landscapes) do
			if idx > largest then
				largest = idx
			end
		end
		-- If over 3K then reset to 0
		if largest > 3000 then
			LandscapeLastMark = 0
		else
			LandscapeLastMark = largest + 1
		end
	else
		-- no landscapes so 0 it is
		LandscapeLastMark = 0
	end
end
