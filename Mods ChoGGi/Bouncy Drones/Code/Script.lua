-- See LICENSE for terms

local options
local mod_Gravity
local mod_GravityRC
local mod_GravityColonist

-- fired when settings are changed/init
local function ModOptions()
	mod_Gravity = options.Gravity * 1000
	mod_GravityRC = options.GravityRC * 1000
	mod_GravityColonist = options.GravityColonist * 10
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_BouncyDrones" then
		return
	end

	ModOptions()
end

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
