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

	local objs = UICity.labels.Drone or ""
	for i = 1, #objs do
		local obj = objs[i]
		if obj:IsKindOf("FlyingDrone") and commands[obj.command] and not obj:IsLanded() then
			CreateGameTimeThread(obj.Land, obj)
		end
	end
end


-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- make sure we're in-game
	if not UICity then
		return
	end
	ResetFlyingDrones()
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

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
