function OnMsg.ModConfigReady()
	local ModConfig = ModConfig
	local SaveRocketCargo = SaveRocketCargo

	-- setup menu options
	ModConfig:RegisterMod("SaveRocketCargo", [[Save Rocket Cargo]])

	ModConfig:RegisterOption("SaveRocketCargo", "ClearOnLaunch", {
		name = [[Clear On Launch]],
		desc = [[Clear cargo for rocket/pod/elevator when launched (not all cargo, just for the one type).]],
		type = "boolean",
		default = SaveRocketCargo.ClearOnLaunch,
	})

	-- get saved options (if nothing saved then it'll use the defaults above)
	SaveRocketCargo.ClearOnLaunch = ModConfig:Get("SaveRocketCargo", "ClearOnLaunch")

end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
	if mod_id == "SaveRocketCargo" then
		if option_id == "ClearOnLaunch" then
			SaveRocketCargo.ClearOnLaunch = value
		end
	end
end
