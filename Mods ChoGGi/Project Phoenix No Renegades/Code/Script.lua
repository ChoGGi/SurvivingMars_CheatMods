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

	-- The func is called after they die so no reason we can't fiddle with their traits.
	-- You'd normally need to use :RemoveTrait() but the func creates a new colonist so it only needs the trait list.
	local traits = self.traits

	-- Always remove Renegade
  traits.Renegade = nil

	-- Any other negative traits
	if mod_NoNegative then

		local neg_traits = Presets.TraitPreset.Negative
    for trait_id in pairs(traits) do
      local trait = neg_traits[trait_id]
			if trait then
        traits[trait_id] = nil
			end
    end

	end

	return ChoOrig_Colonist_ProjectPhoenixEffect(self, ...)
end
