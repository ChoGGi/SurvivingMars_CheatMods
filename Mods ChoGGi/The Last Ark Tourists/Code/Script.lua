-- See LICENSE for terms

local table = table
local GetSpecialistEntity = GetSpecialistEntity
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

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- always return false if last ark is active (enables in rocket menu)
local ChoOrig_IsGameRuleActive = IsGameRuleActive
local function ChoFake_IsGameRuleActive(rule, ...)
	if rule == "TheLastArk" then
		return false
	end
	return ChoOrig_IsGameRuleActive(rule, ...)
end

local function ReplaceRule(func, ...)
	if mod_EnableMod then
		IsGameRuleActive = ChoFake_IsGameRuleActive
	end
	-- I do pcalls for safety when wanting to change back a global var
	local result, ret = pcall(func, ...)
	IsGameRuleActive = ChoOrig_IsGameRuleActive
	if result then
		return ret
	else
		print("ChoOrig_IsGameRuleActive failed!", ret)
	end
end

local ChoOrig_PassengerRocketDisabledRolloverTitle = RocketPayloadObject.PassengerRocketDisabledRolloverTitle
function RocketPayloadObject.PassengerRocketDisabledRolloverTitle(...)
	return ReplaceRule(ChoOrig_PassengerRocketDisabledRolloverTitle, ...)
end

local ChoOrig_PassengerRocketDisabledRolloverText = RocketPayloadObject.PassengerRocketDisabledRolloverText
function RocketPayloadObject.PassengerRocketDisabledRolloverText(...)
	return ReplaceRule(ChoOrig_PassengerRocketDisabledRolloverText, ...)
end

local ChoOrig_AreNewColonistsAccepted = AreNewColonistsAccepted
function AreNewColonistsAccepted(...)
	return ReplaceRule(ChoOrig_AreNewColonistsAccepted, ...)
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
	if not ChoOrig_IsGameRuleActive("TheLastArk") then
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