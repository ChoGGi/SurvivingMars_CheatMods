-- See LICENSE for terms

local mod_BuildDist
local mod_PassChunks
local mod_PassageWalkSpeed

-- fired when settings are changed/init
local function ModOptions()
	mod_BuildDist = CurrentModOptions:GetProperty("BuildDist")
	mod_PassChunks = CurrentModOptions:GetProperty("PassChunks")
	mod_PassageWalkSpeed = CurrentModOptions:GetProperty("PassageWalkSpeed")

	if UICity then
		CityGridConstruction[UICity].max_hex_distance_to_allow_build = mod_BuildDist
	end
	GridConstructionController.max_hex_distance_to_allow_build = mod_BuildDist
	const.PassageConstructionGroupMaxSize = mod_PassChunks
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

-- set options on new/load game
OnMsg.CityStart = ModOptions
OnMsg.LoadGame = ModOptions

local Sleep = Sleep
local CreateGameTimeThread = CreateGameTimeThread

local orig_TraverseTunnel = Passage.TraverseTunnel
function Passage:TraverseTunnel(unit, ...)
	-- reset if still here
	if unit.ChoGGi_ConstructionExtendLength_orig_speed then
		unit.move_speed = unit.ChoGGi_ConstructionExtendLength_orig_speed
	end

	-- backup orig speed and boost move_speed
	unit.ChoGGi_ConstructionExtendLength_orig_speed = unit.move_speed or unit:GetMoveSpeed()
	unit.move_speed = unit.move_speed * mod_PassageWalkSpeed
	-- fire off orig func
	local ret = orig_TraverseTunnel(self, unit, ...)

	CreateGameTimeThread(function()
		while unit.holder do
			Sleep(500)
		end
		-- restore old speed
		unit.move_speed = unit.ChoGGi_ConstructionExtendLength_orig_speed
		unit.ChoGGi_ConstructionExtendLength_orig_speed = nil
		unit:SetMoveSpeed(unit.move_speed)
	end)

	return ret
end
