local GetObjects = GetObjects
local r = const.ResourceScale

function OnMsg.NewDay()
  local objs = GetObjects{class = "SubsurfaceDepositWater"} or ""
  for i = 1, #objs do
    local o = objs[i]
    if o.amount < o.max_amount then
      o.amount = o.amount + ((ChoGGi_AddWaterEachSol.AmountOfWater or 50) * r)
    end
  end
end

ChoGGi_AddWaterEachSol = {}

function OnMsg.ModConfigReady()
  local ModConfig = ModConfig

  --get options
  ChoGGi_AddWaterEachSol.AmountOfWater = ModConfig:Get("ChoGGi_AddWaterEachSol", "AmountOfWater") or 50

  --setup menu options
  ModConfig:RegisterMod("ChoGGi_AddWaterEachSol", "Add Water Each Sol")

  ModConfig:RegisterOption("ChoGGi_AddWaterEachSol", "AmountOfWater", {
    name = [[How much water each deposit receives each Sol.]],
    type = "number",
    min = 0,
    step = 1,
    default = 50,
  })

end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
  if mod_id == "ChoGGi_AddWaterEachSol" then
    if option_id == "AmountOfWater" then
      ChoGGi_AddWaterEachSol.AmountOfWater = value
    end
  end
end
