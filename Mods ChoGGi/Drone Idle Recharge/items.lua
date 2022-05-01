-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionNumber", {
		"name", "RechargeLimit",
		"DisplayName", T(302535920011238, "Recharge Limit"),
		"Help", T(302535920011236, "If idle and below this limit go recharge."),
		"DefaultValue", 50,
		"MinValue", 1,
		"MaxValue", 99,
	}),
}
