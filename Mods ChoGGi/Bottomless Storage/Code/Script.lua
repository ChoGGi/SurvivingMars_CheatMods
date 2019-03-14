-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 60
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error","Bottomless Storage requires ChoGGi's Library (at least v" .. min_version .. [[).
Press OK to download it or check the Mod Manager to make sure it's enabled.]]) == "ok" then
				if p.steam then
					OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
				elseif p.pops then
					OpenUrl("https://mods.paradoxplaza.com/mods/505/Any")
				else
					OpenUrl("https://www.nexusmods.com/survivingmars/mods/89?tab=files")
				end
			end
		end)
	end
end

DefineClass.BottomlessStorage = {
  __parents = {
    "UniversalStorageDepot"
  },
}

function BottomlessStorage:GameInit()
  -- start off with all resource demands blocked
  for i = 1, #self.resource do
    self:ToggleAcceptResource(self.resource[i])
  end

  -- make sure it isn't mistaken for a regular depot
  self:SetColorModifier(0)
end

--om nom nom nom nom
function BottomlessStorage:DroneUnloadResource(drone, request, resource, amount)
  UniversalStorageDepot.DroneUnloadResource(self, drone, request, resource, amount)
  --ResourceStockpileBase.DroneUnloadResource(self, drone, request, resource, amount)
  self:ClearAllResources()
  RebuildInfopanel(self)
end

--add building to building template list
function OnMsg.ClassesPostprocess()
	if not BuildingTemplates.BottomlessStorage then
		PlaceObj("BuildingTemplate", {
			"Id", "BottomlessStorage",
			"template_class", "BottomlessStorage",
			"instant_build", true,
			"dome_forbidden", true,
			"display_name", [[Bottomless Storage]],
			"display_name_pl", [[Bottomless Storage]],
			"description", [[Warning: Anything added to this depot will disappear.]],
			"build_category","ChoGGi",
			"Group", "ChoGGi",
			"display_icon", CurrentModPath .. "UI/bottomless_storage.png",
			"entity", "ResourcePlatform",
			"on_off_button", false,
			"prio_button", false,
			"count_as_building", false,
			"switch_fill_order", false,
			"fill_group_idx", 9,
		})
	end
end --ClassesPostprocess
