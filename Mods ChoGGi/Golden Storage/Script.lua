DefineClass.GoldenStorage = {
  __parents = {
    "UniversalStorageDepot"
  },
  metals_thread = false,
  max_z = 1,
}

function GoldenStorage:GameInit()
  --fire off the usual GameInit
  UniversalStorageDepot.GameInit(self)
  --and start off with all resource demands blocked
  for i = 1, #self.resource do
    if self.resource[i] ~= "Metals" then
      self:ToggleAcceptResource(self.resource[i],true)
    end
  end


  --figure out why the info panel takes so long to update?

  --make sure it isn't mistaken for a regular depot
  self:SetColorModifier(-6262526)

  self.metals_thread = CreateGameTimeThread(function()
    while IsValid(self) and not self.destroyed do

      local storedM = self:GetStored_Metals()
      local maxM = self:GetMaxAmount_Metals()
      local storedP = self:GetStored_PreciousMetals()
      local maxP = self:GetMaxAmount_PreciousMetals()
      --we need at least 10
      if storedM >= 10000 and maxP - storedP > 1000 then
        local new_amount = (storedM - 10000)

        self.supply.Metals:SetAmount(new_amount)
        self.demand.Metals:SetAmount(maxM - new_amount)
        self.stockpiled_amount.Metals = new_amount
        self:SetCount(new_amount, "Metals")

        self:AddResource(1000, "PreciousMetals")

        --PlayFX("MeteorExplosion", "start", self)

        RebuildInfopanel(self)
      else
        self.supply.Metals:SetAmount(storedM)
        self.demand.Metals:SetAmount(maxM - storedM)
        self.stockpiled_amount.Metals = storedM
        self:SetCount(storedM, "Metals")
        self.stockpiled_amount.PreciousMetals = storedP
        self:SetCount(storedP, "PreciousMetals")
      end

      Sleep(5000)
    end
  end)
end

--only allowed to toggle metals
function GoldenStorage:ToggleAcceptResource(res,startup)
  if not startup and res ~= "Metals" then
    return
  end
  UniversalStorageDepot.ToggleAcceptResource(self, res)
end

function GoldenStorage:Done()
  UniversalStorageDepot.Done(self)
  if IsValidThread(self.metals_thread) then
    DeleteThread(self.metals_thread)
  end
end

--add building to building template list
function OnMsg.ClassesPostprocess()
  PlaceObj("BuildingTemplate", {
    "Id", "GoldenStorage",
    "Group", "Storages",
    "template_class", "GoldenStorage",
    "instant_build", true,
    "dome_forbidden", true,
    "display_name", [[Golden Storage]],
    "display_name_pl", [[Golden Storage]],
    "description", [[Converts Metals to PreciousMetals.]],
    "build_category", "Storages",
    "display_icon", string.format("%suniversal_storage.tga",CurrentModPath),
    "entity", "ResourcePlatform",
    "on_off_button", false,
    "prio_button", false,
    "count_as_building", false,
    "switch_fill_order", false,
    "fill_group_idx", 9,
  })
end --ClassesPostprocess
