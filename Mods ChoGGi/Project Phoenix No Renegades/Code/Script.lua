-- See LICENSE for terms

local mod_EnableMod
local mod_NoNegative

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_NoNegative = CurrentModOptions:GetProperty("NoNegative")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

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
