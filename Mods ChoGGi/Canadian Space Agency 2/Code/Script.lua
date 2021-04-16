-- See LICENSE for terms

local GetMissionSponsor = GetMissionSponsor
local TGetID = TGetID

-- Add some names
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

-- change rocket/drones if space race
if g_AvailableDlc.gagarin then
	function OnMsg.ModsReloaded()
		local sponsor = Presets.MissionSponsorPreset.Default.ChoGGi_CanadianSpaceAgency
		sponsor.rocket_class = "DragonRocket"
		sponsor.drone_class = "FlyingDrone"
	end
end

-- used below
local comm_id = "ChoGGi_CanadianSpaceAgency_Commander"

-- swap any politician storyibts to CSA
local function UpdateStoryBits(profile_id)
	if profile_id ~= comm_id or GetCommanderProfile().id ~= comm_id then
		return
	end

	local StoryBits = StoryBits
	for _, storybit in pairs(StoryBits) do
		for i = 1, #storybit do
			local subitem = storybit[i]
			if subitem.Prerequisite and subitem.Prerequisite.CommanderProfile == "politician" then
				subitem.Prerequisite.CommanderProfile = "ChoGGi_CanadianSpaceAgency_Commander"
			end
		end
	end
end

OnMsg.LoadGame = UpdateStoryBits

function OnMsg.CityStart()
	local profile_id = GetCommanderProfile().id
	if profile_id ~= comm_id then
		return
	end

	-- change standing to Good
	local RivalAIs = RivalAIs
	for _, rival in pairs(RivalAIs) do
		if rival.resources.standing < 22 then
			rival.resources.standing = 21
		end
	end

	UpdateStoryBits(profile_id)
end

-- change Welcome to Mars audio
local orig_ShowStartGamePopup = ShowStartGamePopup
function ShowStartGamePopup(...)
	if GetMissionSponsor().id == "ChoGGi_CanadianSpaceAgency" then
		PopupNotificationPresets.WelcomeGameInfo.title = T(302535920011902, "Welcome to Mars, Eh!")
	end
	return orig_ShowStartGamePopup(...)
end

function OnMsg.ClassesPostprocess()

	PlaceObj("SoundPreset", {
		id = "ChoGGi_TakeOffEh",
--~ 		type = "UI",
		type = "Voiceover",
		PlaceObj("Sample", {
			-- ThisIsOurMarsEh.opus
			"file", CurrentModPath .. "Sound/ThisIsOurMarsEh",
		}),
	})
	ReloadSoundBanks()

end

local orig_VoiceSampleByText = VoiceSampleByText
function VoiceSampleByText(text, ...)
	if TGetID(text) == 7155 and GetMissionSponsor().id == "ChoGGi_CanadianSpaceAgency" then
		return "ChoGGi_TakeOffEh"
	end

	return orig_VoiceSampleByText(text, ...)
end
