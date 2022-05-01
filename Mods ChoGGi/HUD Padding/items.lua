-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionInputBox", {
		"name", "Infobar",
		"DisplayName", T(9764--[[Infobar]]),
		"Help", T(0000, [[left, top, right, bottom

Negative numbers can be used to move off screen.
This needs all four numbers, use 0 to add no padding!
]]),
		"DefaultValue", "0,0,0,0",
	}),
	PlaceObj("ModItemOptionInputBox", {
		"name", "OnScreenNotificationsDlg",
		"DisplayName", T(0000, "On-Screen Notifications"),
		"Help", T(0000, [[left, top, right, bottom

Negative numbers can be used to move off screen.
This needs all four numbers, use 0 to add no padding!
]]),
		"DefaultValue", "0,0,0,0",
	}),
	PlaceObj("ModItemOptionInputBox", {
		"name", "BottomBar",
		"DisplayName", T(0000, "Bottom Bar"),
		"Help", T(0000, [[left, top, right, bottom

Negative numbers can be used to move off screen.
This needs all four numbers, use 0 to add no padding!
]]),
		"DefaultValue", "0,0,0,0",
	}),
}
