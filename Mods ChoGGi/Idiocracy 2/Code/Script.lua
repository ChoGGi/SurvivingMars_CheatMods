-- See LICENSE for terms

local spon_id = "ChoGGi_Idiocracy2_Sponsor"
local comm_id = "ChoGGi_Idiocracy2_Commander"
local storybit_id = "politician"

local not_sure_name = T(0000, "Not Sure")

local is_spon_or_comm
local function UpdateStoryBits()
	local spon_id_cur = GetMissionSponsor().id
	local comm_id_cur = GetCommanderProfile().id

	-- Add not sure to list
	if comm_id_cur == comm_id or spon_id_cur == spon_id then
		is_spon_or_comm = true
		local american = g_UniqueHumanNames.American
		american.Male = american.Male or {}
		american.Male[#american.Male+1] = not_sure_name
	end

	-- make sure it's our commander
	if comm_id_cur ~= comm_id then
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

function OnMsg.NewDay(sol)
	-- Re-add (or add more, we're stupid and lazy after all) every 20 sols
	if is_spon_or_comm and sol % 20 == 0 then
		local american = g_UniqueHumanNames.American
		american.Male = american.Male or {}
		american.Male[#american.Male+1] = not_sure_name
	end
end

-- Remove idiot from not sures
local function CheckTrait(c)
	if c.name == not_sure_name then
		c:RemoveTrait("Idiot")
	end
end

OnMsg.ColonistArrived = CheckTrait
OnMsg.ColonistBorn = CheckTrait
