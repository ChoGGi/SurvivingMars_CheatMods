-- See LICENSE for terms

local IsGameRuleActive = IsGameRuleActive
local NameUnit = NameUnit
local IsValid = IsValid
local PlaceResourcePile = PlaceResourcePile

local mod_AmazonianSize

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

local function StartupCode()
	if not IsGameRuleActive("ChoGGi_AmazonianMars") then
		return
	end

	-- check on CityStart if delay needed

	-- Clean up applicant pool
	local g_ApplicantPool = g_ApplicantPool
	for i = 1, #g_ApplicantPool do
		UpdateApplicant(g_ApplicantPool[i][1])
	end

	-- update female model size
	SuspendPassEdits("ChoGGi_GameRuleAmazonianMars.updatefemalemodels")
	local objs = UIColony.city_labels.labels.ColonistFemale or ""
	for i = 1, #objs do
		local obj = objs[i]
		-- wouldn't be the first time there's an invalid colonist in labels
		if IsValid(obj) then
			obj:SetScale(mod_AmazonianSize)
		end
	end
	ResumePassEdits("ChoGGi_GameRuleAmazonianMars.updatefemalemodels")

end
-- New games
OnMsg.CityStart = StartupCode
-- Saved ones
OnMsg.LoadGame = StartupCode

function OnMsg.NewDay()
	if not IsGameRuleActive("ChoGGi_AmazonianMars") then
		return
	end

	StartupCode()

	-- Daily cull
	SuspendPassEdits("ChoGGi_GameRuleAmazonianMars.soylentnon_amazonians")
	local objs = table.icopy(UIColony.city_labels.labels.ColonistMale or empty_table)
	table.iappend(objs, UIColony.city_labels.labels.ColonistOther or empty_table)

	for i = 1, #objs do
		local obj = objs[i]
		if IsValid(obj) and not obj.dying then
			PlaceResourcePile(obj:GetVisualPos(), "Food", 1000)
			obj:Erase()
		end
	end
	ResumePassEdits("ChoGGi_GameRuleAmazonianMars.soylentnon_amazonians")
end

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_AmazonianSize = CurrentModOptions:GetProperty("AmazonianSize")

	-- Make sure we're in-game
	if not UIColony then
		return
	end

	StartupCode()
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
		colonist:Erase()
	end
end

OnMsg.ColonistArrived = CullMales
OnMsg.ColonistBorn = CullMales

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

--~ ex(self)
	-- Check for a male (there shouldn't be any non-tourists, but culling happens soon anyways)
	local change_logo
	local cargo = self.cargo or ""
	for i = 1, #cargo do
		local cargo_tbl = cargo[i]
		if cargo_tbl.class == "Passengers" then
			for j = 1, cargo_tbl.amount do
				if cargo_tbl.applicants_data[j].gender == "Male" then
					change_logo = true
				end
			end
		end
	end

	CreateRealTimeThread(function()
		if not change_logo then
			return
		end
		-- A delay is needed before changing logo from this func
		Sleep(1000)

		-- Change logo to Planet Express Logo
		local attaches = self:GetAttaches("Logo") or ""
		for i = 1, #attaches do
			attaches[i]:ChangeEntity(logo)
		end
	end)

	return ChoOrig_RocketBase_WaitInOrbit(self, ...)
end

-- Reset logo (probably not needed)
local ChoOrig_RocketBase_OffPlanet = RocketBase.OffPlanet
function RocketBase:OffPlanet(...)
	if not IsGameRuleActive("ChoGGi_AmazonianMars") then
		return ChoOrig_RocketBase_OffPlanet(self, ...)
	end

	local old_logo = MissionLogoPresetMap.eQKD54
	if not old_logo then
		return ChoOrig_RocketBase_OffPlanet(self, ...)
	end
	old_logo = old_logo.entity_name

	local new_logo = MissionLogoPresetMap[g_CurrentMissionParams.idMissionLogo or "IMM"].entity_name

	-- Planet Express Colony Logo
	local attaches = self:GetAttaches("Logo") or ""
	for i = 1, #attaches do
		local a = attaches[i]
		if a.entity == old_logo then
			a:ChangeEntity(new_logo)
		end

	end

	return ChoOrig_RocketBase_OffPlanet(self, ...)
end
