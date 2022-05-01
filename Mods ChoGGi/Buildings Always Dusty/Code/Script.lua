-- See LICENSE for terms

local mod_AlwaysDusty
local mod_AlwaysClean
local mod_SkipCablesPipes

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_AlwaysDusty = CurrentModOptions:GetProperty("AlwaysDusty")
	mod_AlwaysClean = CurrentModOptions:GetProperty("AlwaysClean")
	mod_SkipCablesPipes = CurrentModOptions:GetProperty("SkipCablesPipes")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local function SetDust(self, dust, func, ...)
	-- always dusty gets first dibs
	if mod_AlwaysDusty then
		if not self.ChoGGi_AlwaysDust or self.ChoGGi_AlwaysDust < dust then
			self.ChoGGi_AlwaysDust = dust
		end
		dust = self.ChoGGi_AlwaysDust
	-- If dusty is disabled and clean is enabled
	elseif mod_AlwaysClean then
		self.ChoGGi_AlwaysDust = nil
		dust = 0
	end

	-- orig func do your thing
	return func(self, dust, ...)
end

-- buildings
local ChoOrig_BuildingVisualDustComponent_SetDustVisuals = BuildingVisualDustComponent.SetDustVisuals
function BuildingVisualDustComponent:SetDustVisuals(dust, ...)
	return SetDust(self, dust, ChoOrig_BuildingVisualDustComponent_SetDustVisuals, ...)
end
-- domes
local ChoOrig_Building_SetDustVisuals = Building.SetDustVisuals
function Building:SetDustVisuals(dust, ...)
	return SetDust(self, dust, ChoOrig_Building_SetDustVisuals, ...)
end
-- pipes/cables
local ChoOrig_DustGridElement_AddDust = DustGridElement.AddDust
function DustGridElement:AddDust(dust, ...)
	if mod_SkipCablesPipes then
		return ChoOrig_DustGridElement_AddDust(self, dust, ...)
	end
	return SetDust(self, dust, ChoOrig_DustGridElement_AddDust, ...)
end
