ChoGGi_AddWaterEachSol = {
	AmountOfWater = 50
}

function OnMsg.NewDay()
	local water = ChoGGi_AddWaterEachSol.AmountOfWater * const.ResourceScale

	MapForEach("map","SubsurfaceDepositWater",function(o)
		o.amount = o.amount + water
    if o.amount > o.max_amount then
      o.amount = o.max_amount
    end
	end)
end

function OnMsg.ModConfigReady()
  local ModConfig = ModConfig

  -- get option/default
  ChoGGi_AddWaterEachSol.AmountOfWater = ModConfig:Get("ChoGGi_AddWaterEachSol", "AmountOfWater") or 50

  -- setup menu options
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
  if mod_id == "ChoGGi_AddWaterEachSol" and option_id == "AmountOfWater" then
		ChoGGi_AddWaterEachSol.AmountOfWater = value
  end
end
