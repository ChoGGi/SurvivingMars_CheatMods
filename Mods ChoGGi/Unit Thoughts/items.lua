-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "Enable Mod"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ForceClearLines",
		"DisplayName", T(302535920011833, "Force Clear Lines"),
		"Help", T(302535920011834, "This will remove any lines stuck on the map (including any from my other mods)."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableLines",
		"DisplayName", T(302535920011841, "Enable Lines"),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableText",
		"DisplayName", T(302535920011717, "Enable Text"),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ShowNames",
		"DisplayName", T(302535920011846, "Show Names"),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "DroneBatteryInfo",
		"DisplayName", T(302535920011842, "Drone Battery Info"),
		"Help", T(302535920011842, "Show Drone remaining battery life with unit info."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "OnlyBatteryInfo",
		"DisplayName", T(302535920011844, "Only Battery Info"),
		"Help", T(302535920011845, "Only show battery info when selecting drones."),
		"DefaultValue", false,
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
