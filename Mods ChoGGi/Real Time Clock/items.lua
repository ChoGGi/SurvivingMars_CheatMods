-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "ShowClock",
		"DisplayName", T(302535920011359, "Show Clock"),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "TimeFormat",
		"DisplayName", T(302535920011361, "24/12 Display"),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "Background",
		"DisplayName", T(302535920011363, "Show Background"),
		"Help", T(302535920011553, "Add black background to text."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "TextOpacity",
		"DisplayName", T(302535920011377, "Text Opacity"),
		"Help", T(302535920011718, "0 = 100% visible, 255 = 0%"),
		"DefaultValue", 0,
		"MinValue", 0,
		"MaxValue", 255,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "TextStyle",
		"DisplayName", T(302535920011362, "Styles"),
		"Help", T(302535920011552, [[<style LandingPosNameAlt>Example Text 1</style>
<style BugReportScreenshot>Example Text 2</style>
<style CategoryTitle>Example Text 3</style>
<style ConsoleLog>Example Text 4</style>
<style DomeName>Example Text 5</style>
<style GizmoText>Example Text 6</style>
<style InfopanelResourceNoAccept>Example Text 7</style>
<style ListItem1>Example Text 8</style>
<style ModsUIItemStatusWarningBrawseConsole>Example Text 9</style>
<style EncyclopediaArticleTitle>Example Text 10</style>]]),
		"DefaultValue", 1,
		"MinValue", 1,
		"MaxValue", 10,
	}),
}
