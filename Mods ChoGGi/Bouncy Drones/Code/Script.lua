-- See LICENSE for terms

local mod_Gravity
local mod_GravityRC
local mod_GravityColonist

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_Gravity = CurrentModOptions:GetProperty("Gravity") * 100
	mod_GravityRC = CurrentModOptions:GetProperty("GravityRC") * 100
	mod_GravityColonist = CurrentModOptions:GetProperty("GravityColonist") * 10
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local function UpdateGravity(objs, value)
	for i = 1, #(objs or "") do
		objs[i]:SetGravity(value)
	end
end

local function StartupCode()
	local labels = UICity.labels

	UpdateGravity(labels.Drone, mod_Gravity)
	UpdateGravity(labels.Rover, mod_GravityRC)
	UpdateGravity(labels.Colonist, mod_GravityColonist)
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
