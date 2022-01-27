-- See LICENSE for terms

local mod_RemovePerks
local mod_RemoveFlaws
local mod_RemoveMartianborn

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions
	mod_RemovePerks = options:GetProperty("RemovePerks")
	mod_RemoveFlaws = options:GetProperty("RemoveFlaws")
	mod_RemoveMartianborn = options:GetProperty("RemoveMartianborn")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

function OnMsg.ColonistBorn(colonist, event)
	if event ~= "android" then
		return
	end

	-- remove traits
	local TraitPresets = TraitPresets
	if mod_RemoveFlaws or mod_RemovePerks then
		for trait in pairs(colonist.traits) do
			local trait_group = TraitPresets[trait]
			trait_group = trait_group and trait_group.group

			if mod_RemovePerks and trait_group == "Positive" then
				colonist:RemoveTrait(trait)
			elseif mod_RemoveFlaws and trait_group == "Negative" then
				colonist:RemoveTrait(trait)
			end
		end
	end

  if mod_RemoveMartianborn then
		colonist:RemoveTrait("Martianborn")
  end

end
