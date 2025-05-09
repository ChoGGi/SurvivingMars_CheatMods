-- See LICENSE for terms

local MapSetEnumFlags = MapSetEnumFlags
local efVisible = const.efVisible

local mod_ShowIcons
local mod_EnableMod
local mod_options = {}

local skips = {
	EffectDeposit = true,
	SubsurfaceAnomaly_aliens = true,
	SubsurfaceAnomaly_breakthrough = true,
	SubsurfaceAnomaly_complete = true,
	SubsurfaceAnomaly_unlock = true,
	SubsurfaceDeposit = true,
	SurfaceDeposit = true,
	SurfaceDepositConcrete = true,
	SurfaceDepositGroup = true,
	SurfaceDepositMetals = true,
	SurfaceDepositPolymers = true,
	TerrainDeposit = true,

	MetatronAnomaly = true,
	MirrorSphereAnomaly = true,
}

function OnMsg.ClassesPostprocess()
	ClassDescendantsList("Deposit", function(name)
		if not skips[name] then
			mod_options[name] = true
		end
	end)
end

local function ToggleIcons()
	if not mod_EnableMod then
		return
	end

	-- always reset everything to show then hide below
	MapSetEnumFlags(efVisible, "map", "TerrainDeposit", "SubsurfaceDeposit")

  if mod_ShowIcons then
		return
	end

	for id in pairs(mod_options) do
		if mod_options[id] then
			MapClearEnumFlags(efVisible, "map", id)
		end
	end

end
OnMsg.CityStart = ToggleIcons
OnMsg.LoadGame = ToggleIcons

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions

	for id in pairs(mod_options) do
		mod_options[id] = options:GetProperty(id)
	end

	mod_EnableMod = options:GetProperty("EnableMod")
	mod_ShowIcons = options:GetProperty("ShowIcons")

	-- Make sure we're in-game
	if not UIColony then
		return
	end
	ToggleIcons()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- zooming in from map overview
local ChoOrig_OverviewModeDialog_Close = OverviewModeDialog.Close
function OverviewModeDialog.Close(...)
	CreateRealTimeThread(function()
		WaitMsg("CameraTransitionEnd")
		ToggleIcons()
	end)
	return ChoOrig_OverviewModeDialog_Close(...)
end
