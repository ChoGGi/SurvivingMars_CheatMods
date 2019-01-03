-- put this in script or change load order in metadata
DisableSelectionPanelSizing = {
	Enabled = true,
	ScrollSelection = false,
}

function OnMsg.ModConfigReady()
	local ModConfig = ModConfig
	local DisableSelectionPanelSizing = DisableSelectionPanelSizing

	-- setup menu options
	ModConfig:RegisterMod("DisableSelectionPanelSizing", "Disable Selection Panel Sizing")

	ModConfig:RegisterOption("DisableSelectionPanelSizing", "Enabled", {
		name = "Disable Panel Sizing",
		desc = "If you want to re-enable the auto-sizing.",
		type = "boolean",
		default = DisableSelectionPanelSizing.Enabled,
	})

	ModConfig:RegisterOption("DisableSelectionPanelSizing", "ScrollSelection", {
		name = "Scroll Sections",
		desc = "Adds scrollbars to certain panels (buggy, has flickering).",
		type = "boolean",
		default = DisableSelectionPanelSizing.ScrollSelection,
	})

	-- get saved options
	DisableSelectionPanelSizing.Enabled = ModConfig:Get("DisableSelectionPanelSizing", "Enabled")
	DisableSelectionPanelSizing.ScrollSelection = ModConfig:Get("DisableSelectionPanelSizing", "ScrollSelection")

end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
	if mod_id == "DisableSelectionPanelSizing" then
		if option_id == "Enabled" then
			DisableSelectionPanelSizing.Enabled = value
		elseif option_id == "ScrollSelection" then
			DisableSelectionPanelSizing.ScrollSelection = value
		end
	end
end
