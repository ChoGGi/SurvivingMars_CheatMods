-- See LICENSE for terms

local mod_id = "ChoGGi_DomeTeleporters"
local mod = Mods[mod_id]

local mod_BuildDist = 20
function OnMsg.ApplyModOptions(id)
	if id ~= mod_id then
		return
	end

	local value = mod.options.BuildDist
	mod_BuildDist = value
	CityDomeTeleporterConstruction[UICity].max_hex_distance_to_allow_build = value
	CityDomeTeleporterConstruction[UICity].max_range = value < 100 and 100 or value
	-- I don't think anymore will spawn once one has, but whatever
	DomeTeleporterConstructionController.max_hex_distance_to_allow_build = value
	DomeTeleporterConstructionController.max_range = value < 100 and 100 or value
end


GlobalVar("CityDomeTeleporterConstruction", {})

local Sleep = Sleep
local table_unpack = table.unpack

-- chooses which construct mode to start
local orig_GetCurrentConstructionControllerDlg = GetCurrentConstructionControllerDlg
function GetCurrentConstructionControllerDlg(...)
	return InGameInterfaceMode == "dome_teleporter_construction" and CityDomeTeleporterConstruction[UICity] or orig_GetCurrentConstructionControllerDlg(...)
end

-- add our custom construction controller
function OnMsg.NewMap()
	CityDomeTeleporterConstruction[UICity] = DomeTeleporterConstructionController:new()
end
function OnMsg.LoadGame()
	CityDomeTeleporterConstruction[UICity] = DomeTeleporterConstructionController:new()
--~ 	local dlg = ChoGGi.ComFuncs.OpenInExamineDlg(CityDomeTeleporterConstruction[UICity])
--~ 	dlg:EnableAutoRefresh()
--~ 	ex(CityTunnelConstruction[UICity])

	local AddPFTunnel = Tunnel.AddPFTunnel
	MapForEach("map","DomeTeleporter", AddPFTunnel)
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
local function CallTunnelFunc(func,...)
	GetCityTunnelConstruction()
	CityTunnelConstruction = CityDomeTeleporterConstruction
	local ret = {func(...)}
	CityTunnelConstruction = GetCityTunnelConstruction()
	return table_unpack(ret)
end

local orig_OpenTunnelConstructionInfopanel = OpenTunnelConstructionInfopanel
function OpenTunnelConstructionInfopanel(...)
	return CallTunnelFunc(orig_OpenTunnelConstructionInfopanel,...)
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
	"OnMouseButtonDown",
	"OnMouseButtonDoubleClick",
	"OnMousePos",
	"OnKbdKeyDown",
	"OnShortcut",
}
function OnMsg.ClassesBuilt()
	local TunnelConstructionDialog = TunnelConstructionDialog
	local DomeTeleporterConstructionDialog = DomeTeleporterConstructionDialog

	for i = 1, #funcs do
		local name = funcs[i]
		DomeTeleporterConstructionDialog[name] = function(...)
			return CallTunnelFunc(TunnelConstructionDialog[name],...)
		end
	end
end

-- controller->
DefineClass.DomeTeleporterConstructionController = {
	__parents = {"TunnelConstructionController"},
	max_hex_distance_to_allow_build = mod_BuildDist,
}

local TunnelConstructionController = TunnelConstructionController

local orig_CreateConstructionGroup = CreateConstructionGroup
function DomeTeleporterConstructionController.Activate(...)

	function CreateConstructionGroup(template,...)
		if template == "Tunnel" then
			template = "DomeTeleporter"
		end
		return orig_CreateConstructionGroup(template,...)
	end

	local ret = {TunnelConstructionController.Activate(...)}

	CreateConstructionGroup = orig_CreateConstructionGroup
	return table_unpack(ret)

end
