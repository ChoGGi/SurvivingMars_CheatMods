local GetObjects = GetObjects

--~ depth_layer: 2 = core, 1 = underground

-- change to false to have it work on all SubsurfaceDeposits
local apply_to_core_only = true

local function LargerDeposits()
  local r = const.ResourceScale

  GetObjects{
    classes = {"SubsurfaceDepositWater","SubsurfaceDepositMetals","SubsurfaceDepositPreciousMetals"},
    filter = function(o)
      if apply_to_core_only then
        if o.depth_layer == 2 then
          o.max_amount = 500000 * r
          o.grade = "Very High"
        end
      else
        o.max_amount = 500000 * r
        o.grade = "Very High"
      end
    end,
  }
end

local function RefillAllDeposits(cls)
  GetObjects{
    classes = {"SubsurfaceDepositWater","SubsurfaceDepositMetals","SubsurfaceDepositPreciousMetals"},
    filter = function(o)
      if apply_to_core_only then
        if o.depth_layer == 1 then
          o:CheatRefill()
        end
      else
        o:CheatRefill()
      end
    end,
  }
end

function OnMsg.LoadGame()
  LargerDeposits()
  RefillAllDeposits()
end
OnMsg.NewDay = RefillAllDeposits
