-- See LICENSE for terms

local mod_EnableMod
local mod_NoNegative

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_NoNegative = CurrentModOptions:GetProperty("NoNegative")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_Colonist_ProjectPhoenixEffect = Colonist.ProjectPhoenixEffect
function Colonist:ProjectPhoenixEffect(...)
	if not mod_EnableMod then
		return ChoOrig_Colonist_ProjectPhoenixEffect(self, ...)
	end

	local traits = self.traits

	-- always remove Renegade
  traits.Renegade = nil
	-- and any other negatives
	if mod_NoNegative then
		local TraitPresets = TraitPresets
    for trait_id in pairs(traits) do
      local trait = TraitPresets[trait_id]
      local category = trait and trait.group or false
      if category and category == "Negative" then
        traits[trait_id] = nil
      end
    end
	end

	return ChoOrig_Colonist_ProjectPhoenixEffect(self, ...)
end
