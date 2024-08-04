-- See LICENSE for terms

local table = table

local mod_RandomLocation
local mod_RandomSponsor
local mod_RandomCommander
local mod_RandomMystery
local mod_RandomLogo
local mod_RandomRivals
local mod_RandomGameRules
local mod_SkipAchievementRules
local mod_CustomGameRules

local rule_mod_options = {}
local GameRulesMap = GameRulesMap
for id in pairs(GameRulesMap) do
	rule_mod_options[id] = true
end

-- Fired when settings are changed/init
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions

	for id in pairs(rule_mod_options) do
		rule_mod_options[id] = options:GetProperty(id)
	end

	mod_RandomLocation = options:GetProperty("RandomLocation")
	mod_RandomSponsor = options:GetProperty("RandomSponsor")
	mod_RandomCommander = options:GetProperty("RandomCommander")
	mod_RandomMystery = options:GetProperty("RandomMystery")
	mod_RandomLogo = options:GetProperty("RandomLogo")
	mod_RandomRivals = options:GetProperty("RandomRivals")
	mod_RandomGameRules = options:GetProperty("RandomGameRules")
	mod_SkipAchievementRules = options:GetProperty("SkipAchievementRules")
	mod_CustomGameRules = options:GetProperty("CustomGameRules")

	-- Doesn't hurt...
	local rule_length = #Presets.GameRules.Default
	if mod_RandomGameRules > rule_length then
		mod_RandomGameRules = rule_length
	end
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- from source\lua\init.lua CanUnlockAchievement()
local achievement_blockers = {
	FreeConstruction = true,
	EasyMaintenance = true,
	IronColonists = true,
	EasyResearch = true,
	RichCoffers = true,
	EndlessSupply = true,
}

local function CleanSponComm(presets)
	local list = table.copy(presets)
	list.None = nil
	list.random = nil
	return list
end

-- PreGameMission.lua also changes them here (well not the logo, but eh)
function OnMsg.ChangeMap(map)
	-- PreGame is new game menu, "" is loading a save (doesn't seem to matter though)
	if map == "PreGame" or map == "" then
		return
	end

	local Presets = Presets
	local g_CurrentMissionParams = g_CurrentMissionParams

	if mod_RandomSponsor then
		local sponsor = table.rand(CleanSponComm(Presets.MissionSponsorPreset.Default))
		g_CurrentMissionParams.idMissionSponsor = sponsor.id
	end

	if mod_RandomCommander then
		local commander = table.rand(CleanSponComm(Presets.CommanderProfilePreset.Default))
		g_CurrentMissionParams.idCommanderProfile = commander.id
	end

	if mod_RandomLogo then
		local logo = table.rand(Presets.MissionLogoPreset.Default)
		g_CurrentMissionParams.idMissionLogo = logo.id
	end

	if mod_RandomMystery then
		local mysteries = ClassDescendantsList("MysteryBase")
		g_CurrentMissionParams.idMystery = table.rand(mysteries)
	end

	if mod_RandomGameRules > 0 then
		local rules = {}
		-- Add any selected rules to random ones
		if mod_CustomGameRules then
			local old_rules = g_CurrentMissionParams.idGameRules or empty_table
			for id in pairs(old_rules) do
				rules[id] = true
			end
		end
		local rand_rules_count = 0

		local orig_rules = Presets.GameRules.Default
		local custom_rules = {}
		local c = 0
		for i = 1, #orig_rules do
			local rule = orig_rules[i]
			if mod_SkipAchievementRules and not achievement_blockers[rule.id]
				or not mod_SkipAchievementRules
			then
				if rule_mod_options[rule.id] then
					c = c + 1
					custom_rules[c] = rule
				end
			end
		end

		-- eh, it'll do
		for _ = 1, 999 do
			local rule = table.rand(custom_rules)
			if not rules[rule.id] then
				rand_rules_count = rand_rules_count + 1
				rules[rule.id] = true
				--
				if rand_rules_count >= mod_RandomGameRules then
					break
				end
			end
		end
		g_CurrentMissionParams.idGameRules = rules
	end

	if mod_RandomRivals > 0 and g_AvailableDlc.gagarin then
		local used_rivals = {}
		local rivals = {}
		local rand_rivals_count = 0
		for _ = 1, 999 do
			local rival = table.rand(Presets.DumbAIDef.MissionSponsors)
			if not used_rivals[rival.id]
				and rival.id ~= "random"
				and rival.id ~= "none"
				and rival.id ~= g_CurrentMissionParams.idMissionSponsor
			then
				used_rivals[rival.id] = true

				rand_rivals_count = rand_rivals_count + 1
				rivals[rand_rivals_count] = rival.id
				--
				if rand_rivals_count >= mod_RandomRivals then
					break
				end
			end
		end
		g_CurrentMissionParams.idRivalColonies = rivals
	end

end

-- Pick a random location before generating map
local ChoOrig_GenerateCurrentRandomMap = GenerateCurrentRandomMap
function GenerateCurrentRandomMap(...)
	if not mod_RandomLocation then
		return ChoOrig_GenerateCurrentRandomMap(...)
	end

	GetOverlayValues(GenerateRandomLandingLocation())

	return ChoOrig_GenerateCurrentRandomMap(...)
end