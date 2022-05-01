-- See LICENSE for terms

local RetObjMapId = ChoGGi.ComFuncs.RetObjMapId

local ResourceScale = const.ResourceScale
local resources
local mod_options = {}

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions
	for i = 1, #(resources or "") do
		local id = resources[i]
		mod_options[id] = options:GetProperty("MinResourceAmount_" .. id)
	end

end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

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

	self.placement_offset = point30
end

-- om nom nom nom nom
--~ function BottomlessStorage:DroneUnloadResource(drone, request, resource, amount, ...)
function BottomlessStorage:DroneUnloadResource(drone, request, resource, ...)
	UniversalStorageDepot.DroneUnloadResource(self, drone, request, resource, ...)
	if self.working then
		-- check and clear each resource that can be cleared
		if g_ResourceOverviewCity[RetObjMapId(self)]:GetAvailable(resource) > mod_options[resource] * ResourceScale then
			-- function UniversalStorageDepot:ClearAllResources()
			if self.supply and self.supply[resource] then
				self.supply[resource]:SetAmount(0)
				self.demand[resource]:SetAmount(self.max_storage_per_resource)
				self.stockpiled_amount[resource] = 0
				self:SetCount(0, resource)
			end
		end

		-- update selection panel
		RebuildInfopanel(self)
	end
end

-- prevent log spam
local safe_spots = {
	Box1 = true,
	Box2 = true,
	Box3 = true,
	Box4 = true,
	Box5 = true,
	Box6 = true,
	Box7 = true,
	Box8 = true,
}
function BottomlessStorage:GetSpotBeginIndex(spot_name, ...)
	if spot_name:sub(1, 3) == "Box" and not safe_spots[spot_name] then
		spot_name = "Box8"
	end
	return UniversalStorageDepot.GetSpotBeginIndex(self, spot_name, ...)
end

-- add building to building template list
function OnMsg.ClassesPostprocess()
	resources = table.icopy(UniversalStorageDepot.storable_resources)
	resources[#resources+1] = "WasteRock"
	if g_AvailableDlc.armstrong and not table.find(resources, "Seeds") then
		resources[#resources+1] = "Seeds"
	end

	if not BuildingTemplates.BottomlessStorage then
		PlaceObj("BuildingTemplate", {

		-- added, not uploaded
		"disabled_in_environment1", "",
		"disabled_in_environment2", "",
		"disabled_in_environment3", "",
		"disabled_in_environment4", "",

			"Id", "BottomlessStorage",
			"template_class", "BottomlessStorage",
			"instant_build", true,
			"display_name", T(302535920011047, "Bottomless Storage"),
			"display_name_pl", T(302535920011048, "Bottomless Storages"),
			"description", T(302535920011049, "Warning: Anything added to this depot will disappear."),
			"build_category", "ChoGGi",
			"Group", "ChoGGi",
			"display_icon", CurrentModPath .. "UI/bottomless_storage.png",
			"entity", "ResourcePlatform",
			"count_as_building", false,
			"storable_resources", resources,
			"resource", resources,
			"max_storage_per_resource", 250000,
		})
	end

	local xtemplate = XTemplates.sectionStorage[2]
	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_WasteRockToggle", true)

	-- add wasterock toggle to depot resource list
	xtemplate[#xtemplate+1] = PlaceObj('XTemplateTemplate', {
		"Id" , "ChoGGi_Template_WasteRockToggle",
		"ChoGGi_Template_WasteRockToggle", true,
		"__context", function (_, context)
      return SubContext(context, {res = "WasteRock"})
    end,
		"__template", "sectionStorageRow",
		"Title", T(615073837286, "<resource(res)><right><resource(GetStoredAmount(res),GetMaxStorage(res),res)>"),
		"Icon", "UI/Icons/Sections/workshifts_active.tga",
		"TitleHAlign", "stretch",
	})

end
