-- See LICENSE for terms

local mod_RandomMissionGoalsAllSponsors

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_RandomMissionGoalsAllSponsors = CurrentModOptions:GetProperty("RandomMissionGoalsAllSponsors")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- Random goals
local ChoOrig_SetupMissionGoals = SetupMissionGoals
function SetupMissionGoals(...)
	local sponsor = GetMissionSponsor()
	if not mod_RandomMissionGoalsAllSponsors
		and sponsor.id ~= "ChoGGi_BlankSponsor_Sponsor"
	then
		return ChoOrig_SetupMissionGoals(...)
	end

	-- These sponsors don't have goals
	local ignore_spon = {
		ChoGGi_BlankSponsor_Sponsor = true,
		None = true,
		random = true,
		-- I might have to include modded ones... or add a check of some sort
	}
	-- Add random goals
	local temp_presets = table.filter(Presets.MissionSponsorPreset.Default, function(id)
		-- skip all indexed sponsors (they include space race and normal sponsors, which might be bad for people without dlc)
		if type(id) == "number" then
			return false
		end
		return not ignore_spon[id]
	end)

	-- table.rand needs an indexed table
	local c = 0
	local presets = {}
	for _, item in pairs(temp_presets) do
		c = c + 1
		presets[c] = item
	end

	local rand = table.rand
	local temp_param
	for i = 1, 5 do
		local rand_spon = rand(presets)
		sponsor["sponsor_goal_" .. i] = rand_spon["sponsor_goal_" .. i]
		sponsor["goal_image_" .. i] = rand_spon["goal_image_" .. i]
		sponsor["goal_pin_image_" .. i] = rand_spon["goal_pin_image_" .. i]
		sponsor["reward_effect_" .. i] = rand_spon["reward_effect_" .. i]
		-- Build goal params
		for j = 1, 3 do
			temp_param = rand_spon["goal_" .. i .. "_param_" .. j]
			if temp_param then
				sponsor["goal_" .. i .. "_param_" .. j] = temp_param
			end
		end
	end

	return ChoOrig_SetupMissionGoals(...)
end
