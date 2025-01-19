-- See LICENSE for terms

if not g_AvailableDlc.shepard then
	print(CurrentModDef.title, ": Project Laika DLC not installed! Abort!")
	return
end

local classes = {
  RoamingPet = true,
  Pet = true,
  StaticPet = true,
}

local mod_EnableMod
local mod_SpawnDelayPercent
local mod_options = {}

local Animals = Animals
for id, def in pairs(Animals) do
	if classes[def.AnimalClass] then
		mod_options[id] = true
	end
end

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions

	mod_EnableMod = options:GetProperty("EnableMod")
	mod_SpawnDelayPercent = (options:GetProperty("SpawnDelayPercent") + 0.0) / 100
	for id in pairs(mod_options) do
		mod_options[id] = options:GetProperty(id)
	end

end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- override spawn funcs for the pets
local spawn_classes = {
	"StaticPet",
	"RoamingPet",
	"Pet",
}
for i = 1, #spawn_classes do
	local class = _G[spawn_classes[i]]

	local ChoOrig_func = class.Spawn
	class.Spawn = function(self, ...)
		if mod_EnableMod and mod_options[self.animal_type] then
			self:delete()
			return
		end
		return ChoOrig_func(self, ...)
	end
end

-- halve spawn delay for more animals
local ChoOrig_SpawnPets = SpawnPets
function SpawnPets(...)
	if not mod_EnableMod then
		return ChoOrig_SpawnPets(...)
	end

	return ChoOrig_SpawnPets(...) * mod_SpawnDelayPercent
end
