-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "ShowDropped",
		"DisplayName", T(302535920011916, "Show Dropped Resources"),
		"Help", T(302535920011917, "Show indicator <image UI/Icons/Sections/storage.tga> for any dropped resource piles (this will ignore any within range of a drone controller)."),
		"DefaultValue", true,
	}),
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
		"name", "ShowScanProgress",
		"DisplayName", T(302535920011782, "Show Scan Progress"),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "TextBackground",
		"DisplayName", T(302535920011376, "Text Background"),
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
		"name", "InfoBoxDelay",
		"DisplayName", T(0000, "InfoBox Delay"),
		"Help", T(0000, "Delay popup in seconds, 0 to disable."),
		"DefaultValue", 0,
		"MinValue", 0,
		"MaxValue", 1000,
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
<style LandingPosNameAlt>Example Text 10</style>]]), -- see my Example View TextStyles mod for more textstyles
		"DefaultValue", 1,
		"MinValue", 1,
		"MaxValue", 10,
	}),
}
