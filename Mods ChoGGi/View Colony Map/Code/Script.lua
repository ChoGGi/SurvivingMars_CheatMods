-- See LICENSE for terms

local mod_EnableChallenges
local mod_AlwaysBreakthroughs
local mod_BreakthroughCount

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableChallenges = CurrentModOptions:GetProperty("EnableChallenges")
	mod_AlwaysBreakthroughs = CurrentModOptions:GetProperty("AlwaysBreakthroughs")
	mod_BreakthroughCount = CurrentModOptions:GetProperty("BreakthroughCount")
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local table = table
local Translate = ChoGGi.ComFuncs.Translate
local ValidateImage = ChoGGi.ComFuncs.ValidateImage
local RetMapSettings = ChoGGi.ComFuncs.RetMapSettings
local IsValidXWin = ChoGGi.ComFuncs.IsValidXWin

local image_str = Mods.ChoGGi_MapImagesPack.env.CurrentModPath .. "Maps/"

-- make sure it stays closed
local skip_showing_image

local show_image_dlg
local extra_info_dlg

local underground_maps = {
	"BlankUnderground_01",
	"BlankUnderground_02",
	"BlankUnderground_03",
	"BlankUnderground_04",
}

local function ShowDialogs(map, gen)
	-- check if we already created image viewer, and make one if not
	if not IsValidXWin(show_image_dlg) then
		show_image_dlg = ChoGGi_VCM_MapImageDlg:new({}, terminal.desktop, {})
	end
	-- pretty little image
	show_image_dlg.idImage:SetImage(image_str .. map .. ".png")

	if show_image_dlg.idImagePicard then
		local underground = table.rand(underground_maps, gen.Seed)
		show_image_dlg.idImagePicard:SetImage(image_str .. underground .. ".jpg")
		show_image_dlg.idCaption:SetText(underground)
	end

	--
	if show_image_dlg.idImagePicard
		and show_image_dlg.idTogglePicard.IconRow == 1
	then
		show_image_dlg.idCaption:SetText(map)
	end

	-- update text info
	if gen and extra_info_dlg then
		extra_info_dlg:UpdateInfo(gen)
	end
end

-- create/update image when landing spot changes
local ChoOrig_GetOverlayValues = GetOverlayValues
function GetOverlayValues(lat, long, overlay_grids, params, ...)
	ChoOrig_GetOverlayValues(lat, long, overlay_grids, params, ...)

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
		if not IsValidXWin(extra_info_dlg) and mod_AlwaysBreakthroughs then
			extra_info_dlg = ChoGGi_VCM_ExtraInfoDlg:new({}, terminal.desktop, {})
			extra_info_dlg:SetSidePos(true)
		end
		if extra_info_dlg then
			extra_info_dlg:UpdateInfo(gen)
		end

	end
end

-- kill off image dialogs
function OnMsg.ChangeMapDone()
	-- keep dialog opened after
	if ChoGGi.testing then
		return
	end

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
	dialog_width = 600.0,
	dialog_height = 600.0,

	-- If random tech rule active
	random_warning = false,
	warning_str = false,
	-- add another image if so
	is_picard = false,
}

function ChoGGi_VCM_MapImageDlg:Init(parent, context)
	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	self.is_picard = g_AvailableDlc.picard

	self.idTopArea = g_Classes.ChoGGi_XDialogSection:new({
		Id = "idTopArea",
	}, self.idDialog)

	self.idImage = XFrame:new({
		Id = "idImage",
	}, self.idTopArea)

	if self.is_picard then
		self.idImagePicard = XFrame:new({
			Id = "idImagePicard",
		}, self.idTopArea)
		self.idImagePicard:SetVisible(false)
	end

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
		and " <yellow>" .. T(607602869305--[[Tech Variety]]) .. "</yellow>"
		or ""
	local chaos_theory = IsGameRuleActive("ChaosTheory")
		and " <yellow>" .. T(621834127153--[[Chaos Theory]]) .. "</yellow>"
		or ""

	if tech_variety ~= "" or chaos_theory ~= "" then
		self.warning_str = T(302535920011334, [[Random tech game rule(s) <color ChoGGi_red>active!</color>
Breakthroughs will be random as well.
]]) .. tech_variety .. chaos_theory
		self.idShowExtra.RolloverText = self.idShowExtra.RolloverText
			.. "\n\n\n" .. self.warning_str
		self.random_warning = true
	end

	-- add checkbox to toggle image
	if self.is_picard then
		self.idTogglePicard = g_Classes.ChoGGi_XCheckButton:new({
			Id = "idTogglePicard",
			Text = T(0000, "Underground"),
--~ 			RolloverText = T(302535920011333, "Show breakthroughs for this location."),
			OnChange = self.idTogglePicard_OnChange,
			Margins = box(20, 4, 2, 0),
			Dock = "left",
		}, self.idBottomArea)
		self.idTogglePicard:SetCheckBox(false)
	end


	-- we need to wait a sec for the map info to load or y will be 0
	CreateRealTimeThread(function()
		WaitMsg("OnRender")
		self:PostInit(nil, self:SetDefaultPos())

		if mod_AlwaysBreakthroughs then
			if not IsValidXWin(extra_info_dlg) then
				extra_info_dlg = ChoGGi_VCM_ExtraInfoDlg:new({}, terminal.desktop, {})
				extra_info_dlg:SetSidePos()
			end
			self.idShowExtra:SetCheck(true)
		end

		GamepadFocus()
	end)
end

function ChoGGi_VCM_MapImageDlg:idShowExtra_OnChange(check)
	if check then
		if not IsValidXWin(extra_info_dlg) then
			extra_info_dlg = ChoGGi_VCM_ExtraInfoDlg:new({}, terminal.desktop, {})
			extra_info_dlg:SetSidePos()
		end
	else
		if extra_info_dlg then
			extra_info_dlg:Close()
		end
	end
end

function ChoGGi_VCM_MapImageDlg:idTogglePicard_OnChange(check)
	if check then
		self.parent_dialog.idImage:SetVisible(false)
		self.parent_dialog.idImagePicard:SetVisible(true)
	else
		self.parent_dialog.idImage:SetVisible(true)
		self.parent_dialog.idImagePicard:SetVisible(false)
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

local function GetRootDialog_Extra(dlg)
	return dlg.parent_dialog or GetParentOfKind(dlg, "ChoGGi_VCM_ExtraInfoDlg")
end

DefineClass.ChoGGi_VCM_ExtraInfoDlg = {
	__parents = {"ChoGGi_XWindow"},
	dialog_width = 400.0,
	dialog_height = 600.0,

	translated_tech = false,
	planet_title_count = 0,
	planet_title = false,
	breakthrough_title = false,
	undergound_title = false,

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

	self.planet_title_count = Consts.PlanetaryBreakthroughCount + 1

	self.breakthrough_title = "\n\n<color 200 200 256>" .. Translate(9, "Anomaly")
		.. ":</color>"

	self.planet_title = "<color 200 200 256>" .. Translate(11234, "Planetary Anomaly") .. ":</color>"

	self:SetSidePos()
end

function ChoGGi_VCM_ExtraInfoDlg:SetSidePos(init_pause)
	CreateRealTimeThread(function()
		-- place right of map
		if init_pause then
			Sleep(50)
		end
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

	if false then
--~ 	if ChoGGi.testing then
		local state = RandState(gen.Seed)
		local rand = function(min, max)
			return state:GetStable(min, max)
		end

--~ 		ex(rand)
--~ 		Seed = 977816133 < 0nw0
--~ 		randstate == 2074321580 (CaveOfWonders/AncientArtifact)

		local shuffled_wonders = table.copy(const.BuriedWonders)
		local num_wonders = #shuffled_wonders
		table.shuffle(shuffled_wonders, rand)
		local spawned_wonders = {}
		for index, marker in ipairs({1,1}) do
			local wrapped_index = 1 + (index - 1) % num_wonders
			print(wonder_class)
		end
	end
	-- end testing if

	if show_image_dlg.random_warning then
		self.idText:SetText(show_image_dlg.warning_str)
		return
	end

	local display_list = ChoGGi.ComFuncs.RetMapBreakthroughs(gen, mod_BreakthroughCount)
--~ 	ex{display_list, gen}

	-- tech descriptions
	for i = 1, #display_list do
		display_list[i] = self.translated_tech[display_list[i]]
	end

	-- add bt text after the first four (POIs)
	table.insert(display_list, self.planet_title_count, self.breakthrough_title)
	-- first four are POI breaks
	table.insert(display_list, 1, self.planet_title)

	self.idText:SetText(table.concat(display_list, "\n"))
end
