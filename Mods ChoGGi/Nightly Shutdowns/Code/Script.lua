-- See LICENSE for terms

local mod_EnableMod

function OnMsg.ModsReloaded()
	local ChoOrig_Dome_HasAir = Dome.HasAir
	local function HasAir(self, ...)
		local consump_added = self.city.label_modifiers.Dome and self.city.label_modifiers.Dome.ChoGGi_NightlyShutdowns_AirConsumption

		if not mod_EnableMod or GetAtmosphereBreathable(ActiveMapID) then
			-- remove my override
			if consump_added then
				self.city:SetLabelModifier("Dome", "ChoGGi_NightlyShutdowns_AirConsumption")
			end
			return ChoOrig_Dome_HasAir(self, ...)
		end


		if SunAboveHorizon then
			if consump_added then
				-- turn on grid consumption of air by domes
				self.city:SetLabelModifier("Dome", "ChoGGi_NightlyShutdowns_AirConsumption")
			end

			return ChoOrig_Dome_HasAir(self, ...)
		else
			if not consump_added then
				-- turn off grid consumption of air by domes
				self.city:SetLabelModifier("Dome", "ChoGGi_NightlyShutdowns_AirConsumption", Modifier:new({
					prop = "disable_air_consumption",
					amount = 1,
					percent = 0,
					id = "ChoGGi_NightlyShutdowns",
				}))
			end

			-- returns nil
		end

	end

	-- hook into each dome class obj
	ClassDescendantsList("Dome", function(_, class)
		-- skip open cities
		if ChoOrig_Dome_HasAir == class.HasAir then
			class.HasAir = HasAir
		end
	end)
end

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end
