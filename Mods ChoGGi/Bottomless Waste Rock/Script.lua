-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 53
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error",string.format([[Bottomless WasteRock requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
				if p.pops then
					OpenUrl("https://mods.paradoxplaza.com/mods/505/Any")
				else
					OpenUrl("https://www.nexusmods.com/survivingmars/mods/89?tab=files")
				end
			end
		end)
	end
end

DefineClass.BottomlessWasteRock = {
  __parents = {
    "WasteRockDumpSite"
  },
}

function BottomlessWasteRock:GameInit()
  --fire off the usual GameInit
  WasteRockDumpSite.GameInit(self)

  --make sure it isn't mistaken for a regular depot
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
			"build_category","ChoGGi",
			"Group", "ChoGGi",
			"display_icon", string.format("%sres_waste_rock.tga",CurrentModPath),
			"entity", "ResourcePlatform",
			"on_off_button", false,
			"prio_button", false,
			"count_as_building", false,
			"switch_fill_order", false,
			"fill_group_idx", 9,
		})
	end
end --ClassesPostprocess
