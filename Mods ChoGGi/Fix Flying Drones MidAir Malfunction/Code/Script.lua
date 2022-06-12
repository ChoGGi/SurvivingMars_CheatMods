-- See LICENSE for terms

local CreateGameTimeThread = CreateGameTimeThread

local mod_EnableMod

local commands = {
	NoBattery = true,
	Malfunction = true,
	Freeze = true,
}

local function ResetFlyingDrones()
	if not mod_EnableMod then
		return
	end

	local objs = UIColony.city_labels.labels.Drone or ""
	for i = 1, #objs do
		local obj = objs[i]
		if obj:IsKindOf("FlyingDrone") and commands[obj.command] and not obj:IsLanded() then
			CreateGameTimeThread(obj.Land, obj)
		end
	end
end


local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- Make sure we're in-game
	if not UICity then
		return
	end

	ResetFlyingDrones()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

GlobalVar("g_ChoGGi_FixFlyingDronesMidAirMalfunction", false)

local function StartupCode()
	if not mod_EnableMod then
		return
	end

	if g_ChoGGi_FixFlyingDronesMidAirMalfunction then
		return
	end

	ResetFlyingDrones()

	g_ChoGGi_FixFlyingDronesMidAirMalfunction = true
end


OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

-- they added land to FlyingDrone:Dead, but not any of these...
local funcs = {"Malfunction", "Freeze", "NoBattery"}

for i = 1, #funcs do
	local func = funcs[i]
	local orig = FlyingDrone[func]
	FlyingDrone[func] = function(self, ...)

		if mod_EnableMod and not self:IsLanded() then
			-- self:Land()
			-- this needs to be in another thread so it'll show the busted drone while landing instead of after
			CreateGameTimeThread(self.Land, self)
		end

		return orig(self, ...)
	end
end
