-- See LICENSE for terms

local IsGameRuleActive = IsGameRuleActive
local NameUnit = NameUnit
local IsValid = IsValid
local table = table
local PlaceResourcePile = PlaceResourcePile

local mod_AmazonianSize
local mod_MaleSize

-- Change Male and Other to Female (excluding tourists)
local function UpdateApplicant(app)
	if app.gender ~= "Female" and not app.traits.Tourist then
		app.gender = "Female"
		app.entity_gender = "Female"
		app.traits.Female = true
		app.traits.Male = nil
		app.traits.Other = nil
		NameUnit(app)
	end
end

local function UpdateStuff()
	if not IsGameRuleActive("ChoGGi_AmazonianMars") then
		return
	end

	-- Clean up applicant pool
	local g_ApplicantPool = g_ApplicantPool
	for i = 1, #g_ApplicantPool do
		UpdateApplicant(g_ApplicantPool[i][1])
	end

	-- Speeds up entity related stuff
	SuspendPassEdits("ChoGGi_GameRuleAmazonianMars.UpdateStuff")

	-- Update female model size
	local objs = UIColony:GetCityLabels("ColonistFemale")
	for i = 1, #objs do
		local obj = objs[i]
		-- wouldn't be the first time there's an invalid colonist in labels
		if IsValid(obj) then
			obj:SetScale(mod_AmazonianSize)
		end
	end
	--
	objs = UIColony:GetCityLabels("ColonistMale")
	for i = 1, #objs do
		local obj = objs[i]
		if IsValid(obj) then
			-- Male model size
			if obj.traits.Tourist then
				obj:SetScale(mod_MaleSize)
			-- Daily cull (soylent green)
			elseif obj:CanChangeCommand() then
				PlaceResourcePile(obj:GetVisualPos(), "Food", 1000)
				obj:SetCommand("Erase")
			end
		end
	end

	-- Daily cull (soylent green)
	objs = UIColony:GetCityLabels("ColonistOther")
	for i = 1, #objs do
		local obj = objs[i]
		if not obj.traits.Tourist and obj:CanChangeCommand() then
			PlaceResourcePile(obj:GetVisualPos(), "Food", 1000)
			obj:SetCommand("Erase")
		end
	end

	-- "obj:CanChangeCommand()" is to check if they're alive)

	ResumePassEdits("ChoGGi_GameRuleAmazonianMars.UpdateStuff")
end
-- New games
OnMsg.CityStart = UpdateStuff
-- Saved ones
OnMsg.LoadGame = UpdateStuff

OnMsg.NewDay = UpdateStuff

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_AmazonianSize = CurrentModOptions:GetProperty("AmazonianSize")
	mod_MaleSize = CurrentModOptions:GetProperty("MaleSize")

	-- Make sure we're in-game
	if not UIColony then
		return
	end

	UpdateStuff()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- Stop new male/other non-tourists applicants from being created
local ChoOrig_GenerateApplicant = GenerateApplicant
function GenerateApplicant(...)
	if not IsGameRuleActive("ChoGGi_AmazonianMars") then
		return ChoOrig_GenerateApplicant(...)
	end

	local app = ChoOrig_GenerateApplicant(...)

	UpdateApplicant(app)

	return app
end

-- Non-female children are culled at birth (lower birth rate).
local function CullMales(colonist)
	if not IsGameRuleActive("ChoGGi_AmazonianMars") then
		return
	end

	if IsValid(colonist)
		and colonist.gender ~= "Female"
		and not colonist.traits.Tourist
	then
		colonist:SetCommand("Erase")
	end
end

OnMsg.ColonistArrived = CullMales
OnMsg.ColonistBorn = CullMales

-- Cull expedition passengers instead of waiting for daily cull.
local ChoOrig_RocketBase_LandOnMars = RocketBase.LandOnMars
function RocketBase:LandOnMars(...)
	if not IsGameRuleActive("ChoGGi_AmazonianMars") then
		return ChoOrig_RocketBase_LandOnMars(self, ...)
	end

	if self.expedition and self.expedition.crew then
		for i = #self.expedition.crew, 1, -1 do
			local crew = self.expedition.crew[i]
			if IsValid(crew) and crew.gender ~= "Female" then
				-- Unlike supplyrockets from Earth these are actual colonist objs, so we need to erase them (well they could probably just float in the void memory leaking)
				crew:SetCommand("Erase")
				table.remove(self.expedition.crew, i)
			end
		end
		-- Update UI info
		self.expedition.num_crew = #self.expedition.crew
	end

	return ChoOrig_RocketBase_LandOnMars(self, ...)
end

-- Change to correct logo
local ChoOrig_RocketBase_WaitInOrbit = RocketBase.WaitInOrbit
function RocketBase:WaitInOrbit(...)
	if not IsGameRuleActive("ChoGGi_AmazonianMars") then
		return ChoOrig_RocketBase_WaitInOrbit(self, ...)
	end

	-- No logo, no point
	local logo = MissionLogoPresetMap.eQKD54
	if not logo then
		return ChoOrig_RocketBase_WaitInOrbit(self, ...)
	end
	logo = logo.entity_name

	-- Check for a male (there shouldn't be any non-tourists, but culling happens soon anyways)
	local cargo = self.cargo or empty_table
	local pass_idx = table.find(cargo, "class", "Passengers")
	if pass_idx then
		local idx = table.find(cargo[pass_idx].applicants_data, "gender", "Male")
		-- Found a male
		if idx then
			CreateRealTimeThread(function()
				-- A delay is needed before changing logo from this func
				Sleep(1000)

				-- Change logo to Planet Express Logo
				local attaches = self:GetAttaches("Logo") or ""
				for i = 1, #attaches do
					attaches[i]:ChangeEntity(logo)
				end
			end)
		end
	end

	return ChoOrig_RocketBase_WaitInOrbit(self, ...)
end

function OnMsg.ClassesPostprocess()
	if GameRulesMap.ChoGGi_AmazonianMars then
		return
	end

	PlaceObj("GameRules", {
		challenge_mod = 301,
		description = T(0000, [[You may only import female colonists (exception: tourists).
Male tourists "provide" children (Snu-snu required).
Non-female children are culled at birth (lower birth rate).
and just in case a daily cull of any non-tourist non-female colonists on Mars (mini-soylent green).

<grey>"The spirit is willing, but the flesh is spongy and bruised."
<right>25-Star General Zapp Brannigan</grey><left>]]),
		display_name = T(0000, "Amazonian Mars"),
		group = "Default",
		id = "ChoGGi_AmazonianMars",
	})
end
