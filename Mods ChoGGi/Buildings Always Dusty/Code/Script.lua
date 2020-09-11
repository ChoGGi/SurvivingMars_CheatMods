-- See LICENSE for terms

local mod_AlwaysDusty
local mod_AlwaysClean

-- fired when settings are changed/init
local function ModOptions()
	mod_AlwaysDusty = CurrentModOptions:GetProperty("AlwaysDusty")
	mod_AlwaysClean = CurrentModOptions:GetProperty("AlwaysClean")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

local orig_SetDustVisuals = BuildingVisualDustComponent.SetDustVisuals
function BuildingVisualDustComponent:SetDustVisuals(dust, ...)

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
	return orig_SetDustVisuals(self, dust, ...)
end
