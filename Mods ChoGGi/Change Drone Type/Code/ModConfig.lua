function OnMsg.ModConfigReady()
	local ModConfig = ModConfig
	local ChangeDroneType = ChangeDroneType

	-- setup menu options
	ModConfig:RegisterMod("ChangeDroneType", [[MOD NAME]])

	ModConfig:RegisterOption("ChangeDroneType", "Aerodynamics", {
		name = [[Martian Aerodynamics]],
		desc = [[Only show button when Martian Aerodynamics has been researched.]],
		type = "boolean",
		default = ChangeDroneType.Aerodynamics,
	})

	-- get saved options
	ChangeDroneType.Aerodynamics = ModConfig:Get("ChangeDroneType", "Aerodynamics")

end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
	if mod_id == "ChangeDroneType" then
		if option_id == "Aerodynamics" then
			ChangeDroneType.Aerodynamics = value
		end
	end
end
