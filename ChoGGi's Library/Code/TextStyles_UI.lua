-- See LICENSE for terms

local StringFormat = string.format

-- see also Classes_UI.lua
local white = -1
local black = -16777216
local dark_blue = -12235133
local darker_blue = -16767678
local dark_gray = -13158858
local darker_gray = -13684945
--~ local less_dark_gray = -12500671
local medium_gray = -10592674
local light_gray = -2368549
local rollover_blue = -14113793
local invis = 0


--[[ from TextStyle
TextFont
TextColor
RolloverTextColor
DisabledTextColor
DisabledRolloverTextColor
ShadowType
ShadowSize
ShadowColor
DisabledShadowColor
--]]

-- rgb colours from in-game objects
-- 0 0 0 48
local invis0_48 = 805306368
-- 40 40 40 128
local gray40_128 = -2144851928
-- 32 32 32 128
local gray32_128 = -2145378272
-- 32 32 32 255
local gray32_255 = -14671840

local font = ChoGGi.font
local GedDefault = StringFormat("%s, 15, aa",font)
local Editor14Bold = StringFormat("%s, 14, bold, aa",font)
local Editor12Bold = StringFormat("%s, 12, bold, aa",font)
local Editor16Bold = StringFormat("%s, 16, bold, aa",font)
local Editor16 = StringFormat("%s, 16, aa",font)

-- no sense in adding these to each item
DefineClass.ChoGGi_TextStyle = {
	__parents = {"TextStyle"},
	DisabledShadowColor = invis0_48,
	DisabledRolloverTextColor = gray40_128,
	DisabledTextColor = gray32_128,
	TextFont = GedDefault,
	-- close enough?
  group = "Common",
  save_in = "Common",
	-- we get an error from Preset:Register() if we don't have this (still works fine)
	PresetClass = "TextStyle",
}

function OnMsg.ClassesPostprocess()

	-- Text
	PlaceObj("ChoGGi_TextStyle", {
		TextColor = white,
		RolloverTextColor = white,
		TextFont = Editor12Bold,
		id = "ChoGGi_Text12",
	})
	PlaceObj("ChoGGi_TextStyle", {
		TextColor = white,
		RolloverTextColor = white,
		TextFont = Editor14Bold,
		id = "ChoGGi_Text14",
	})
	-- TextList
	PlaceObj("ChoGGi_TextStyle", {
		TextColor = white,
		RolloverTextColor = light_gray,
		TextFont = Editor12Bold,
		id = "ChoGGi_TextList12",
	})
	PlaceObj("ChoGGi_TextStyle", {
		TextColor = white,
		RolloverTextColor = light_gray,
		TextFont = Editor14Bold,
		id = "ChoGGi_TextList14",
	})
	-- MultiLineEdit
	PlaceObj("ChoGGi_TextStyle", {
		TextColor = white,
		RolloverTextColor = white,
		TextFont = Editor16,
		id = "ChoGGi_MultiLineEdit",
	})
	-- Label
	PlaceObj("ChoGGi_TextStyle", {
		TextColor = white,
		TextFont = Editor14Bold,
		id = "ChoGGi_Label",
	})
	-- Buttons
	PlaceObj("ChoGGi_TextStyle", {
		TextColor = gray32_255,
		RolloverTextColor = white,
		id = "ChoGGi_Buttons",
	})
	-- ConsoleButton
	PlaceObj("ChoGGi_TextStyle", {
		TextFont = Editor16Bold,
		RolloverTextColor = white,
		id = "ChoGGi_ConsoleButton",
	})
	-- ButtonMenu
	PlaceObj("ChoGGi_TextStyle", {
		TextFont = Editor16Bold,
		RolloverTextColor = white,
		TextColor = black,
		id = "ChoGGi_ButtonMenu",
	})
	-- ComboButton
	PlaceObj("ChoGGi_TextStyle", {
		RolloverTextColor = white,
		id = "ChoGGi_ComboButton",
	})
	-- CheckButton
	PlaceObj("ChoGGi_TextStyle", {
		TextColor = white,
		RolloverTextColor = light_gray,
		id = "ChoGGi_CheckButton",
	})
	-- CheckButtonMenu
	PlaceObj("ChoGGi_TextStyle", {
		TextFont = Editor16Bold,
		TextColor = black,
		RolloverTextColor = white,
		id = "ChoGGi_CheckButtonMenu",
	})
	-- List
	PlaceObj("ChoGGi_TextStyle", {
		TextColor = white,
		RolloverTextColor = light_gray,
		id = "ChoGGi_List",
	})

end
