-- See LICENSE for terms

local mod_EnableChallenges

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableChallenges = CurrentModOptions:GetProperty("EnableChallenges")
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

local table_insert = table.insert
local Translate = ChoGGi.ComFuncs.Translate
local ValidateImage = ChoGGi.ComFuncs.ValidateImage
local RetMapSettings = ChoGGi.ComFuncs.RetMapSettings
local RetMapBreakthroughs = ChoGGi.ComFuncs.RetMapBreakthroughs

local image_str = Mods.ChoGGi_MapImagesPack.env.CurrentModPath .. "Maps/"

-- make sure it stays closed
local skip_showing_image

local show_image_dlg
local extra_info_dlg

local function ShowDialogs(map, gen)
	-- check if we already created image viewer, and make one if not
	if not show_image_dlg then
		show_image_dlg = ChoGGi_VCM_MapImageDlg:new({}, terminal.desktop, {})
	end
	-- pretty little image
	show_image_dlg.idImage:SetImage(image_str .. map .. ".png")
	show_image_dlg.idCaption:SetText(map)
	-- update text info
	if gen and extra_info_dlg then
		extra_info_dlg:UpdateInfo(gen)
	end
end

-- create/update image when landing spot changes
local orig_GetOverlayValues = GetOverlayValues
function GetOverlayValues(lat, long, overlay_grids, params, ...)
	orig_GetOverlayValues(lat, long, overlay_grids, params, ...)

	local PGMainMenu = Dialogs.PGMainMenu
	local chall
	if PGMainMenu then
		chall = PGMainMenu.idContent.PGChallenge
	end
	-- check if we're in chall menu or regular to show
	if not skip_showing_image
		and (not chall or chall and mod_EnableChallenges)
	then
		local map, gen
		map, params, gen = RetMapSettings(true, params)
		ShowDialogs(map, gen)
	end
end

-- kill off image dialogs
function OnMsg.ChangeMapDone()
-- keep dialog opened after
--~ 	do return end
	local dlgs = terminal.desktop
	for i = #dlgs, 1, -1 do
		local dlg = dlgs[i]
		if dlg:IsKindOf("ChoGGi_VCM_MapImageDlg")
			or dlg:IsKindOf("ChoGGi_VCM_ExtraInfoDlg")
		then
			dlg:Close()
		end
	end
end

local function ResetFunc()
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

	-- If random tech rule active
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
		and " <yellow>" .. T(607602869305, "Tech Variety") .. "</yellow>"
		or ""
	local chaos_theory = IsGameRuleActive("ChaosTheory")
		and " <yellow>" .. T(621834127153, "Chaos Theory") .. "</yellow>"
		or ""

	if tech_variety ~= "" or chaos_theory ~= "" then
		self.warning_str = T(302535920011334, [[Random tech game rule(s) <color ChoGGi_red>active!</color>
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

	local PGMainMenu = Dialogs.PGMainMenu
	if PGMainMenu then
		-- wrapped in a pcall, so if we fail (new version) then it'll just use my default
		pcall(function()
			local c = PGMainMenu.idContent
			size = c[c.PGMission and "PGMission" or "PGChallenge"][1][1]
				.idContent.box:size()
			size = size:SetY(size:y()/4)
		end)
	end

	-- default dialog position if the above fails
	return size or point(100, 100)
end

function ChoGGi_VCM_MapImageDlg:Done()
	-- If someone closes the dialog this will open it back up
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

	translated_tech = false,
	omega_msg = false,
	show_omegas = false,
	planet_msg_count = 0,
	planet_msg = false,
	breakthrough_msg = false,

	onclick_count = false,
	onclick_desc = false,
	onclick_names = false,
}

function ChoGGi_VCM_ExtraInfoDlg:Init(parent, context)

	-- remove once we get them sorted
	self.show_omegas = false

	if self.show_omegas then
		self.dialog_height = 650.0
		self.omega_msg = "\n\n<color 200 200 256>"
			.. Translate(5182, "Omega Telescope") .. ":</color>"
	end

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
	self.idText.OnHyperLinkRollover = self.idTextOnHyperLinkRollover
	self.onclick_count = 0
	self.onclick_desc = {}
	self.onclick_names = {}

	-- build a table of translated tech names
	self.translated_tech = {}
	local TechDef = TechDef
	for _, tech in pairs(TechDef) do
		if tech.group == "Breakthroughs" then
			local icon = ""
			if ValidateImage(tech.icon) and not tech.icon:find(" ") then
				icon = "\n\n<image " .. tech.icon .. " 1500>"
			end
			local name = Translate(tech.display_name)
			local desc = Translate(T{tech.description, tech})

			self.translated_tech[name] = self:HyperLink(desc .. "\n\n" .. icon, name)
				.. name .. "</h></color>"
		end
	end

	self.planet_msg_count = Consts.PlanetaryBreakthroughCount + 1

	self.breakthrough_msg = "\n\n<color 200 200 256>" .. Translate(title_text)
		.. ":</color>"
	self.planet_msg = "<color 200 200 256>"
		.. Translate(11234, "Planetary Anomaly") .. ":</color>"

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

-- create link
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

	local display_list
	if self.show_omegas then
		display_list = RetMapBreakthroughs(gen, true)
	else
		display_list = RetMapBreakthroughs(gen)
	end

--~ 	ex{display_list, gen}

	-- tech descriptions
	for i = 1, #display_list do
		display_list[i] = self.translated_tech[display_list[i]]
	end

	-- add bt text after the first four (POIs)
	table_insert(display_list, self.planet_msg_count, self.breakthrough_msg)
	-- first four are POI breaks
	table_insert(display_list, 1, self.planet_msg)

	if self.show_omegas then
		-- 3 from the end
		table_insert(display_list, #display_list - 2, self.omega_msg)
	end

	self.idText:SetText(table.concat(display_list, "\n"))
end
