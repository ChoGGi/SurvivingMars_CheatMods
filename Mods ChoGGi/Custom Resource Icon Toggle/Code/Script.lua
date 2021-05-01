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

-- fired when settings are changed/init
local function ModOptions()
	local options = CurrentModOptions

	for id in pairs(mod_options) do
		mod_options[id] = options:GetProperty(id)
	end

	mod_EnableMod = options:GetProperty("EnableMod")
	mod_ShowIcons = options:GetProperty("ShowIcons")

	-- make sure we're in-game
	if not UICity then
		return
	end
	ToggleIcons()
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

OnMsg.CityStart = ToggleIcons
OnMsg.LoadGame = ToggleIcons

-- zooming in from map overview
local orig_OverviewModeDialog_Close = OverviewModeDialog.Close
function OverviewModeDialog.Close(...)
	CreateRealTimeThread(function()
		WaitMsg("CameraTransitionEnd")
		ToggleIcons()
	end)
	return orig_OverviewModeDialog_Close(...)
end
