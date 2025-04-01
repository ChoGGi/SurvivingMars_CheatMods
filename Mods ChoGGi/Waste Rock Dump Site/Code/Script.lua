-- See LICENSE for terms
local function CreateTemplate(id, template)
	PlaceObj("BuildingTemplate", {
		"Id", id,

		"template_class", template.template_class,
		"dome_forbidden", template.dome_forbidden,
		"display_name", template.display_name,
		"display_name_pl", template.display_name_pl,
		"description", template.description,
		"display_icon", template.display_icon,
		"entity", template.entity,
		"encyclopedia_id", template.encyclopedia_id,
		"encyclopedia_image", template.encyclopedia_image,

		"build_category", "ChoGGi",
		"Group", "ChoGGi",
		"disabled_in_environment1", "",
		"disabled_in_environment2", "",
		"disabled_in_environment3", "",
		"disabled_in_environment4", "",
		"max_amount_WasteRock", 99000 * const.ResourceScale,

		"build_points", 0,
		"instant_build", true,
		"on_off_button", false,
		"prio_button", false,
		"count_as_building", false,
		"clear_soil_underneath", true,
	})
end

function OnMsg.ClassesPostprocess()
	local bt = BuildingTemplates

	-- Not sure why I called it a tower?
	if not bt.ChoGGi_WasteRockDumpTower then
		CreateTemplate("ChoGGi_WasteRockDumpTower", bt.WasteRockDumpBig)
		CreateTemplate("ChoGGi_WasteRockDumpTowerHuge", bt.WasteRockDumpHuge)
	end

end
