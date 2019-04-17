-- See LICENSE for terms

if not Mods.ChoGGi_MapImagesPack then
	ModLog("View Colony Map needs Map Images Pack installed!")
	return
end

local GetRandomMapGenerator = GetRandomMapGenerator
local CreateRand = CreateRand
local StableShuffle = StableShuffle
local table_insert = table.insert
local table_remove = table.remove
local table_imap = table.imap
local table_copy = table.copy
local table_find = table.find
local table_iclear = table.iclear

local TableConcat = ChoGGi.ComFuncs.TableConcat
local Translate = ChoGGi.ComFuncs.Translate
local ValidateImage = ChoGGi.ComFuncs.ValidateImage

local image_str = Mods.ChoGGi_MapImagesPack.env.CurrentModPath .. "Maps/"

-- make sure it stays closed
local skip_showing_image

local show_image_dlg
local extra_info_dlg

-- override this func to create/update image when site changes
local orig_FillRandomMapProps = FillRandomMapProps
local function FillRandomMapProps_local(gen, params, ...)

	-- gen is a table when the map is loading, so we can skip it
	if not gen and not skip_showing_image then
		params = params or g_CurrentMapParams
		gen = GetRandomMapGenerator() or {}
		-- we have to call it separately so we can use gen
		local map = orig_FillRandomMapProps(gen, params, ...)

		-- check if we already created image viewer, and make one if not
		if not show_image_dlg then
			show_image_dlg = ChoGGi_VCM_MapImageDlg:new({}, terminal.desktop,{})
		end
		-- pretty little image
		show_image_dlg.idImage:SetImage(image_str .. map .. ".png")
		show_image_dlg.idCaption:SetText(map)
		-- update text info
		if extra_info_dlg then
			extra_info_dlg:UpdateInfo(map, gen, params)
		end

		return map
	end

	return orig_FillRandomMapProps(gen, params, ...)
end
FillRandomMapProps = FillRandomMapProps_local

-- kill off image dialogs
function OnMsg.ChangeMapDone()
	local term = terminal.desktop
	for i = #term, 1, -1 do
		if term[i]:IsKindOfClasses("ChoGGi_VCM_MapImageDlg","ChoGGi_VCM_ExtraInfoDlg") then
			term[i]:Close()
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

-- a dialog that shows an image
local GetParentOfKind = ChoGGi.ComFuncs.GetParentOfKind
local function GetRootDialog(dlg)
	return GetParentOfKind(dlg,"ChoGGi_VCM_MapImageDlg")
end

DefineClass.ChoGGi_VCM_MapImageDlg = {
	__parents = {"ChoGGi_Window"},
	dialog_width = 500.0,
	dialog_height = 500.0,
}

function ChoGGi_VCM_MapImageDlg:Init(parent, context)
	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	self.idTopArea = g_Classes.ChoGGi_DialogSection:new({
		Id = "idTopArea",
	}, self.idDialog)
	self.idImage = XFrame:new({
		Id = "idImage",
	}, self.idTopArea)

	self.idBottomArea = g_Classes.ChoGGi_DialogSection:new({
		Id = "idBottomArea",
		Dock = "bottom",
	}, self.idDialog)

	self.idShowExtra = g_Classes.ChoGGi_CheckButton:new({
		Id = "idShowExtra",
		Text = Translate(11451--[[Breakthrough--]]),
		RolloverText = "Show breakthroughs for this location.",
		OnChange = self.idShowExtraOnChange,
		Margins = box(20,4,2,0),
	}, self.idBottomArea)
	-- add hint if random rule active
	local tech_variety = IsGameRuleActive("TechVariety")
		and " <color green>" .. Translate(607602869305--[[Tech Variety--]]) .. "</color>" or ""
	local chaos_theory = IsGameRuleActive("ChaosTheory")
		and " <color green>" .. Translate(621834127153--[[Chaos Theory--]]) .. "</color>" or ""
	if tech_variety ~= "" or chaos_theory ~= "" then
		self.idShowExtra.RolloverText = Translate(self.idShowExtra.RolloverText .. [[


Random tech game rule(s) <color red>active!</color>
Breakthroughs will be random as well.
]] .. tech_variety .. chaos_theory)
	end

	-- we need to wait a sec for the map info to load or y will be 0
	CreateRealTimeThread(function()
		WaitMsg("OnRender")

		local x,y = self:SetDefaultPos()
		self:PostInit(nil,point(x,y))
	end)
end

function ChoGGi_VCM_MapImageDlg:idShowExtraOnChange(check)
	if check then
		if not extra_info_dlg then
			extra_info_dlg = ChoGGi_VCM_ExtraInfoDlg:new({}, terminal.desktop,{})
		end
	else
		if extra_info_dlg then
			extra_info_dlg:Close()
		end
	end
end

function ChoGGi_VCM_MapImageDlg:SetDefaultPos()
	-- default dialog position if we can't find the ui stuff (new version or whatnot)
	local x,y = 75,150

	local PGMainMenu = Dialogs.PGMainMenu
	if PGMainMenu then
		-- wrapped in a pcall, so if we fail then it'll just use my default
		pcall(function()
			local dlg = PGMainMenu.idContent.PGMission[1][1].idContent.box
			x = dlg:sizex()
			y = dlg:sizey() / 2
		end)
	end
	return x,y
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
	return GetParentOfKind(dlg,"ChoGGi_VCM_ExtraInfoDlg")
end
local hyperlink_end = "</h></color>"

DefineClass.ChoGGi_VCM_ExtraInfoDlg = {
	__parents = {"ChoGGi_Window"},
	dialog_width = 400.0,
	dialog_height = 500.0,

	missing_desc = [[You need to be in-game to display this hint.
Click to open Paradox Breakthroughs Wikipage.]],

	display_list = false,
	omega_order_maybe = false,
	translated_tech = false,
	omega_msg = false,

	onclick_count = false,
	onclick_desc = false,
	onclick_names = false,

	orig_break_list = false,
	title_text = false,
}

function ChoGGi_VCM_ExtraInfoDlg:Init(parent, context)
	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	self.title_text = Translate(11451--[[Breakthrough--]])
	self.idCaption:SetText(self.title_text)

	-- text box with obj info in it
	self:AddScrollText()

	-- rollover hints
	self.idText.OnHyperLink = self.idTextOnHyperLink
	self.idText.OnHyperLinkRollover = self.idTextOnHyperLinkRollover
	self.onclick_count = 0
	self.onclick_desc = {}
	self.onclick_names = {}

	self.display_list = {}
	self.omega_order_maybe = {}

	self.orig_break_list = table_imap(Presets.TechPreset.Breakthroughs, "id")

	-- build a table of translated tech names
	self.translated_tech = {}
	local TechDef = TechDef
	for tech_id,tech in pairs(TechDef) do
		local icon = ""
		if ValidateImage(tech.icon) and not tech.icon:find(" ") then
			icon = "\n\n<image " .. tech.icon .. " 1500>"
		end
		local name = Translate(tech.display_name)
		local desc = Translate(T{tech.description,tech})
		if #desc > 16 and desc:sub(-16) == " *bad string id?" then
			desc = self.missing_desc
		end

		self.translated_tech[tech_id] = self:HyperLink(desc .. "\n\n" .. icon,name)
			.. name .. hyperlink_end
	end

	self.omega_msg = "\n\n" .. Translate(5182--[[Omega Telescope--]]) .. " " .. Translate(437247068170--[[LIST--]]) .. " (maybe):\n"

	self:PostInit()
end

function ChoGGi_VCM_ExtraInfoDlg:Done()
	extra_info_dlg = false
	if show_image_dlg then
		show_image_dlg.idShowExtra:SetCheck(false)
	end
end

-- clicked
function ChoGGi_VCM_ExtraInfoDlg:idTextOnHyperLink(link, argument, hyperlink_box, pos, button)
	self = GetRootDialog_Extra(self)

	local desc = self.onclick_desc[tonumber(link)]
	if desc:find(self.missing_desc,1,true) then
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
function ChoGGi_VCM_ExtraInfoDlg:HyperLink(desc,name)
	local c = self.onclick_count
	c = c + 1
	self.onclick_count = c
	self.onclick_desc[c] = desc
	self.onclick_names[c] = name

	return "<color 255 255 255><h " .. c .. " 230 195 50>",c
end

--~ local testing = ChoGGi.testing

local breakthrough_count = const.BreakThroughTechsPerGame
function ChoGGi_VCM_ExtraInfoDlg:UpdateInfo(map, gen, params)
	self.idCaption:SetText(self.title_text .. ": " .. map)

	-- build the list once to get our anomaly breakthroughs
	local break_order = table_copy(self.orig_break_list)
	local omega_order = table_copy(self.orig_break_list)

	StableShuffle(break_order, CreateRand(true, gen.Seed, "ShuffleBreakThroughTech"), 100)
	StableShuffle(omega_order, CreateRand(true, gen.Seed, "OmegaTelescope"), 100)

	while #break_order > breakthrough_count do
		table_remove(break_order)
	end

	table_iclear(self.display_list)

	-- omega order
	for i = 1, #break_order do
		local id = break_order[i]
		local idx = table_find(omega_order,id)
		if idx then
			table_remove(omega_order,idx)
		end
		-- translate tech
		self.display_list[i] = self.translated_tech[id]
	end
	local c = #self.display_list

	self.omega_order_maybe[3] = table_remove(omega_order)
	self.omega_order_maybe[2] = table_remove(omega_order)
	self.omega_order_maybe[1] = table_remove(omega_order)

	-- and translation names for omega
	for i = 1, 3 do
		c = c + 1
		self.display_list[c] = self.translated_tech[self.omega_order_maybe[i]]
	end

--~ 	if testing then
--~ 		ex{self.display_list,self.omega_order_maybe}
--~ 	end

	table_insert(self.display_list,breakthrough_count+1,self.omega_msg)
	self.idText:SetText(TableConcat(self.display_list,"\n"))
end
