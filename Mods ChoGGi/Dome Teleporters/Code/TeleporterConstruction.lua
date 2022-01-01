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

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

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
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

GlobalVar("CityDomeTeleporterConstruction", {})

local table = table

-- chooses which construct mode to start
local ChoOrig_GetConstructionController = GetConstructionController
function GetConstructionController(mode, ...)
  mode = mode or InGameInterfaceMode
	return mode == "dome_teleporter_construction" and CityDomeTeleporterConstruction[UICity] or ChoOrig_GetConstructionController(mode, ...)
end

-- add our custom construction controller
local function AddController()
	local city = UICity
	if city then
		CityDomeTeleporterConstruction[city] = DomeTeleporterConstructionController:new()
		CityDomeTeleporterConstruction[city].city = CityDomeTeleporterConstruction[city].city or city
	end
end
OnMsg.NewMap = AddController
OnMsg.ChangeMapDone = AddController

function OnMsg.LoadGame()
	local city = UICity
	CityDomeTeleporterConstruction[city] = DomeTeleporterConstructionController:new()
	CityDomeTeleporterConstruction[city].city = CityDomeTeleporterConstruction[city].city or city

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
local ChoOrig_CityTunnelConstruction
local function GetCityTunnelConstruction()
	if not ChoOrig_CityTunnelConstruction or not ChoOrig_CityTunnelConstruction[UICity] then
		ChoOrig_CityTunnelConstruction = CityTunnelConstruction
	end
	return ChoOrig_CityTunnelConstruction
end

-- this is called by some func in TunnelConstructionDialog
local function CallTunnelFunc(func, ...)
	GetCityTunnelConstruction()
	CityTunnelConstruction = CityDomeTeleporterConstruction
	local ret = {func(...)}
	CityTunnelConstruction = GetCityTunnelConstruction()
	return table.unpack(ret)
end

local ChoOrig_OpenTunnelConstructionInfopanel = OpenTunnelConstructionInfopanel
function OpenTunnelConstructionInfopanel(template, ...)
	if template == "DomeTeleporter" then
		return CallTunnelFunc(ChoOrig_OpenTunnelConstructionInfopanel, template, ...)
	end
	return ChoOrig_OpenTunnelConstructionInfopanel(template, ...)
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
	-- default it to max
	max_hex_distance_to_allow_build = 1000,
}

local ChoOrig_CreateConstructionGroup = CreateConstructionGroup
function DomeTeleporterConstructionController.Activate(...)
	-- replace func so it returns our template
	function CreateConstructionGroup(template, ...)
		if template == "Tunnel" then
			template = "DomeTeleporter"
		end
		return ChoOrig_CreateConstructionGroup(template, ...)
	end
	-- get obj
	local ret = {TunnelConstructionController_cls.Activate(...)}
	-- restore func
	CreateConstructionGroup = ChoOrig_CreateConstructionGroup
	-- and done
	return table.unpack(ret)
end
