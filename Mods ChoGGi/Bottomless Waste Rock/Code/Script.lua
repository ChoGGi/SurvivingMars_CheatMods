-- See LICENSE for terms

DefineClass.BottomlessWasteRock = {
  __parents = {
    "WasteRockDumpSite"
  },
}

function BottomlessWasteRock:GameInit()
  -- make sure it isn't mistaken for a regular depot
  self:SetColorModifier(-11252937)
end

--om nom nom nom nom
function BottomlessWasteRock:DroneUnloadResource(drone, request, resource, amount)
  WasteRockDumpSite.DroneUnloadResource(self, drone, request, resource, amount)
  self:CheatEmpty()
  RebuildInfopanel(self)
end

--add building to building template list
function OnMsg.ClassesPostprocess()
	if not BuildingTemplates.BottomlessWasteRock then
		PlaceObj("BuildingTemplate", {
			"Id", "BottomlessWasteRock",
			"template_class", "BottomlessWasteRock",
			"instant_build", true,
			"dome_forbidden", true,
			"display_name", [[Bottomless WasteRock]],
			"display_name_pl", [[Bottomless WasteRock]],
			"description", [[Warning: Any waste rocks dumped at this depot will disappear.]],
			"build_category", "ChoGGi",
			"Group", "ChoGGi",
			"display_icon", CurrentModPath .. "UI/res_waste_rock.png",
			"entity", "ResourcePlatform",
			"on_off_button", false,
			"prio_button", false,
			"count_as_building", false,
			"switch_fill_order", false,
			"fill_group_idx", 9,
		})
	end
end --ClassesPostprocess
