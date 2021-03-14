-- See LICENSE for terms

local table_concat = table.concat
local table_iclear = table.iclear
local IsKindOf = IsKindOf
local IsValid = IsValid
local WaitMsg = WaitMsg
local CreateGameTimeThread = CreateGameTimeThread
local DeleteThread = DeleteThread
local GetMapSector = GetMapSector
local SetPathMarkersGameTime = ChoGGi.ComFuncs.SetPathMarkersGameTime
local Pathing_StopAndRemoveAll = ChoGGi.ComFuncs.Pathing_StopAndRemoveAll
local GetTarget = ChoGGi.ComFuncs.GetTarget

local threads = {}
local threads_c = 0

-- clear away lines/text
local function ClearUnitInfo()
	Pathing_StopAndRemoveAll()

	-- update text threads
	for i = 1, threads_c do
		DeleteThread(threads[i])
	end
	table_iclear(threads)
	threads_c = 0

	-- clean up text
	local parent = Dialogs.HUD.ChoGGi_TempUnitInfo
	if parent then
		for i = #parent, 1, -1 do
			parent[i]:Close()
		end
	end
end

local mod_EnableMod
local mod_EnableText
local mod_TextBackground
local mod_TextOpacity
local mod_TextStyle
local mod_DroneBatteryInfo
local mod_OnlyBatteryInfo
local mod_EnableLines
local mod_ShowNames
local options

-- fired when settings are changed/init
local function ModOptions()
	options = CurrentModOptions
	mod_EnableMod = options:GetProperty("EnableMod")
	mod_EnableText = options:GetProperty("EnableText")
	mod_TextBackground = options:GetProperty("TextBackground")
	mod_TextOpacity = options:GetProperty("TextOpacity")
	mod_TextStyle = options:GetProperty("TextStyle")
	mod_DroneBatteryInfo = options:GetProperty("DroneBatteryInfo")
	mod_OnlyBatteryInfo = options:GetProperty("OnlyBatteryInfo")
	mod_EnableLines = options:GetProperty("EnableLines")
	mod_ShowNames = options:GetProperty("ShowNames")

	-- make sure we're ingame
	if not UICity then
		return
	end

	-- this will remove any lines no matter what
	if options:GetProperty("ForceClearLines") then
		MapDelete("map", "ChoGGi_OPolyline")
	end

	ClearUnitInfo()
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

local function GetBatteryInfo(obj, space)
	if space then
		return T(" ") .. const.TagLookupTable.icon_Power .. obj:GetBatteryProgress()
	end
	return T(const.TagLookupTable.icon_Power) .. obj:GetBatteryProgress()
end

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

local function UpdateText(obj, text_dlg, orig_text, orig_target)
	if not obj then
		return
	end

	local command = obj:HasMember("Getui_command") and obj:Getui_command()
		or obj:HasMember("GetStateText") and obj:GetStateText() or obj.command

	local target = GetTarget(obj)
	-- same text abort update
	if command == orig_text and target == orig_target then
		return command, target, obj
	end

	local name = ""
	if mod_ShowNames then
		name = obj:GetDisplayName() .. " "
	end

	local text
	if target then
		local grid = ""
		if IsPoint(obj.target or obj.goto_target) then
			grid = GetMapSector(obj.target or obj.goto_target)
			if grid then
				grid = " " .. grid.display_name
			end
		end
		text = {name, T{command, obj}, target, grid}
	else
		text = {name, T{command, obj}}
	end

	if obj:IsKindOf("Drone") then
		if mod_OnlyBatteryInfo then
		-- replace text
			text = {GetBatteryInfo(obj)}
		elseif mod_DroneBatteryInfo then
		-- append text
			text[#text] = GetBatteryInfo(obj, true)
		end
	end

	text_dlg:SetText(table_concat(text, ""))

	return command, target, obj
end

local function AddTextInfo(obj, parent, text_style, text_background)
	local text_dlg = XText:new({
		TextStyle = text_style,
--~ 		Padding = padding_box,
--~ 		Margins = c == 2 and margin_box_dbl or margin_box,
		Background = text_background,
		Dock = "box",
		HAlign = "left",
		VAlign = "top",
		Clip = false,
		HandleMouse = false,
	}, parent)

	local orig_text, orig_target = UpdateText(obj, text_dlg)

	text_dlg:AddDynamicPosModifier{
		id = "obj_info",
		target = obj,
	}
	text_dlg:SetVisible(true)

	-- update text
	while IsValid(obj) do
		WaitMsg("OnRender")
		orig_text, orig_target, obj = UpdateText(obj, text_dlg, orig_text, orig_target)
	end
end

local function ValidObj(obj)
--~ 	return mod_EnableText and obj and obj:HasMember("Getui_command") and obj:IsKindOf("Unit")
	return mod_EnableText and obj and obj:IsKindOf("Unit")
end

local function MarkUnits(obj)
--~ ex(obj)
	if not mod_EnableMod then
		return
	end

	-- parent dialog storage
	local parent = Dialogs.HUD
	if not parent.ChoGGi_TempUnitInfo then
		parent.ChoGGi_TempUnitInfo = XWindow:new({
			Id = "ChoGGi_TempUnitInfo",
		}, parent)
	end
	parent = parent.ChoGGi_TempUnitInfo
	parent:SetTransparency(mod_TextOpacity)

	ClearUnitInfo()

	local text_style = style_lookup[mod_TextStyle]
	local text_background = mod_TextBackground and black or XText.Background

	if IsKindOf(obj, "MultiSelectionWrapper") then
		local objs = obj.objects
		for i = 1, #objs do
			local obj2 = objs[i]
			if mod_EnableLines then
				SetPathMarkersGameTime(obj2, nil, delay)
			end
			if ValidObj(obj2) then
				threads_c = threads_c + 1
				threads[threads_c] = CreateGameTimeThread(AddTextInfo, obj2, parent, text_style, text_background)
			end
		end

	else
		if mod_EnableLines then
			SetPathMarkersGameTime(obj)
		end
		if ValidObj(obj) then
			threads_c = threads_c + 1
			threads[threads_c] = CreateGameTimeThread(AddTextInfo, obj, parent, text_style, text_background)
		end
	end
end

-- add lines
OnMsg.SelectedObjChange = MarkUnits
-- remove lines when no selection
OnMsg.SelectionRemoved = ClearUnitInfo
-- make sure to remove lines on save
OnMsg.SaveGame = ClearUnitInfo
