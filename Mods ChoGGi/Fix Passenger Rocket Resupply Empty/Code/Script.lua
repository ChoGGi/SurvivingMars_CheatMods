-- See LICENSE for terms

local mod_EnableMod

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local orig_TraitFilterColonist = TraitFilterColonist
function TraitFilterColonist(trait_filter, ...)
	if not mod_EnableMod then
		return orig_TraitFilterColonist(trait_filter, ...)
	end

	-- quick n dirty
	for key, value in pairs(trait_filter or empty_table) do
		if value == true or value == false then
			trait_filter[key] = nil
		end
	end
	return orig_TraitFilterColonist(trait_filter, ...)
end