function OnMsg.ModConfigReady()
	local ModConfig = ModConfig
	local ChoGGi_Alien_Settings = ChoGGi_Alien_Settings

	-- setup menu options
	ModConfig:RegisterMod("ChoGGi_Alien_Settings", "Alien Visitors")

	ModConfig:RegisterOption("ChoGGi_Alien_Settings", "MaxSpawn", {
		name = "Max amount on new games",
		type = "number",
		min = 4,
		step = 1,
		default = ChoGGi_Alien_Settings.MaxSpawn,
	})

	-- get saved options
	ChoGGi_Alien_Settings.MaxSpawn = ModConfig:Get("ChoGGi_Alien_Settings", "MaxSpawn")

end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
	if mod_id == "ChoGGi_Alien_Settings" and option_id == "MaxSpawn" then
		ChoGGi_Alien_Settings.MaxSpawn = value
	end
end
