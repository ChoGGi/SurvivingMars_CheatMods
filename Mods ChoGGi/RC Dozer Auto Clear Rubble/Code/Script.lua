-- See LICENSE for terms

if not g_AvailableDlc.picard then
	print(CurrentModDef.title, ": Below & Beyond DLC not installed!")
	return
end

local Sleep = Sleep
local GetRealm = GetRealm

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

local ChoOrig_RCTerraformer_ProcAutomation = RCTerraformer.ProcAutomation
function RCTerraformer:ProcAutomation(...)
	if not mod_EnableMod or self:GetMapID() ~= UIColony.underground_map_id then
		return ChoOrig_RCTerraformer_ProcAutomation(self, ...)
	end

  local unreachable_objects = self:GetUnreachableObjectsTable()
  local rubble = GetRealm(self):MapFindNearest(self, "map", "RubbleBase", function(r)
		-- CanBeCleared checks LowGExcavationPermits tech
		if not unreachable_objects[r] and r:CanBeCleared() then
			return true
		end
	end)

  if rubble then
		local reached_rubble = self:GotoBuildingSpot(rubble, self.work_spot_task, false, 6 * const.HexHeight)

		if IsValid(rubble) then
			if not reached_rubble then
				unreachable_objects[rubble] = true
			else
				self:SetCommand("ClearRubble", rubble, true)
			end
		end

	else
		-- LandscapeConstructionSiteBase
		return ChoOrig_RCTerraformer_ProcAutomation(self, ...)
  end

  Sleep(2500)
end

-- gc help?
local ChoOrig_RubbleBase_OnClear = RubbleBase.OnClear
function RubbleBase:OnClear(...)
	if mod_EnableMod then
		-- baserover.lua -> this calls 	local function InvalidateAllRoverUnreachables()
		Msg("PFTunnelChanged")
	end

	return ChoOrig_RubbleBase_OnClear(self, ...)
end
