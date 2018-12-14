-- put this in script or change load order in metadata
CtrlClickToMove = {
	MouseScrolling = true,
}

function OnMsg.ModConfigReady()
	local ModConfig = ModConfig
	local CtrlClickToMove = CtrlClickToMove

	-- setup menu options
	ModConfig:RegisterMod("CtrlClickToMove", "Ctrl-Click To Move")

	ModConfig:RegisterOption("CtrlClickToMove", "MouseScrolling", {
		name = "Mouse Scrolling",
		desc = "Mouse near screen edge will scroll view.",
		type = "boolean",
		default = CtrlClickToMove.MouseScrolling,
	})

	-- get saved options
	CtrlClickToMove.MouseScrolling = ModConfig:Get("CtrlClickToMove", "MouseScrolling")

end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
	if mod_id == "CtrlClickToMove" then
		if option_id == "MouseScrolling" then
			CtrlClickToMove.MouseScrolling = value
			if value then
				cameraRTS.SetProperties(1,{ScrollBorder = 5})
			else
				cameraRTS.SetProperties(1,{ScrollBorder = 0})
			end
		end
	end
end
