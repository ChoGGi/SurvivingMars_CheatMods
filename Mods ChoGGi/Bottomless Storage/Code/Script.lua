-- See LICENSE for terms

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
			"display_name", T(302535920011047, [[Bottomless Storage]]),
			"display_name_pl", T(302535920011048, [[Bottomless Storages]]),
			"description", T(302535920011049, [[Warning: Anything added to this depot will disappear.]]),
			"build_category", "ChoGGi",
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
