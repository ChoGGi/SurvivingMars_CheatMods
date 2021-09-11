-- See LICENSE for terms

--~ function TunnelConstructionController:UpdateCursor(pt)
--~   ShowNearbyHexGrid(pt)
--~   if IsValid(self.cursor_obj) then
--~ 	ex(self)
--~     local terrain = GetTerrain(self.city)
--~     self.cursor_obj:SetPos(FixConstructPos(terrain, pt))
--~   end
--~   ObjModified(self)
--~   if not self.template_obj or not self.cursor_obj then
--~     return
--~   end
--~   self:UpdateConstructionObstructors()
--~   self:UpdateConstructionStatuses(pt)
--~   self:UpdateShortConstructionStatus()
--~ end


local mod_BuildDist

-- fired when settings are changed/init
local function ModOptions()
	mod_BuildDist = CurrentModOptions:GetProperty("BuildDist")

	DomeTeleporterConstructionController.max_hex_distance_to_allow_build = mod_BuildDist
	DomeTeleporterConstructionController.max_range = mod_BuildDist < 100 and 100 or mod_BuildDist
	if UICity then
		CityDomeTeleporterConstruction[UICity].max_hex_distance_to_allow_build = mod_BuildDist
		CityDomeTeleporterConstruction[UICity].max_range = mod_BuildDist < 100 and 100 or mod_BuildDist
	end
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

GlobalVar("CityDomeTeleporterConstruction", {})

local table = table

-- chooses which construct mode to start
local orig_GetConstructionController = GetConstructionController
function GetConstructionController(mode, ...)
  mode = mode or InGameInterfaceMode
	return mode == "dome_teleporter_construction" and CityDomeTeleporterConstruction[UICity] or orig_GetConstructionController(mode, ...)
end

-- add our custom construction controller
function OnMsg.NewMap()
	local city = UICity
	if city then
		CityDomeTeleporterConstruction[city] = DomeTeleporterConstructionController:new()
		-- why city is false on it...?
		CityDomeTeleporterConstruction[city].city = CityDomeTeleporterConstruction[city].city or city
	end
end
function OnMsg.LoadGame()
	local city = UICity
	CityDomeTeleporterConstruction[city] = DomeTeleporterConstructionController:new()
	-- why city is false on it...?
	CityDomeTeleporterConstruction[city].city = CityDomeTeleporterConstruction[city].city or city

--~ 	-- dbg
--~ 	local dlg = ChoGGi.ComFuncs.OpenInExamineDlg(CityDomeTeleporterConstruction[UICity])
--~ 	dlg:EnableAutoRefresh()
--~ 	dlg = ChoGGi.ComFuncs.OpenInExamineDlg(CityTunnelConstruction[UICity])
--~ 	dlg:EnableAutoRefresh()
--~ 	-- dbg

	local AddPFTunnel = Tunnel.AddPFTunnel
	ActiveGameMap.realm:MapForEach("map", "DomeTeleporter", AddPFTunnel)
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
	return table.unpack(ret)
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
	return table.unpack(ret)
end
