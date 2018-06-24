
local function SomeCode()
  local sponsor = GetMissionSponsor()
  if sponsor.id == "CNSA" then
    sponsor.goal_target = 100
  end
end

function OnMsg.CityStart()
  SomeCode()
end

function OnMsg.LoadGame()
  SomeCode()
end
