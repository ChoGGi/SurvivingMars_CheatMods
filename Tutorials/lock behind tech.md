```lua
local function ToggleTech()
	if mod_LockBehindTech then
		-- build menu
		if not BuildingTechRequirements.ChoGGi_TriboelectricSensorTower then
			BuildingTechRequirements.ChoGGi_TriboelectricSensorTower = {{ tech = "TriboelectricScrubbing", hide = false, }}
		end
		-- add an entry to unlock it with the tech
		local tech = TechDef.TriboelectricScrubbing
		if not table.find(tech, "Building", "TriboelectricScrubber") then
			tech[#tech+1] = PlaceObj('Effect_TechUnlockBuilding', {
				Building = "ChoGGi_TriboelectricSensorTower",
			})
		end
	else
		if BuildingTechRequirements.ChoGGi_TriboelectricSensorTower then
			BuildingTechRequirements.ChoGGi_TriboelectricSensorTower = nil
		end
		-- no need to remove the Effect_TechUnlockBuilding
	end
end
```