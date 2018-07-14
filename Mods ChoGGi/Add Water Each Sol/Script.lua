local GetObjects = GetObjects
local r = const.ResourceScale

function OnMsg.NewDay()
  local objs = GetObjects{class = "SubsurfaceDepositWater"} or empty_table
  for i = 1, #objs do
    local o = objs[i]
    if o.amount < o.max_amount then
      o.amount = o.amount + (50 * r)
    end
  end
end
