-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "Pins1",
		"DisplayName", T(0000, "Pins1"),
		"Help", T(0000, "PinsDlg:SetVisible"),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "Pins2",
		"DisplayName", T(0000, "Pins2"),
		"Help", T(0000, "XBlinkingButtonWithRMB:AddInterpolation"),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "BuildMenu",
		"DisplayName", T(0000, "BuildMenu"),
		"Help", T(0000, "XBuildMenu:EaseInButton"),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "OverviewMode",
		"DisplayName", T(0000, "OverviewTransition"),
		"Help", T(0000, "OverviewModeDialog.GetCameraTransitionTime"),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "FadeToBlack",
		"DisplayName", T(0000, "FadeToBlack"),
		"Help", T(0000, "FadeToBlackDlg"),
		"DefaultValue", true,
	}),
}
