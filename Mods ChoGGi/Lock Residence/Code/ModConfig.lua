function OnMsg.ModConfigReady()
	local ModConfig = ModConfig
	local LockResidence = LockResidence

	-- setup menu options
	ModConfig:RegisterMod("LockResidence", [[Lock Workplace]])

	ModConfig:RegisterOption("LockResidence", "NeverChange", {
		name = [[Never Change]],
		desc = [[Workers will never change workplace (may cause issues).]],
		type = "boolean",
		default = LockResidence.NeverChange,
	})

	-- get saved options
	LockResidence.NeverChange = ModConfig:Get("LockResidence", "NeverChange")

end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
	if mod_id == "LockResidence" then
		if option_id == "NeverChange" then
			LockResidence.NeverChange = value
		end
	end
end
