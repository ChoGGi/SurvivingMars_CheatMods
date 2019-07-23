-- See LICENSE for terms

DefineClass.BottomlessStorage = {
	__parents = {
		"UniversalStorageDepot",
	},
}

function BottomlessStorage:GameInit()
	-- start off with all resource demands blocked
	for i = 1, #self.resource do
		self:ToggleAcceptResource(self.resource[i])
	end

	-- turn off shuttles
	StorageDepot.SetLRTService(self, false)

	-- make sure it isn't mistaken for a regular depot
	self:SetColorModifier(0)
end

-- om nom nom nom nom
--~ function BottomlessStorage:DroneUnloadResource(drone, request, resource, amount, ...)
function BottomlessStorage:DroneUnloadResource(...)
	UniversalStorageDepot.DroneUnloadResource(self, ...)
	if self.working then
		self:ClearAllResources()
		RebuildInfopanel(self)
	end
end

-- prevent log spam
function BottomlessStorage:GetSpotBeginIndex(spot_name, ...)
	return UniversalStorageDepot.GetSpotBeginIndex(
		self, spot_name == "Box9" and "Box8" or spot_name, ...
	)
end

-- add building to building template list
function OnMsg.ClassesPostprocess()
	if BuildingTemplates.BottomlessStorage then
		return
	end

	local storable_resources = table.icopy(UniversalStorageDepot.storable_resources)
	if not table.find(storable_resources, "Seeds") then
		storable_resources[#storable_resources+1] = "Seeds"
	end

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
		"on_off_button", true,
		"prio_button", false,
		"count_as_building", false,
		"storable_resources", storable_resources,
		"resource", storable_resources,
	})
end
