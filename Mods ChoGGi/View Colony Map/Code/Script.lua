-- See LICENSE for terms

local table_insert = table.insert
local TableConcat = ChoGGi.ComFuncs.TableConcat
local Translate = ChoGGi.ComFuncs.Translate
local ValidateImage = ChoGGi.ComFuncs.ValidateImage
local RetMapSettings = ChoGGi.ComFuncs.RetMapSettings
local RetMapBreakthroughs = ChoGGi.ComFuncs.RetMapBreakthroughs

local image_str = Mods.ChoGGi_MapImagesPack.env.CurrentModPath .. "Maps/"

-- make sure it stays closed
local skip_showing_image

local show_image_dlg
local extra_info_dlg

-- override this func to create/update image when site changes
local orig_FillRandomMapProps = FillRandomMapProps
function FillRandomMapProps(gen, params, ...)

	-- gen is a table when the map is loading, so we can skip it
	if not gen and not skip_showing_image then
		local map
		map, gen, params = RetMapSettings(true, params, ...)

		-- check if we already created image viewer, and make one if not
		if not show_image_dlg then
			show_image_dlg = ChoGGi_VCM_MapImageDlg:new({}, terminal.desktop, {})
		end
		-- pretty little image
		show_image_dlg.idImage:SetImage(image_str .. map .. ".png")
		show_image_dlg.idCaption:SetText(map)
		-- update text info
		if extra_info_dlg then
			extra_info_dlg:UpdateInfo(gen)
		end

		return map
	end

	return orig_FillRandomMapProps(gen, params, ...)
end

-- kill off image dialogs
function OnMsg.ChangeMapDone()
-- keep dialog opened after
--~ 	do return end
	local term = terminal.desktop
	for i = #term, 1, -1 do
		local dlg = term[i]
		if dlg:IsKindOf("ChoGGi_VCM_MapImageDlg")
				or dlg:IsKindOf("ChoGGi_VCM_ExtraInfoDlg") then
			dlg:Close()
		end
	end
end

local function ResetFunc()
	-- reset func once we know it's a new game (someone reported image showing up after landing)
	if orig_FillRandomMapProps then
		FillRandomMapProps = orig_FillRandomMapProps
		orig_FillRandomMapProps = nil
	end
	-- alright bugger...
	skip_showing_image = true
end

OnMsg.CityStart = ResetFunc
OnMsg.LoadGame = ResetFunc

local function GamepadFocus()
	-- stupid gamepad focus
	if GetUIStyleGamepad() then
		WaitMsg("OnRender")
		if Dialogs.PGMainMenu then
			pcall(function()
				Dialogs.PGMainMenu.idContent[1][1][1].idToolBar:SetFocus()
			end)
		end
	end
end

-- a dialog that shows an image
--~ local GetParentOfKind = ChoGGi.ComFuncs.GetParentOfKind
--~ local function GetRootDialog(dlg)
--~ 	return dlg.parent_dialog or GetParentOfKind(dlg, "ChoGGi_VCM_MapImageDlg")
--~ end

DefineClass.ChoGGi_VCM_MapImageDlg = {
	__parents = {"ChoGGi_XWindow"},
	dialog_width = 525.0,
	dialog_height = 525.0,

	-- if random tech rule active
	random_warning = false,
	warning_str = false,
}

function ChoGGi_VCM_MapImageDlg:Init(parent, context)
	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	self.idTopArea = g_Classes.ChoGGi_XDialogSection:new({
		Id = "idTopArea",
	}, self.idDialog)
	self.idImage = XFrame:new({
		Id = "idImage",
	}, self.idTopArea)

	self.idBottomArea = g_Classes.ChoGGi_XDialogSection:new({
		Id = "idBottomArea",
		Dock = "bottom",
	}, self.idDialog)

	self.idShowExtra = g_Classes.ChoGGi_XCheckButton:new({
		Id = "idShowExtra",
		Text = T(11451, "Breakthrough"),
		RolloverText = T(302535920011333, "Show breakthroughs for this location."),
		OnChange = self.idShowExtra_OnChange,
		Margins = box(20, 4, 2, 0),
		Dock = "left",
	}, self.idBottomArea)
	-- add hint if random rule active
	local tech_variety = IsGameRuleActive("TechVariety")
		and " <color yellow>" .. T(607602869305, "Tech Variety") .. "</color>"
		or ""
	local chaos_theory = IsGameRuleActive("ChaosTheory")
		and " <color yellow>" .. T(621834127153, "Chaos Theory") .. "</color>"
		or ""

	if tech_variety ~= "" or chaos_theory ~= "" then
		self.warning_str = T(302535920011334, [[Random tech game rule(s) <color red>active!</color>
Breakthroughs will be random as well.
]]) .. tech_variety .. chaos_theory
		self.idShowExtra.RolloverText = self.idShowExtra.RolloverText
			.. "\n\n\n" .. self.warning_str
		self.random_warning = true
	end

	-- we need to wait a sec for the map info to load or y will be 0
	CreateRealTimeThread(function()
		WaitMsg("OnRender")
		self:PostInit(nil, self:SetDefaultPos())

		GamepadFocus()
	end)
end

function ChoGGi_VCM_MapImageDlg:idShowExtra_OnChange(check)
	if check then
		if not extra_info_dlg then
			extra_info_dlg = ChoGGi_VCM_ExtraInfoDlg:new({}, terminal.desktop, {})
		end
	else
		if extra_info_dlg then
			extra_info_dlg:Close()
		end
	end
end

function ChoGGi_VCM_MapImageDlg:SetDefaultPos()
	local size
	if Dialogs.PGMainMenu then
		-- wrapped in a pcall, so if we fail (new version) then it'll just use my default
		pcall(function()
			size = Dialogs.PGMainMenu.idContent.PGMission[1][1].idContent.box
				:size()
			size = size:SetY(size:y()/4)
		end)
	end

	-- default dialog position if the above fails
	return size or point(100, 100)
end

function ChoGGi_VCM_MapImageDlg:Done()
	-- if someone closes the dialog this will open it back up
	show_image_dlg = false
	if extra_info_dlg then
		extra_info_dlg:Close()
	end
end

-- needed?
local function GetRootDialog_Extra(dlg)
	return GetParentOfKind(dlg, "ChoGGi_VCM_ExtraInfoDlg")
end

DefineClass.ChoGGi_VCM_ExtraInfoDlg = {
	__parents = {"ChoGGi_XWindow"},
	dialog_width = 400.0,
	dialog_height = 525.0,

	missing_desc = Translate(302535920011335, [[You need to be in-game to display this hint.
Click to open Paradox Breakthroughs Wiki page.]]),

	translated_tech = false,
	omega_msg = false,
	omega_msg_count = false,
	planet_msg = false,

	onclick_count = false,
	onclick_desc = false,
	onclick_names = false,
}

function ChoGGi_VCM_ExtraInfoDlg:Init(parent, context)
	-- By the Power of Grayskull!
	self:AddElements(parent, context)
	-- text box with obj info in it
	self:AddScrollText()

	-- make it clearer when randoms are go
	local title_text = T(11451, "Breakthrough")
	if show_image_dlg.random_warning then
		title_text = title_text .. " (" .. T(6779, "Warning") .. "!)"
		self.idText:SetText(show_image_dlg.warning_str)
	else
		self.idText:SetText(T(302535920011337, "Select location to update text"))
	end

	self.idCaption:SetText(title_text)

	-- rollover hints
	self.idText.OnHyperLink = self.idTextOnHyperLink
	self.idText.OnHyperLinkRollover = self.idTextOnHyperLinkRollover
	self.onclick_count = 0
	self.onclick_desc = {}
	self.onclick_names = {}

	-- build a table of translated tech names
	self.translated_tech = {}
	local TechDef = TechDef
	for _, tech in pairs(TechDef) do
		local icon = ""
		if ValidateImage(tech.icon) and not tech.icon:find(" ") then
			icon = "\n\n<image " .. tech.icon .. " 1500>"
		end
		local name = Translate(tech.display_name)
		local desc = Translate(T{tech.description, tech})
		if #desc > 16 and desc:sub(-16) == " *bad string id?" then
			desc = self.missing_desc
		end

		self.translated_tech[name] = self:HyperLink(desc .. "\n\n" .. icon, name)
			.. name .. "</h></color>"
	end

	self.omega_msg_count = const.BreakThroughTechsPerGame + 2
	self.omega_msg = "\n\n<color 200 200 256>" .. Translate(5182--[[Omega Telescope]]) .. " "
		.. Translate(437247068170--[[LIST]]) .. " (" .. Translate(302535920011336, "maybe") .. "):</color>"
	self.planet_msg = "\n\n<color 200 200 256>" .. Translate(11234--[[Planetary Anomaly]]) .. ":</color>"

	CreateRealTimeThread(function()
		-- place right of map
		local pos = show_image_dlg:GetPos() + point(show_image_dlg:GetWidth() + 10, 0)
		self:PostInit(nil, pos)

		GamepadFocus()
	end)
end

function ChoGGi_VCM_ExtraInfoDlg:Done()
	extra_info_dlg = false
	if show_image_dlg then
		show_image_dlg.idShowExtra:SetCheck(false)
	end
end

-- clicked
--~ (link, argument, hyperlink_box, pos, button)
function ChoGGi_VCM_ExtraInfoDlg:idTextOnHyperLink(link)
	self = GetRootDialog_Extra(self)

	local desc = self.onclick_desc[tonumber(link)]
	if desc:find(self.missing_desc, 1, true) then
		OpenUrl("https://survivingmars.paradoxwikis.com/Breakthrough")
	end

end

-- (link, hyperlink_box, pos)
function ChoGGi_VCM_ExtraInfoDlg:idTextOnHyperLinkRollover(link)
	self = GetRootDialog_Extra(self)

	if not link then
		-- close opened tooltip
		if RolloverWin then
			XDestroyRolloverWindow()
		end
		return
	end

	link = tonumber(link)

	XCreateRolloverWindow(self.idDialog, RolloverGamepad, true, {
		RolloverTitle = self.onclick_names[link],
		RolloverText = self.onclick_desc[link],
	})
end

-- create
function ChoGGi_VCM_ExtraInfoDlg:HyperLink(desc, name)
	local c = self.onclick_count
	c = c + 1
	self.onclick_count = c
	self.onclick_desc[c] = desc
	self.onclick_names[c] = name

	return "<color 255 255 255><h " .. c .. " 230 195 50>", c
end

function ChoGGi_VCM_ExtraInfoDlg:UpdateInfo(gen)
	if show_image_dlg.random_warning then
		self.idText:SetText(show_image_dlg.warning_str)
		return
	end

	local display_list = RetMapBreakthroughs(gen, true)
--~ 	ex{display_list, gen}

	for i = 1, #display_list do
		display_list[i] = self.translated_tech[display_list[i]]
	end

	-- last four are PAs (g_Consts.PlanetaryBreakthroughCount)
	table_insert(display_list, 10, self.planet_msg)

	table_insert(display_list, self.omega_msg_count, self.omega_msg)
	self.idText:SetText(TableConcat(display_list, "\n"))
end
