-- See LICENSE for terms

local MachineNames = MachineNames

MachineNames.Rocket.ChoGGi_CanadianSpaceAgency = {
	T(302535920011900, "Alouette"),
	T(302535920011901, "Anik"),
	T(302535920011903, "Aurora"),
}

MachineNames.Dome.ChoGGi_CanadianSpaceAgency = {
	T(302535920011904, "Elsinore"),
}
MachineNames.ExplorerRover.ChoGGi_CanadianSpaceAgency = {
	T(302535920011905, "Sabine"),
	T(302535920011906, "Chapman"),
	T(302535920011907, "Florida"),
}
MachineNames.RCRover.ChoGGi_CanadianSpaceAgency = {
	T(302535920011908, "Canadarm"),
}
MachineNames.RCTransport.ChoGGi_CanadianSpaceAgency = {
	T(302535920011909, "Hosehead"),
}

local orig_ShowStartGamePopup = ShowStartGamePopup
function ShowStartGamePopup(...)
	if GetMissionSponsor().id == "ChoGGi_CanadianSpaceAgency" then
		PopupNotificationPresets.WelcomeGameInfo.title = T(302535920011902, "Welcome to Mars, Eh!")
	end
	return orig_ShowStartGamePopup(...)
end

-- change rocket if space race
if g_AvailableDlc.gagarin then
	function OnMsg.ModsReloaded()
		Presets.MissionSponsorPreset.Default.ChoGGi_CanadianSpaceAgency.rocket_class = "DragonRocket"
	end
end
