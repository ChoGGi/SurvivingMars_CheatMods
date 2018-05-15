local function LargerDeposits(Class)
  local objs = GetObjects({class = Class}) or empty_table
  for i = 1, #objs do
    if objs[i].depth_layer == 2 then --2 = deep, 1 = underground
      objs[i].max_amount = 500000 * const.ResourceScale
    end
  end
end

local function RefillAllDeposits(Class)
  local objs = GetObjects({class = Class}) or empty_table
  for i = 1, #objs do
    if objs[i].depth_layer == 2 then
      objs[i]:CheatRefill()
    end
  end
end

function OnMsg.LoadGame()
  LargerDeposits("SubsurfaceDepositWater")
  LargerDeposits("SubsurfaceDepositMetals")
  LargerDeposits("SubsurfaceDepositPreciousMetals")
  RefillAllDeposits("SubsurfaceDepositWater")
  RefillAllDeposits("SubsurfaceDepositMetals")
  RefillAllDeposits("SubsurfaceDepositPreciousMetals")
end

function OnMsg.NewDay()
  RefillAllDeposits("SubsurfaceDepositWater")
  RefillAllDeposits("SubsurfaceDepositMetals")
  RefillAllDeposits("SubsurfaceDepositPreciousMetals")
end
