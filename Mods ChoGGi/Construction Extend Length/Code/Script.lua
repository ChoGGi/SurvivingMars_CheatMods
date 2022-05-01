-- See LICENSE for terms

local mod_BuildDist
local mod_PassChunks
local mod_PassageWalkSpeed

local function StartupCode()
	if UICity then
		GetGridConstructionController(UICity).max_hex_distance_to_allow_build = mod_BuildDist
	end
	GridConstructionController.max_hex_distance_to_allow_build = mod_BuildDist
	const.PassageConstructionGroupMaxSize = mod_PassChunks
end
-- Set options on new/load game
OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
-- Switch between different maps (can happen before UICity)
OnMsg.ChangeMapDone = StartupCode

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_BuildDist = CurrentModOptions:GetProperty("BuildDist")
	mod_PassChunks = CurrentModOptions:GetProperty("PassChunks")
	mod_PassageWalkSpeed = CurrentModOptions:GetProperty("PassageWalkSpeed")

	StartupCode()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local Sleep = Sleep
local CreateGameTimeThread = CreateGameTimeThread

local ChoOrig_TraverseTunnel = Passage.TraverseTunnel
function Passage:TraverseTunnel(unit, ...)
	-- reset if still here
	if unit.ChoGGi_ConstructionExtendLength_ChoOrig_speed then
		unit.move_speed = unit.ChoGGi_ConstructionExtendLength_ChoOrig_speed
	end

	-- backup orig speed and boost move_speed
	unit.ChoGGi_ConstructionExtendLength_ChoOrig_speed = unit.move_speed or unit:GetMoveSpeed()
	unit.move_speed = unit.move_speed * mod_PassageWalkSpeed
	-- fire off orig func
	local ret = ChoOrig_TraverseTunnel(self, unit, ...)

	CreateGameTimeThread(function()
		while unit.holder do
			Sleep(500)
		end
		-- restore old speed
		unit.move_speed = unit.ChoGGi_ConstructionExtendLength_ChoOrig_speed
		unit.ChoGGi_ConstructionExtendLength_ChoOrig_speed = nil
		unit:SetMoveSpeed(unit.move_speed)
	end)

	return ret
end
