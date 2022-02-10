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

-- RCRoverAndChildren, RCTransportAndChildren
local child_rovers = {
	RCRover = true,
	RCTransport = true,
}

-- last checked picard
local ChoOrig_CargoTransporter_ListAvailableRovers = CargoTransporter.ListAvailableRovers
function CargoTransporter:ListAvailableRovers(class, quick_load, ...)
	if not mod_EnableMod or not child_rovers[class] then
		return ChoOrig_CargoTransporter_ListAvailableRovers(self, class, quick_load, ...)
	end

--~   local rovers_list = self.city.labels[class] or empty_table
  local rovers_list = self.city.labels[class .. "AndChildren"] or empty_table

  local filter = function(_, unit)
--~     return unit.class == class and unit:CanBeControlled() and not unit.holder and (quick_load or unit:IsIdle())
    return unit:IsKindOf(class) and unit:CanBeControlled() and not unit.holder and (quick_load or unit:IsIdle())
  end

	-- ifilter returns count? as well
  local available_list = table.ifilter(rovers_list, filter)
  return available_list
end

