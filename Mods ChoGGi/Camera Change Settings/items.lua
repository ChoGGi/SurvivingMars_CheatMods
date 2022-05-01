-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionNumber", {
		"name", "RotateSpeed",
		"DisplayName", T(302535920011734, "Rotate Speed"),
		"Help", T(302535920011735, "How fast the camera moves when holding down <em><middle_click> / <ShortcutName('actionOrbitCamera')></em> and pressing <em><ShortcutName('actionPanLeft')> / <ShortcutName('actionPanRight')></em>."),
		"DefaultValue", 6,
		"MinValue", 1,
		"MaxValue", 50,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "UpDownSpeed",
		"DisplayName", T(302535920011736, "Up Down Speed"),
		"Help", T(302535920011737, "How fast the camera moves when holding down <em><middle_click> / <ShortcutName('actionOrbitCamera')></em> and pressing <em><ShortcutName('actionPanLeft')> / <ShortcutName('actionPanRight')></em>."),
		"DefaultValue", 320,
		"MinValue", 0,
		"MaxValue", 500,
		"StepSize", 10,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MaxZoom",
		"DisplayName", T(302535920011738, "Max Zoom"),
		"Help", T(302535920011739, "How far you can zoom out."),
		"DefaultValue", 24,
		"MinValue", 8,
		"MaxValue", 128,
		"StepSize", 8,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MaxHeight",
		"DisplayName", T(302535920011740, "Max Height"),
		"Help", T(302535920011741, "How far you can move the camera above buildings (bird's-eye)."),
		"DefaultValue", 40,
		"MinValue", 5,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MoveSpeed",
		"DisplayName", T(302535920011742, "Move Speed"),
		"Help", T(302535920011743, "<em><ShortcutName('actionPanUp')><ShortcutName('actionPanLeft')><ShortcutName('actionPanDown')><ShortcutName('actionPanRight')></em> movement speed."),
		"DefaultValue", 10,
		"MinValue", 1,
		"MaxValue", 50,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "ScrollBorder",
		"DisplayName", T(302535920011744, "Scroll Border"),
		"Help", T(302535920011745, "Size of scroll border."),
		"DefaultValue", 5,
		"MinValue", 0,
		"MaxValue", 20,
	}),
}
