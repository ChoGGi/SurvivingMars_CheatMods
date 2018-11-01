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

function OnMsg.ClassesPostprocess()
	local font = ChoGGi.font
	-- Text
	PlaceObj("TextStyle", {
		TextColor = white,
		RolloverTextColor = white,
		TextFont = StringFormat("%s, 12, bold, aa",font),
		group = "Game",
		id = "ChoGGi_Text12",
	})
	PlaceObj("TextStyle", {
		TextColor = white,
		RolloverTextColor = white,
		TextFont = StringFormat("%s, 14, bold, aa",font),
		group = "Game",
		id = "ChoGGi_Text14",
	})
	-- TextList
	PlaceObj("TextStyle", {
		TextColor = white,
		RolloverTextColor = light_gray,
		TextFont = StringFormat("%s, 12, bold, aa",font),
		group = "Game",
		id = "ChoGGi_TextList12",
	})
	PlaceObj("TextStyle", {
		TextColor = white,
		RolloverTextColor = light_gray,
		TextFont = StringFormat("%s, 14, bold, aa",font),
		group = "Game",
		id = "ChoGGi_TextList14",
	})
	-- MultiLineEdit
	PlaceObj("TextStyle", {
		TextColor = white,
		RolloverTextColor = white,
		TextFont = StringFormat("%s, 16, aa",font),
		group = "Game",
		id = "ChoGGi_MultiLineEdit",
	})
	-- Label
	PlaceObj("TextStyle", {
		TextColor = white,
		-- copied from sagan Label
		DisabledRolloverTextColor = -2144851928,
		DisabledShadowColor = 805306368,
		DisabledTextColor = -2145378272,
		TextFont = StringFormat("%s, 14, bold, aa",font),
		group = "Game",
		id = "ChoGGi_Label",
	})
end
