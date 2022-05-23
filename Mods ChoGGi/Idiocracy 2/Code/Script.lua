-- See LICENSE for terms

local comm_id = "ChoGGi_Idiocracy2_Commander"
local storybit_id = "politician"

local function UpdateStoryBits()
	-- make sure it's our commander
	if GetCommanderProfile().id ~= comm_id then
		return
	end

	-- swap any politician storybits
	local StoryBits = StoryBits
	for _, storybit in pairs(StoryBits) do
		for i = 1, #storybit do
			local item = storybit[i]
			if item.Prerequisite and item.Prerequisite.CommanderProfile == storybit_id then
				item.Prerequisite.CommanderProfile = comm_id
			end
		end
	end

	-- check if we already bumped crop water (if user loaded save while playing save)
	if CropPresets.Wheat.WaterDemand <= 1600 then
		-- bump water usage
		local CropPresets = CropPresets
		for _, crop in pairs(CropPresets) do
			crop.WaterDemand = crop.WaterDemand + 600
		end
	end

	-- update break chance
	TraitPresets.Idiot.param = 7.5 -- default 10
end
OnMsg.CityStart = UpdateStoryBits
OnMsg.LoadGame = UpdateStoryBits
