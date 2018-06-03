function OnMsg.ClassesGenerate()
  DefineClass.Carwash = {
    __parents = {
      "Building",
      "ElectricityConsumer",
      "LifeSupportConsumer",
      "InteriorAmbientLife",
      --"LifeSupportGridObject",

      "OutsideBuildingWithShifts",

      "ColdSensitive",
    },

    --stuff from water tanks
    building_update_time = 10000,

    --stuff from farm
    properties = {
      { template = true, id = "water_consumption", name = T{656, "Water consumption"},  category = "Consumption", editor = "number", default = 0, scale = const.ResourceScale, read_only = true, modifiable = true },
      { template = true, id = "air_consumption",   name = T{657, "Oxygen Consumption"}, category = "Consumption", editor = "number", default = 0, scale = const.ResourceScale, read_only = true, modifiable = true },
    },
    interior = {"HydroponicFarmElevator"},
    spots = {"Terminal"},
    anims = {{anim = "terminal",all = true}},
    --convent farm
    anim_thread = false,
    is_up = false,
    nearby_thread = false,
  }

  function Carwash:GameInit()
    FarmConventional.StartAnimThread(self)

    local Sleep = Sleep
    local IsValid = IsValid
    local NearestObject = NearestObject
    local GetObjects = GetObjects
    local const = const
    local obj
    self.nearby_thread = CreateGameTimeThread(function()
      while IsValid(self) and not self.destroyed do
        if self.working then
          obj = nil
          --check for anyone on the "tarmac"
          obj = NearestObject(self:GetVisualPos(),GetObjects({class="Unit"}),1000)
          --if so clean them
          if obj then
            obj:SetDust(0, const.DustMaterialExterior)
          end
        end

        Sleep(1000)
      end
    end)


    --make it look like not farm colours
    self:SetColorModifier(0)

    --remove the lights/etc
    local att = self:GetAttaches() or empty_table
    for i = 1, #att do
      if att[i].class == "DecorInt_10" or att[i].class == "LampInt_04" then
        DoneObject(att[i])
      end
    end
    --so we can drive over it
    self:ClearEnumFlags(const.efCollision + const.efApplyToGrids)
  end

  function Carwash:OnSetWorking(working)
    OutsideBuildingWithShifts.OnSetWorking(self, working)
    ElectricityConsumer.OnSetWorking(self, working)

    if IsValidThread(self.anim_thread) then
      Wakeup(self.anim_thread)
    end
    if IsValidThread(self.nearby_thread) then
      Wakeup(self.nearby_thread)
    end
  end

  function Carwash:UpdateAttachedSigns()
    ElectricityConsumer.UpdateAttachedSigns(self)
    --LifeSupportConsumer.UpdateAttachedSigns(self)
  end

  function Carwash:Done()
    FarmConventional.Done(self)
    if IsValidThread(self.nearby_thread) then
      DeleteThread(self.nearby_thread)
    end
  end

end

--add building to building template list
function OnMsg.ClassesPostprocess()

  PlaceObj("BuildingTemplate", {
    "name", "Carwash",
    "template_class", "Carwash",
    "dome_forbidden", true,
    "display_name", "Martian Carwash",
    "display_name_pl", "Martian Carwash",
    "description", "Working at the car wash\nWorking at the car wash, yeah\nCome on and sing it with me, car wash\nSing it with the feeling now, car wash, yeah",
    "build_category", "Wonders", --oh it's wonderful, be even more wonderful if I could figure out how to add a pipe connection, and have it suck up water
    "display_icon", Mods.ChoGGi_MartianCarwash.path .. "/carwash.tga",
    "entity", "Farm",
    "electricity_consumption", 2500,
    "water_consumption", 0,
    "air_consumption", 0,
    "construction_cost_Concrete", 20000,
    "construction_cost_Metals", 15000,
    "construction_cost_Electronics", 1000,
    "construction_cost_Polymers", 1000,
    "maintenance_resource_type", "Metals",
    "maintenance_resource_amount", 1000,
  })

end --ClassesPostprocess
