-- See LICENSE for terms

local IsValid = IsValid

local function ToggleSign(obj, value)
	if not obj.suspended and not obj.ui_working then
		local attach = obj:GetAttach("SignStopped")
		-- Little paranoid
		if IsValid(attach) then
			-- SetSignsVisible() uses enumflags, so we use SetVisible
			attach:SetVisible(value)
		end
	end
end

local mod_EnableMod

local function UpdateAllSigns()
	if not UIColony then
		return
	end

	-- No need to do all maps, we check on ChangeMapDone
	local objs = MapGet("map", "BaseBuilding")
	for i = 1, #objs do
		ToggleSign(objs[i], not mod_EnableMod)
	end

end
-- New games
OnMsg.CityStart = UpdateAllSigns
-- Saved ones
OnMsg.LoadGame = UpdateAllSigns
--~ -- Daily
--~ OnMsg.NewDay = UpdateAllSigns
-- Switch between different maps (can happen before UICity)
OnMsg.ChangeMapDone = UpdateAllSigns

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	UpdateAllSigns()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- Update when signs change
local ChoOrig_BaseBuilding_DoUpdateSignsVisibility = BaseBuilding.DoUpdateSignsVisibility
function BaseBuilding:DoUpdateSignsVisibility(...)
	if not mod_EnableMod then
		return ChoOrig_BaseBuilding_DoUpdateSignsVisibility(self, ...)
	end

	-- Needs to update first
	ChoOrig_BaseBuilding_DoUpdateSignsVisibility(self, ...)

	ToggleSign(self)
end
