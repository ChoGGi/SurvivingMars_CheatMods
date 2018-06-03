function OnMsg.ClassesGenerate()
  DefineClass.BottomlessStorage = {
    __parents = {
      "UniversalStorageDepot"
    },
  }

  function BottomlessStorage:GameInit()
    --fire off the usual GameInit
    UniversalStorageDepot.GameInit(self)
    --and start off with all resource demands blocked
    for i = 1, #self.resource do
      self:ToggleAcceptResource(self.resource[i])
    end
    --figure out why the info panel takes so long to update?

    --make sure it isn't mistaken for a regular depot
    self:SetColorModifier(0)
  end

  --om nom nom nom nom
  function BottomlessStorage:DroneUnloadResource(drone, request, resource, amount)
    ResourceStockpileBase.DroneUnloadResource(self, drone, request, resource, amount)
    self:ClearAllResources()
    RebuildInfopanel(self)
  end

end

--add building to building template list
function OnMsg.ClassesPostprocess()
  PlaceObj("BuildingTemplate", {
    "name", "BottomlessStorage",
    "template_class", "BottomlessStorage",
    "instant_build", true,
    "dome_forbidden", true,
    "display_name", "Bottomless Depot",
    "display_name_pl", "Bottomless Depot",
    "description", T{5305, --[[BuildingTemplate UniversalStorageDepot description]] "Stores <resource(max_storage_per_resource)> units of each transportable resource. Some resources will be transported to other depots within Drone range."},
    "build_category", "Storages",
    --"display_icon", "UI/Icons/Buildings/universal_storage.tga",
    "display_icon", Mods.ChoGGi_BottomlessStorage.path .. "/universal_storage.tga",
    "entity", "StorageDepot",
    "on_off_button", false,
    "prio_button", false,
    "count_as_building", false,
    "switch_fill_order", false,
    "fill_group_idx", 9,
  })
end --ClassesPostprocess
