-- See LICENSE for terms

local table = table
local empty_table = empty_table

local mod_EnableMod

local ChoOrig_Farm_Done = Farm.Done
function Farm:Done(...)
	if not mod_EnableMod then
		return ChoOrig_Farm_Done(self, ...)
	end

	self:ApplyOxygenProductionMod(false)

  return ChoOrig_Farm_Done(self, ...)
end

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

-- fix existing
function OnMsg.LoadGame()
	if not mod_EnableMod then
		return
	end

	local domes = UIColony:GetCityLabels("Dome")
	for i = 1, #domes do
		local dome = domes[i]
		local mods = dome:GetPropertyModifiers("air_consumption")
		local farms = dome.labels.Farm or empty_table
		for j = #mods, 1, -1 do
			local mod_item = mods[j]
			local idx = table.find(farms, "farm_id", mod_item.id)
			-- can't find farm id, so it's a removed farm
			if not idx then
				dome:SetModifier("air_consumption", mod_item.id, 0, 0)
			end
		end
		dome:UpdateWorking()
	end
end
