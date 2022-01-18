-- See LICENSE for terms

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

local ChoOrig_City_InitBreakThroughAnomalies = City.InitBreakThroughAnomalies
function City:InitBreakThroughAnomalies(...)
	if not mod_EnableMod then
		return ChoOrig_City_InitBreakThroughAnomalies(self, ...)
	end

	-- This func is called for each new city (surface/underground/asteroids)
	-- Calling it more than once removes the BreakthroughOrder list
	-- That list is used to spawn planetary anomalies
	if self.map_id == MainMapID then
		return ChoOrig_City_InitBreakThroughAnomalies(self, ...)
	end

	-- underground or asteroid city
	local orig_BreakthroughOrder = BreakthroughOrder
	ChoOrig_City_InitBreakThroughAnomalies(self, ...)
	BreakthroughOrder = orig_BreakthroughOrder
end

-- dozers and cave-in pathing (the game will freeze if you send dozers to certain cave-ins or certain paths? this is why I should keep save files around...).
function OnMsg.ClassesPostprocess()

	-- all of them use the same func
	local ChoOrig_RubbleBase_DroneApproach = RubbleBase.DroneApproach

	local ChoOrig_RCTerraformer_ClearRubble = RCTerraformer.ClearRubble
	function RCTerraformer:ClearRubble(rubble, ...)
		if not mod_EnableMod then
			return ChoOrig_RCTerraformer_ClearRubble(self, rubble, ...)
		end

		-- replace this func with working one
		rubble.DroneApproach = function()
			return self:GotoBuildingSpot(rubble, self.work_spot_task)
				or self:GotoBuildingSpot(rubble, self.work_spot_task, false, 6 * const.HexHeight)
		end

		ChoOrig_RCTerraformer_ClearRubble(self, rubble, ...)

		-- than restore orig func
		rubble.DroneApproach = ChoOrig_RubbleBase_DroneApproach

	end

end
