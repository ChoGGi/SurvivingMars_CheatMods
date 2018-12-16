
function OnMsg.ModConfigReady()
	local ModConfig = ModConfig
	local MarkSelectedBuildingType = MarkSelectedBuildingType

	-- setup menu options
	ModConfig:RegisterMod("MarkSelectedBuildingType", "Mark Selected Building Type")

	-- Oh Hai Mark!
	ModConfig:RegisterOption("MarkSelectedBuildingType", "Mark", {
		name = "Mark Buildings",
		desc = "Toggle showing beams.",
		type = "boolean",
		default = MarkSelectedBuildingType.Mark,
	})

	-- get saved options
	MarkSelectedBuildingType.Mark = ModConfig:Get("MarkSelectedBuildingType", "Mark")

end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
	if mod_id == "MarkSelectedBuildingType" and option_id == "Mark" then
		local MarkSelectedBuildingType = MarkSelectedBuildingType
		MarkSelectedBuildingType.Mark = value
		if value then
			MarkSelectedBuildingType.MarkObjects(SelectedObj)
		else
			MarkSelectedBuildingType.ClearBeams()
		end
	end
end
