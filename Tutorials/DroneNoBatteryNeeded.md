```
-- id of new tech
local research_tech_id = "DroneNoBatteryNeeded"

local is_tech_researched
-- update value when it gets researched
function OnMsg.TechResearched(tech_id)
	if tech_id == research_tech_id then
    is_tech_researched = true
  end
end
-- update value on game load
function OnMsg.LoadGame()
	if UICity:IsTechResearched(research_tech_id) then
    is_tech_researched = true
  end
end

-- replace UseBattery function with one that checks if is_tech_researched == true
function OnMsg.ClassesBuilt()

  local orig_Drone_UseBattery = Drone.UseBattery
  function Drone:UseBattery(amount)
    if not is_tech_researched then
      orig_Drone_UseBattery(self, amount)
    end
  end

end
```