-- See LICENSE for terms

local mod_BuildDist

-- fired when settings are changed/init
local function ModOptions()
	local value = CurrentModOptions:GetProperty("BuildDist")
	mod_BuildDist = value

	if GameState.gameplay then
		CityDomeTeleporterConstruction[UICity].max_hex_distance_to_allow_build = value
		CityDomeTeleporterConstruction[UICity].max_range = value < 100 and 100 or value
		-- I don't think anymore will spawn once one has, but whatever
		DomeTeleporterConstructionController.max_hex_distance_to_allow_build = value
		DomeTeleporterConstructionController.max_range = value < 100 and 100 or value
	end
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

GlobalVar("CityDomeTeleporterConstruction", {})

local table_unpack = table.unpack

-- chooses which construct mode to start
local orig_GetConstructionController = GetConstructionController
function GetConstructionController(mode, ...)
  mode = mode or InGameInterfaceMode
	return mode == "dome_teleporter_construction" and CityDomeTeleporterConstruction[UICity] or orig_GetConstructionController(mode, ...)
end

-- add our custom construction controller
function OnMsg.NewMap()
	if UICity then
		CityDomeTeleporterConstruction[UICity] = DomeTeleporterConstructionController:new()
	end
end
function OnMsg.LoadGame()
	CityDomeTeleporterConstruction[UICity] = DomeTeleporterConstructionController:new()
--~ 	-- dbg
--~ 	local dlg = ChoGGi.ComFuncs.OpenInExamineDlg(CityDomeTeleporterConstruction[UICity])
--~ 	dlg:EnableAutoRefresh()
--~ 	dlg = ChoGGi.ComFuncs.OpenInExamineDlg(CityTunnelConstruction[UICity])
--~ 	dlg:EnableAutoRefresh()
--~ 	-- dbg

	local AddPFTunnel = Tunnel.AddPFTunnel
	MapForEach("map", "DomeTeleporter", AddPFTunnel)
end

-- backup the CityTunnelConstruction obj
local orig_CityTunnelConstruction
local function GetCityTunnelConstruction()
	if not orig_CityTunnelConstruction or not orig_CityTunnelConstruction[UICity] then
		orig_CityTunnelConstruction = CityTunnelConstruction
	end
	return orig_CityTunnelConstruction
end

-- this is called by some func in TunnelConstructionDialog
local function CallTunnelFunc(func, ...)
	GetCityTunnelConstruction()
	CityTunnelConstruction = CityDomeTeleporterConstruction
	local ret = {func(...)}
	CityTunnelConstruction = GetCityTunnelConstruction()
	return table_unpack(ret)
end

local orig_OpenTunnelConstructionInfopanel = OpenTunnelConstructionInfopanel
function OpenTunnelConstructionInfopanel(template, ...)
	if template == "DomeTeleporter" then
		return CallTunnelFunc(orig_OpenTunnelConstructionInfopanel, template, ...)
	end
	return orig_OpenTunnelConstructionInfopanel(template, ...)
end

DefineClass.DomeTeleporterConstructionDialog = {
	__parents = {"TunnelConstructionDialog"},
	mode_name = "dome_teleporter_construction",
}

-- we need to swap out the CityTunnelConstruction obj for these funcs
local funcs = {
	"Init",
	"Open",
	"Close",
	"TryPlace",
	"OnKbdKeyDown",
	"OnMouseButtonDown",
	"OnMouseButtonDoubleClick",
	"OnMousePos",
	"OnShortcut",

	"OnSystemVirtualKeyboard",
	"OnXButtonRepeat",
	"OnXNewPacket",
}

local TunnelConstructionController_cls
function OnMsg.ClassesBuilt()
	TunnelConstructionController_cls = TunnelConstructionController

	local TunnelConstructionDialog = TunnelConstructionDialog
	local DomeTeleporterConstructionDialog = DomeTeleporterConstructionDialog
	for i = 1, #funcs do
		local name = funcs[i]
		DomeTeleporterConstructionDialog[name] = function(...)
			return CallTunnelFunc(TunnelConstructionDialog[name], ...)
		end
	end

end

-- controller->
DefineClass.DomeTeleporterConstructionController = {
	__parents = {"TunnelConstructionController"},
	max_hex_distance_to_allow_build = mod_BuildDist,
}

local orig_CreateConstructionGroup = CreateConstructionGroup
function DomeTeleporterConstructionController.Activate(...)
	-- replace func so it returns our template
	function CreateConstructionGroup(template, ...)
		if template == "Tunnel" then
			template = "DomeTeleporter"
		end
		return orig_CreateConstructionGroup(template, ...)
	end
	-- get obj
	local ret = {TunnelConstructionController_cls.Activate(...)}
	-- restore func
	CreateConstructionGroup = orig_CreateConstructionGroup
	-- and done
	return table_unpack(ret)
end
