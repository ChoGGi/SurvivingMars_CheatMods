-- See LICENSE for terms

-- Build list of mod options
local mod_options = {}

local traits = Presets.TraitPreset
for i = 1, #traits.Negative do
	mod_options[traits.Negative[i].id] = 0
end
for i = 1, #traits.Positive do
	mod_options[traits.Positive[i].id] = 0
end
mod_options.Vegan = 0

local mod_EnableMod

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions

	mod_EnableMod = options:GetProperty("EnableMod")

	for id in pairs(mod_options) do
		mod_options[id] = options:GetProperty(id)
	end

end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local function UpdateTraits(c)
	if not mod_EnableMod then
		return
	end

	for id, trait_setting in pairs(mod_options) do
		if trait_setting == 1 and not c.traits[id] then
			-- true isn't needed for RemoveTrait, and only needed for certain AddTrait
			c:AddTrait(id, true)
		elseif trait_setting == 2 and c.traits[id] then
			c:RemoveTrait(id)
		end
	end
end

OnMsg.ColonistArrived = UpdateTraits
OnMsg.ColonistBorn = UpdateTraits
