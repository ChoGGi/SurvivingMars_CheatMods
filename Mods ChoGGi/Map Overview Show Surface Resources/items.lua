return {
	PlaceObj("ModItemOptionToggle", {
		"name", "ShowMetals",
		"DisplayName", T(302535920011374, "Show Metals"),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ShowPolymers",
		"DisplayName", T(302535920011375, "Show Polymers"),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "TextBackground",
		"DisplayName", T(302535920011376, "Text Background"),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "TextOpacity",
		"DisplayName", T(302535920011377, "Text Opacity"),
		"DefaultValue", 0,
		"MinValue", 0,
		"MaxValue", 255,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "TextStyle",
		"DisplayName", T(302535920011378, "Text Style"),
		"Help", T(302535920011496, [[<style EncyclopediaArticleTitle>Example Text 1</style>
<style BugReportScreenshot>Example Text 2</style>
<style CategoryTitle>Example Text 3</style>
<style ConsoleLog>Example Text 4</style>
<style DomeName>Example Text 5</style>
<style GizmoText>Example Text 6</style>
<style InfopanelResourceNoAccept>Example Text 7</style>
<style ListItem1>Example Text 8</style>
<style ModsUIItemStatusWarningBrawseConsole>Example Text 9</style>
<style LandingPosNameAlt>Example Text 10</style>]]),
		"DefaultValue", 1,
		"MinValue", 1,
		"MaxValue", 10,
	}),
}
