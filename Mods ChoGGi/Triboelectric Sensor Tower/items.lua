-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "LockBehindTech",
		"DisplayName", T(302535920011937, "Lock Behind Tech"),
		"Help", T{3956, "Research <em><tech_name></em> to unlock this building.",
			tech_name = T(6468, "Triboelectric Scrubbing"),
		},
		"DefaultValue", true,
	}),
}
