-- See LICENSE for terms

if not g_AvailableDlc.shepard then
	print("Block Pets needs DLC Installed: Project Laika!")
	return
end

local DoneObject = DoneObject

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

-- fired when settings are changed/init
local function ModOptions()
	local options = CurrentModOptions

	mod_EnableMod = options:GetProperty("EnableMod")
	mod_SpawnDelayPercent = (options:GetProperty("SpawnDelayPercent") + 0.0) / 100
	for id in pairs(mod_options) do
		mod_options[id] = options:GetProperty(id)
	end

end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

-- override spawn funcs for the pets
local spawn_classes = {
	"StaticPet",
	"RoamingPet",
	"Pet",
}
for i = 1, #spawn_classes do
	local class = _G[spawn_classes[i]]

	local orig_func = class.Spawn
	class.Spawn = function(self, ...)
		if mod_EnableMod and mod_options[self.animal_type] then
			DoneObject(self)
			return
		end
		return orig_func(self, ...)
	end
end

-- halve spawn delay for more animals
local orig_SpawnPets = SpawnPets
function SpawnPets(...)
	if not mod_EnableMod then
		return orig_SpawnPets(...)
	end

	return orig_SpawnPets(...) * mod_SpawnDelayPercent
end
