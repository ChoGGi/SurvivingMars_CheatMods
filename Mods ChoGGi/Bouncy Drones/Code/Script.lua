-- See LICENSE for terms

local mod_id = "ChoGGi_BouncyDrones"
local mod = Mods[mod_id]

local mod_Gravity = (mod.options and mod.options.Gravity or 2) * 1000
local mod_GravityRC = (mod.options and mod.options.GravityRC or 10) * 1000
local mod_GravityColonist = (mod.options and mod.options.GravityColonist or 250) * 10

local function BouncyDronesUpdate()
	local labels = UICity.labels

	local label = labels.Drone or ""
	for i = 1, #label do
		label[i]:SetGravity(mod_Gravity)
	end

	label = labels.Rover or ""
	for i = 1, #label do
		label[i]:SetGravity(mod_GravityRC)
	end

	label = labels.Colonist or ""
	for i = 1, #label do
		label[i]:SetGravity(mod_GravityColonist)
	end
end

local function ModOptions()
	mod_Gravity = mod.options.Gravity * 1000
	mod_GravityRC = mod.options.GravityRC * 1000
	mod_GravityColonist = mod.options.GravityColonist * 10

	BouncyDronesUpdate()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= mod_id then
		return
	end

	ModOptions()
end

-- for some reason mod options aren't retrieved before this script is loaded...
OnMsg.CityStart = ModOptions
OnMsg.LoadGame = ModOptions
