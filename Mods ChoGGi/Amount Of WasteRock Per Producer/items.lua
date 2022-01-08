-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "MultiplyDivide",
		"DisplayName", T(302535920011887, "Multiply Divide"),
		"Help", T(302535920011888, "Turn on to <color 150 255 150>divide</color>, Turn off to <color 255 150 150>multiply</color>."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "Amount",
		"DisplayName", T(302535920011580, "Amount"),
		"Help", T(302535920011578, "All wasterock output is multiplied/divided by this amount."),
		"DefaultValue", 2,
		"MinValue", 0,
		"MaxValue", 100,
	}),
}
