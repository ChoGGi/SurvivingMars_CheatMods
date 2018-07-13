local GetObjects = GetObjects
local r = const.ResourceScale

function OnMsg.NewDay()
  local objs = GetObjects{class = "SubsurfaceDepositWater"} or empty_table
  for i = 1, #objs do
    objs[i].amount = objs[i].amount + (50 * r)
  end
end
