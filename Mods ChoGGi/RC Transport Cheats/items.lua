-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "WasteRock",
		"DisplayName", T(4518--[[Waste Rock]]),
		"Help", T(0000, "Auto mode looks for wasterock."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "StorageAmount",
		"DisplayName", T(0000, "Storage Amount"),
		"Help", T(0000, "How much transports can store (0 to disable)."),
		"DefaultValue", 0,
		"MinValue", 0,
		"MaxValue", 500,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "WorkTime",
		"DisplayName", T(0000, "Work Time"),
		"Help", T(4640--[[The time it takes the RC Transport to gather 1 resource from a deposit]]),
		"DefaultValue", Consts.RCTransportGatherResourceWorkTime / const.ResourceScale,
		"MinValue", 1,
		"MaxValue", 100,
	}),
}
