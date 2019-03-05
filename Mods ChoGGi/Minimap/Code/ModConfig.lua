function OnMsg.ModConfigReady()
	local ModConfig = ModConfig
	local ChoGGi_Minimap = ChoGGi_Minimap

	-- setup menu options
	ModConfig:RegisterMod("ChoGGi_Minimap", "Minimap")

	ModConfig:RegisterOption("ChoGGi_Minimap", "UseScreenshots", {
		name = "Screenshots or topography images (needs topo mod)",
		type = "boolean",
		default = ChoGGi_Minimap.UseScreenshots,
	})

	-- get saved options
	ChoGGi_Minimap.UseScreenshots = ModConfig:Get("ChoGGi_Minimap", "UseScreenshots")
end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
	if mod_id == "ChoGGi_Minimap" and option_id == "UseScreenshots" then
		ChoGGi_Minimap.UseScreenshots = value
		ChoGGi_Minimap.UpdateTopoImage(value)
	end
end
