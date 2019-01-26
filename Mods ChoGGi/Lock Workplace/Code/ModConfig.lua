function OnMsg.ModConfigReady()
	local ModConfig = ModConfig
	local LockWorkplace = LockWorkplace

	-- setup menu options
	ModConfig:RegisterMod("LockWorkplace", [[Lock Workplace]])

	ModConfig:RegisterOption("LockWorkplace", "NeverChange", {
		name = [[Never Change]],
		desc = [[Workers will never change workplace (may cause issues).]],
		type = "boolean",
		default = LockWorkplace.NeverChange,
	})

	-- get saved options
	LockWorkplace.NeverChange = ModConfig:Get("LockWorkplace", "NeverChange")

end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
	if mod_id == "LockWorkplace" then
		if option_id == "NeverChange" then
			LockWorkplace.DoSomething = value
		end
	end
end
