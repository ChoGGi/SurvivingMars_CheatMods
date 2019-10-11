-- See LICENSE for terms

local options
local mod_ShowPolymers
local mod_ShowMetals
local mod_TextOpacity
local mod_TextBackground
local mod_TextStyle

-- fired when settings are changed/init
local function ModOptions()
	mod_ShowPolymers = options.ShowPolymers
	mod_ShowMetals = options.ShowMetals
	mod_TextOpacity = options.TextOpacity
	mod_TextBackground = options.TextBackground
	mod_TextStyle = options.TextStyle
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

local pairs, type = pairs, type
local table_iclear = table.iclear
local table_concat = table.concat
local IsValid = IsValid
local T = T
local black = black

-- try to centre the text a bit more
local padding_box = box(0, -3, -4, -5)
local margin_box = box(-25, -15, 0, 0)
-- dbl res
local margin_box_dbl = box(-25, -30, 0, 0)

local text_table = {}


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

local function AddIcons()
	local str_Metals = _InternalTranslate(T("<icon_Metals>")):gsub("1300", "2200")
	local str_Polymers = _InternalTranslate(T("<icon_Polymers>")):gsub("1300", "2200")

	local r = const.ResourceScale

	-- parent dialog storage
	local parent = Dialogs.HUD
	if not parent.ChoGGi_TempResInfo then
		parent.ChoGGi_TempResInfo = XWindow:new({
			Id = "ChoGGi_TempResInfo",
		}, parent)
	end
	parent = parent.ChoGGi_TempResInfo
	parent:SetTransparency(mod_TextOpacity)

	local text_style = style_lookup[mod_TextStyle]
	local background = mod_TextBackground and black or XText.Background

	local g_MapSectors = g_MapSectors
	for sector in pairs(g_MapSectors) do
		-- skip 1-10
		if type(sector) == "table" then

			local metals_c = 0
			local polymers_c = 0
			local markers = sector.markers.surface
			for i = 1, #markers do
				local obj = markers[i].placed_obj
				-- placed_obj is removed from marker once it's empty
				if IsValid(obj) then
					if mod_ShowMetals and obj.resource == "Metals" then
						metals_c = metals_c + obj:GetAmount()
					elseif mod_ShowPolymers and obj.resource == "Polymers" then
						polymers_c = polymers_c + obj:GetAmount()
					end
				end
			end
			-- add text for found res
			table_iclear(text_table)
			local c = 0
			if metals_c > 0 then
				c = c + 1
				text_table[c] = str_Metals .. (metals_c/r)
			end
			if polymers_c > 0 then
				c = c + 1
				text_table[c] = str_Polymers .. (polymers_c/r)
			end

			if c > 0 then
				local text_dlg = XText:new({
					TextStyle = text_style,
					Padding = padding_box,
					Margins = c == 2 and margin_box_dbl or margin_box,
					Background = background,
					Dock = "box",
					HAlign = "left",
					VAlign = "top",
					Clip = false,
					HandleMouse = false,
				}, parent)

				text_dlg:SetText(table_concat(text_table, "\n"))

				text_dlg:AddDynamicPosModifier{
					id = "sector_info",
					target = sector,
				}
				text_dlg:SetVisible(true)
			end
		end
	end

end

local orig_OverviewModeDialog_Init = OverviewModeDialog.Init
function OverviewModeDialog.Init(...)
	AddIcons()
	return orig_OverviewModeDialog_Init(...)
end

local function ClearIcons()
	local parent = Dialogs.HUD.ChoGGi_TempResInfo
	if not parent then
		return
	end

	for i = #parent, 1, -1 do
		parent[i]:Close()
	end
end

local orig_OverviewModeDialog_Close = OverviewModeDialog.Close
function OverviewModeDialog.Close(...)
	ClearIcons()
	return orig_OverviewModeDialog_Close(...)
end

-- we don't want them around for saves
OnMsg.SaveGame = ClearIcons
