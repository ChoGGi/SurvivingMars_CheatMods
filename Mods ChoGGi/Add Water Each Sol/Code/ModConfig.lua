function OnMsg.ModConfigReady()
	local ModConfig = ModConfig

	-- get option/default
	ChoGGi_AddWaterEachSol.AmountOfWater = ModConfig:Get("ChoGGi_AddWaterEachSol", "AmountOfWater")

	-- setup menu options
	ModConfig:RegisterMod("ChoGGi_AddWaterEachSol", "Adds water each sol to deposits.")

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
