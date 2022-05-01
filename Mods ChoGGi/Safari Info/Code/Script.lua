-- See LICENSE for terms

local table = table
local Msg = Msg

-- clear away text
local function ClearUnitInfo()

	-- clean up text
	local parent = Dialogs.HUD.ChoGGi_TempSafariInfo
	if parent then
		for i = #parent, 1, -1 do
			parent[i]:Close()
		end
	end
end

local mod_EnableMod
local mod_TextBackground
local mod_TextOpacity
local mod_TextStyle

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_TextBackground = CurrentModOptions:GetProperty("TextBackground")
	mod_TextOpacity = CurrentModOptions:GetProperty("TextOpacity")
	mod_TextStyle = CurrentModOptions:GetProperty("TextStyle")

	-- make sure we're in-game
	if not UICity then
		return
	end

	ClearUnitInfo()
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local style_lookup = {
	"EncyclopediaArticleTitle",
	"BugReportScreenshot",
	"CategoryTitle",
	"ConsoleLog",
	"DomeName",
	"GizmoText",
	"InfopanelResourceNoAccept",
	"ListItem1",
	"ModsUIItemStatusWarningBrawseConsole",
	"LandingPosNameAlt",
}

local function MarkUnits()
	if not mod_EnableMod then
		return
	end

	-- parent dialog storage
	local parent = Dialogs.HUD
	if not parent.ChoGGi_TempSafariInfo then
		parent.ChoGGi_TempSafariInfo = XWindow:new({
			Id = "ChoGGi_TempSafariInfo",
		}, parent)
	end
	parent = parent.ChoGGi_TempSafariInfo
	parent:SetTransparency(mod_TextOpacity)

--~ 	ex(parent)

	ClearUnitInfo()

	local text_style = style_lookup[mod_TextStyle]
	local text_background = mod_TextBackground and black or XText.Background

	-- get sights that give Satisfaction
	local objs = MapGet("map", "SafariSight", function(sight)
		if sight:IsActive() then
			return true
		end
	end)

	for i = 1, #objs do
		local obj = objs[i]
		local text_dlg = XText:new({
			TextStyle = text_style,
			Background = text_background,
			Dock = "box",
			HAlign = "left",
			VAlign = "top",
			Clip = false,
			HandleMouse = false,
		}, parent)

		local text = {
			T(obj:GetName()),
			"\n", T(12760,"Satisfaction"), ": ", obj:GetSightSatisfaction(),
--~ 			"\n", T(12895, "sight_visible_size"), ": ", obj:GetVisibleSize(),
		}

		text_dlg:SetText(table.concat(text, ""))

		text_dlg:AddDynamicPosModifier{
			id = "obj_info",
			target = obj,
		}

		text_dlg:SetVisible(true)
	end

end

local function RouteMsgs(func, msg, ...)
	Msg(msg)
	return func(...)
end

local ChoOrig_RCSafari_EnterCreateRouteMode = RCSafari.EnterCreateRouteMode
function RCSafari:EnterCreateRouteMode(...)
	return RouteMsgs(ChoOrig_RCSafari_EnterCreateRouteMode, "ChoGGi_RCSafari_EnterCreateRouteMode", self, ...)
end

local ChoOrig_DestroySafariRouteVisuals = DestroySafariRouteVisuals
function DestroySafariRouteVisuals(...)
	return RouteMsgs(ChoOrig_DestroySafariRouteVisuals, "ChoGGi_DestroySafariRouteVisuals", ...)
end

-- add info
OnMsg.ChoGGi_RCSafari_EnterCreateRouteMode = MarkUnits
-- remove info
OnMsg.ChoGGi_DestroySafariRouteVisuals = ClearUnitInfo
