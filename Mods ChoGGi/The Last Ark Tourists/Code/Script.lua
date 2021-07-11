-- See LICENSE for terms

local table = table
local GetSpecialistEntity = GetSpecialistEntity
local GameTime = GameTime
local CreateGameTimeThread = CreateGameTimeThread
local Random = ChoGGi.ComFuncs.Random
--~ local LaunchHumanMeteor = ChoGGi.ComFuncs.LaunchHumanMeteor

local LaunchHumanMeteor = ChoGGi.ComFuncs.LaunchHumanMeteor or function(entity, min, max)
	--	1 to 4 sols
	Sleep(Random(
		min or const.DayDuration,
		max or const.DayDuration * 4
	))
	local data = DataInstances.MapSettings_Meteor.Meteor_VeryLow
	local descr = SpawnMeteor(data, nil, nil, GetRandomPassable())
	-- I got a missle once, not sure why...
	if descr.meteor:IsKindOf("BombardMissile") then
		g_IncomingMissiles[descr.meteor] = nil
		if IsValid(descr.meteor) then
			DoneObject(descr.meteor)
		end
	else
		descr.meteor:Fall(descr.start)
		descr.meteor:ChangeEntity(entity)
		-- frozen meat popsicle (dark blue)
		descr.meteor:SetColorModifier(-16772609)
		-- It looks reasonable
		descr.meteor:SetState("sitSoftChairIdle")
		-- I don't maybe they swelled up from the heat and moisture permeating in space (makes it easier to see the popsicle)
		descr.meteor:SetScale(500)
	end
--~ 	ex(descr.meteor)
end

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	-- I'm sure it wouldn't be that hard to only call this msg for the mod being applied, but...
	if id == CurrentModId then
		ModOptions()
	end
end

-- always return false if last ark is active (enables in rocket menu)
local orig_IsGameRuleActive = IsGameRuleActive
local function fake_IsGameRuleActive(rule, ...)
	if rule == "TheLastArk" then
		return false
	end
	return orig_IsGameRuleActive(rule, ...)
end

local function ReplaceRule(func, ...)
	if mod_EnableMod then
		IsGameRuleActive = fake_IsGameRuleActive
	end
	local ret = func(...)
	IsGameRuleActive = orig_IsGameRuleActive
	return ret
end

local orig_PassengerRocketDisabledRolloverTitle = RocketPayloadObject.PassengerRocketDisabledRolloverTitle
function RocketPayloadObject.PassengerRocketDisabledRolloverTitle(...)
	return ReplaceRule(orig_PassengerRocketDisabledRolloverTitle, ...)
end

local orig_PassengerRocketDisabledRolloverText = RocketPayloadObject.PassengerRocketDisabledRolloverText
function RocketPayloadObject.PassengerRocketDisabledRolloverText(...)
	return ReplaceRule(orig_PassengerRocketDisabledRolloverText, ...)
end

local orig_AreNewColonistsAccepted = AreNewColonistsAccepted
function AreNewColonistsAccepted(...)
	return ReplaceRule(orig_AreNewColonistsAccepted, ...)
end

-- remove non-tourists from rocket and fire them
function OnMsg.RocketLaunchFromEarth(rocket)
	if not mod_EnableMod then
		return
	end

	if rocket.category ~= "passenger" then
		return
	end

	-- probably not good to do this one non-ark games
	if not orig_IsGameRuleActive("TheLastArk") then
		return
	end

	local idx = table.find(rocket.cargo, "class", "Passengers")
	if not idx then
		return
	end
	local cargo = rocket.cargo[idx]

	local time_left = g_Consts.TravelTimeMarsEarth

	local count = cargo.amount or 0
	local colonists = cargo.applicants_data or ""
	for i = count, 1, -1 do
		local c = colonists[i]
		if not c.traits.Tourist then
			table.remove(colonists, i)
			count = count - 1
			-- launching
			local entity = GetSpecialistEntity(c.specialist, c.gender, c.race, c.age_trait, c.traits)
			CreateGameTimeThread(LaunchHumanMeteor, entity, time_left, time_left * 2)
		end
	end
	cargo.amount = count

end