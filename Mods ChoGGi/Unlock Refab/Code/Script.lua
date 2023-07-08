-- See LICENSE for terms

local mod_EnableMod

local function StartupCode()
	if not mod_EnableMod then
		return
	end
	-- Find refab button
	local template = XTemplates.ipBuilding[1][1]
	local idx = table.find(template, "OnPressParam", "ToggleRefab")
--~ 	ex(template[idx])

	if not g_AvailableDlc.picard then
		template[idx].__condition = function (_, context)
			return mod_EnableMod and context:CanRefab()
		end

		template[idx].Icon = "UI/Icons/IPButtons/rebuild.tga"
	end

	-- Remove BB dlc requirement
	template[idx].__dlc = ""

end

-- New games
OnMsg.CityStart = StartupCode
-- Saved ones
OnMsg.LoadGame = StartupCode

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

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


local ChoOrig_Building_CanRefab = Building.CanRefab
function Building:CanRefab(...)
	if not mod_EnableMod then
		return ChoOrig_Building_CanRefab(self, ...)
	end

  return self.can_refab and self:IsRefabable()
end

-- No BB
if g_AvailableDlc.picard then
	return
end

function Building:CheatQuickRefab()
  if self:IsRefabable() then
    self:Refabricate()
  end
end

function Building:IsRefabable()
  local valid_class = not IsKindOfClasses(self, "RocketBase", "BaseRover", "ResourceStockpile", "DumpSiteWithAttachedVisualPilesBase", "ConstructionSite", "Passage")
  local has_inside_buildings = IsKindOf(self, "Dome") and #(self.labels.Building or empty_table) > 0

	return valid_class and not has_inside_buildings and not self.destroyed
		and not self.demolishing and not self.is_malfunctioned
end

function Building:ToggleRefab()
  if not self.suspended then
    RebuildInfopanel(self)
    if not self.refab_work_request then
      local max_workers = 1
      local ticks_required_to_refab = 5
      self.refab_work_request = self:AddWorkRequest("Refab", ticks_required_to_refab * DroneResourceUnits.repair, 0, max_workers)
      self:OnSetRefabbing(true)
    else
      self:InterruptDrones(nil, function(drone)
        return drone.w_request == self.refab_work_request and drone
      end)
      self:DisconnectFromCommandCenters()
      table.remove_entry(self.task_requests, self.refab_work_request)
      self.refab_work_request = false
      self:OnSetRefabbing(false)
      self:ConnectToCommandCenters()
    end
  end
end

function Building:ToggleRefab_Update(button)
  if self.refab_work_request then
    button:SetIcon("UI/Icons/IPButtons/cancel.tga")
  else
    button:SetIcon("UI/Icons/IPButtons/rebuild.tga")
  end
  button:SetEnabled(self:CanRefab())
  button:SetRolloverHint(not self.refab_work_request
		and T(13047, "<left_click> Refab") or T(13048, "<left_click> Cancel Refab"))
  button:SetRolloverHintGamepad(not self.refab_work_request
		and T(13049, "<ButtonY> Refab") or T(13050, "<ButtonY> Cancel Refab"))
end
