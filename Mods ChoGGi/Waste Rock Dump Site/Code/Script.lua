-- See LICENSE for terms

function OnMsg.ClassesPostprocess()
	if BuildingTemplates.ChoGGi_WasteRockDumpTower then
		return
	end

	PlaceObj("BuildingTemplate", {
		"Id", "ChoGGi_WasteRockDumpTower",
		"template_class", "WasteRockDumpSite",
		"palette_color1", "outside_base",
		"palette_color2", "inside_base",
		"palette_color3", "rover_base",

		"dome_forbidden", true,
		"display_name", T(785654974292,  "Large Dumping Site"),
		"display_name_pl", T(220612378829, "Large Dumping Sites"),
		"description", T(168638766723, "Stores <wasterock(max_amount_WasteRock)>. Waste Rock is produced as side product of different mining activities."),
		"display_icon", "UI/Icons/Buildings/large_dumping_site.tga",
		"entity", "WasteRockDepotBig",
		"build_category", "ChoGGi",
		"Group", "ChoGGi",
		"disabled_in_environment1", "",
		"disabled_in_environment2", "",
		"disabled_in_environment3", "",
		"disabled_in_environment4", "",

		"max_amount_WasteRock", 99000 * const.ResourceScale,
		"build_points", 0,
		"instant_build", true,
		"encyclopedia_id", "WasteRockDumpBig",
		"encyclopedia_image", "UI/Encyclopedia/DumpingSite.tga",
		"on_off_button", false,
		"prio_button", false,
		"color_modifier", RGBA(122, 85, 8, 255),
		"count_as_building", false,
		"clear_soil_underneath", true,
		"desire_slider_max", 57,
		"force_extend_bb_during_placement_checks", 2000,
	})

end
