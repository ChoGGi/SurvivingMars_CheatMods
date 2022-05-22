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
function OnMsg.ModsReloaded()
	local sponsor = Presets.MissionSponsorPreset.Default.ChoGGi_CanadianSpaceAgency

	if g_AvailableDlc.gagarin then
		sponsor.FlyingDrone = 5
		sponsor.drone_class = "FlyingDrone"
		sponsor.rocket_class = "DragonRocket"
		sponsor.banners_name = "Japan"

		sponsor.lock_name1 = "FlyingDrone"
		sponsor.lock_value1 = "unlocked"
		sponsor.lock_name2 = "RCSolar"
		sponsor.lock_value2 = "unlocked"
--~ 		sponsor.lock_name3 = "Drone"
--~ 		sponsor.lock_value3 = "unlocked"
	else
		sponsor.Drone = 5
	end
end

-- unlock drone skins
if g_AvailableDlc.gagarin then
	local skins = {}
	local c = 0
	local EntityData = EntityData
	for key in pairs(EntityData) do
		if key:find("DroneJapanFlying") then
			c = c + 1
			skins[c] = key
		end
	end

	function FlyingDrone:GetSkins()
		return skins
	end
end

-- used below
local comm_id = "ChoGGi_CanadianSpaceAgency_Commander"

-- swap any politician storybits
local function UpdateStoryBits()
	if GetCommanderProfile().id ~= comm_id then
		return
	end

	local StoryBits = StoryBits
	for _, storybit in pairs(StoryBits) do
		for i = 1, #storybit do
			local item = storybit[i]
			if item.Prerequisite and item.Prerequisite.CommanderProfile == "politician" then
				item.Prerequisite.CommanderProfile = comm_id
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

	-- politician story to CSA
	UpdateStoryBits()

	-- change standing to Good
	local RivalAIs = RivalAIs
	for _, rival in pairs(RivalAIs) do
		if rival.resources.standing < 22 then
			rival.resources.standing = 21
		end
	end

end

-- change Welcome to Mars audio
local ChoOrig_ShowStartGamePopup = ShowStartGamePopup
function ShowStartGamePopup(...)
	if GetMissionSponsor().id == "ChoGGi_CanadianSpaceAgency" then
		PopupNotificationPresets.WelcomeGameInfo.title = T(302535920011902, "Welcome to Mars, Eh!")
	end
	return ChoOrig_ShowStartGamePopup(...)
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

local ChoOrig_VoiceSampleByText = VoiceSampleByText
function VoiceSampleByText(text, ...)
	if TGetID(text) == 7155 and GetMissionSponsor().id == "ChoGGi_CanadianSpaceAgency" then
		return "ChoGGi_TakeOffEh"
	end

	return ChoOrig_VoiceSampleByText(text, ...)
end
