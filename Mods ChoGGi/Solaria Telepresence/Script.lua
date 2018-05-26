function OnMsg.ClassesGenerate()
  DefineClass.Solaria = {
    __parents = {
      "ElectricityConsumer",
      "Workplace",
      "InteriorAmbientLife",
    },
    --anim inside
    interior = {"ResearchLabInterior"},
    spots = {"Terminal"},
    anims = {{anim = "terminal",all = true}},

    --production is workers * (prod.base_production_per_day / 4)
    --how much performance does each worker add? this'll add bonus prod on top
    perf_per_viewer = 12.5,
    --stores table of controlled obj, handle and worker amount
    ChoGGiX_Remote_Controller = false,
  }

  function Solaria:GameInit()
    Workplace.GameInit(self)
    --always leave it turned off, so it doesn't use resources till user turns it on
    self:ToggleWorking()
    --brown/yellow seems a good choice for a vr workplace
    self:SetColor1(-10991554)
    self:SetColor2(-7963804)
    self:SetColor3(-10263981)
    --it's a workplace after all
    self:DestroyAttaches("VRWorkshopHologram")
    self:DestroyAttaches("DecorInt_02")
    local att = self:GetAttaches()
    for i = 1, #att do
      if att[i].class:find("Door") then
        att[i]:SetColorModifier(1)
      end
    end
  end

  --build and show a list of viable buildings
  function Solaria:ListBuildings(Which)
  --maybe add Solaria to top of list for ease of ViewPos back
    local ChoGGiX = ChoGGiX
    local Table = UICity.labels.OutsideBuildings
    local hint = "Double-click to " .. Which .. " remote control. Double-right click to view the building."
    local ItemList = {}

    --show list to add controller
    if Which == "activate" then
      --remove any we already control
      Table = FilterObjects({
        filter = function(Obj)
          if not Obj.ChoGGiX_Remote_Controlled then
            return Obj
          end
        end
      },Table)

      --filter list to the types we want
      Table = ChoGGiX.ComFuncs.FilterFromTable(
        Table,
        nil,
        {DroneFactory=true,FungalFarm=true,FusionReactor=true,MetalsExtractor=true,PolymerPlant=true,PreciousMetalsExtractor=true},
        "class"
      )
    --show controlled for remove list
    elseif Which == "remove" then
      hint = hint .. "\n\nYou can remove control by either the building or the controlling Solaria."
      Table = FilterObjects({
        filter = function(Obj)
          if Obj.ChoGGiX_Remote_Controlled then
            return Obj
          end
        end
      },Table)
    end

    --make it pretty
    for i = 1, #Table do
      local pos = Table[i]:GetVisualPos()
      ItemList[#ItemList+1] = {
        text = self:BuildingName(Table[i]),
        value = Table[i].handle, --probably don't need it...
        obj = Table[i], --same
        hint = pos, --something to provide a slight reference
        func = pos, --for ViewPos func
      }
    end

    --if list is empty that means no controlled buildings so return (msg as well?)
    if #ItemList == 0 then
      return
    end

    --add controller for ease of movement
    ItemList[#ItemList+1] = {
      text = " Solaria",
      value = self.handle,
      obj = self,
      hint = "Solaria building",
      func = self:GetVisualPos(),
    }

    --callback
    local CallBackFunc = function(choice)
      local Obj = choice[1].obj
      if Obj.handle ~= self.handle and IsValid(Obj) then
        if Which == "activate" then
          self:AttachBuilding(Obj)
        elseif Which == "remove" then
          self:RemoveBuilding(Obj)
        end
      end
    end

    --CustomType=6 : same as 3, but dbl rightclick executes CustomFunc(selecteditem.func)
    ChoGGiX.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Solaria Telepresence","Current: " .. hint,nil,nil,nil,nil,nil,6,ViewPos)
  end

  --Obj bld being controlled, self = controller
  function Solaria:BuildingName(Obj)
    return ChoGGiX.CodeFuncs.Trans(Obj.display_name) or Obj.encyclopedia_id or Obj.class
  end

  function Solaria:AttachBuilding(Obj)
    if not IsValid(Obj) or Obj.handle == self.handle then
      return
    end

    --setup controller
    self.ChoGGiX_Remote_Controller = {
		  building = Obj,
		  handle = Obj.handle,
		  workers = Obj.max_workers,
    }
    self.max_workers = Obj.max_workers

    --controlled
		Obj.ChoGGiX_Remote_Controlled = self
    --needed for not needing any workers
    Obj.max_workers = 0
    Obj.automation = 1
    --lower base prod to 0 (no workers no prod
    Obj:GetProducerObj().production_per_day = 0

    --turn them on if off
    RebuildInfopanel(self)
    self:SetUIWorking(true)
    Obj:SetUIWorking(true)


    ChoGGiX.ComFuncs.MsgPopup("Telepresence Viewing: " .. self:BuildingName(Obj) .. " pos: " .. tostring(Obj:GetVisualPos()),
      "Solaria","UI/Icons/Upgrades/holographic_scanner_04.tga"
    )
  end

  function Solaria:RemoveBuilding(Obj)
    if not IsValid(Obj) or Obj.handle == self.handle then
      return
    end
    --update Solaria
    self.ChoGGiX_Remote_Controller = false
    self.max_workers = nil
    if self.working then
      self:ToggleWorking()
    end
    --update controlled building
		Obj.ChoGGiX_Remote_Controlled = nil
    Obj.production_per_day = nil
    local prod = Obj:GetProducerObj()
    prod.production_per_day = prod.base_production_per_day
    Obj.max_workers = nil
    Obj.automation = nil
    Obj.auto_performance = nil

    ChoGGiX.ComFuncs.MsgPopup("Telepresence Removed: " .. self:BuildingName(Obj) .. " pos: " .. tostring(Obj:GetVisualPos()),
      "Solaria","UI/Icons/Upgrades/holographic_scanner_03.tga"
    )
  end

  --update performance on controlled building (fires when worker starts work)
  function Solaria:StartWorkCycle(unit)
    Workplace.StartWorkCycle(self, unit)
    --only update if Solaria is controlling a building
    if self.ChoGGiX_Remote_Controller then
      local Obj = self.ChoGGiX_Remote_Controller.building
      --controlled building was removed
      if not IsValid(Obj) then
        self.ChoGGiX_Remote_Controller = false
        self.max_workers = nil
        return
      end
      --get amount of workers for shifts
      local shift = self.current_shift
      --if shift is closed then 0
      local workers = 0
      if not self.closed_shifts[shift] then
        workers = #self.workers[shift]
        --amount of workers * perf_per_viewer = amount of perf (even idiots can do this job, make a filter for only idiots?)
        Obj.auto_performance = workers * self.perf_per_viewer
      else
        Obj.auto_performance = 0
      end
      local prod = Obj:GetProducerObj()
      prod.production_per_day = workers * (prod.base_production_per_day / 4)
    --turn off Solaria if it isn't controlling
    elseif self.working then
      self:ToggleWorking()
    end
  end

end --ClassesGenerate

function OnMsg.ClassesPostprocess()
  --add building to building template list
  PlaceObj('BuildingTemplate', {
    'name', "Solaria",
    'template_class', "Solaria",
    'construction_cost_Concrete', 40000,
    'construction_cost_Electronics', 10000,
    'build_points', 8000,
    'dome_required', true,
    'maintenance_resource_type', "Concrete",
    'consumption_resource_type', "Electronics",
    'consumption_max_storage', 6000,
    'consumption_amount', 1500,
    'consumption_type', 4,
    'display_name', "Solaria Telepresence",
    'display_name_pl', "Solaria Telepresence",
    'description', "A telepresence VR building, remote control factories and mines (with reduced production).\nWorker amount is dependent on controlled building.\n\nTelepresence control may take up to a shift to propagate to controlled building.",
    'build_category', "Dome Services",
    'display_icon', ChoGGiX.ModPath .. "/SolariaTelepresence.tga",
    'build_pos', 12,
    --'encyclopedia_image', "UI/Encyclopedia/VRWorkshop.tga",
    'label1', "InsideBuildings",
    --'label2', "Workshop",
    'entity', "VRWorkshop",
    'palettes', "VRWorkshop",
    'demolish_sinking', range(5, 10),
    'demolish_debris', 80,
    'electricity_consumption', 25000,
    --'enabled_shift_1', false,
    --'enabled_shift_3', false,
    'max_workers', 0, --changed when controlled
  })

end --ClassesPostprocess

function OnMsg.ClassesBuilt()
  local ChoGGiX = ChoGGiX
  local XT = XTemplates
  local ObjModified = ObjModified
  XT = XT or XTemplates

  if not XT.sectionWorkplace.ChoGGiX_Solaria then
    XT.sectionWorkplace.ChoGGiX_Solaria = true
    XT.sectionWorkplace[#XT.sectionWorkplace+1] = PlaceObj("XTemplateTemplate", {
      "__context_of_kind", "Solaria",
      "__template", "InfopanelActiveSection",
      "Icon", "UI/Icons/Upgrades/factory_ai_02.tga",
      "Title", "Control Building",
      "RolloverText", "Shows list of buildings for telepresence viewing.\nDouble-click to enable remote control with this building, Double-right to view.",
      "RolloverTitle", "Info",
      "RolloverHint",  "<left_click> Toggle setting",
      "OnContextUpdate", function(self, context)
        ---
        if context.ChoGGiX_Remote_Controller then
          self:SetTitle("Remove Controller")
          self:SetIcon("UI/Icons/Upgrades/factory_ai_03.tga")
        else
          self:SetTitle("Control Building")
          self:SetIcon("UI/Icons/Upgrades/factory_ai_01.tga")
        end
        ---
      end,
    }, {
      PlaceObj("XTemplateFunc", {
        "name", "OnActivate(self, context)",
        "parent", function(parent, context)
          return parent.parent
        end,
        "func", function(self, context)
          ---
          if not context.ChoGGiX_Remote_Controller then
            context:ListBuildings("activate")
          else
            local building = context.ChoGGiX_Remote_Controller.building
            local CallBackFunc = function()
              context:RemoveBuilding(building)
            end
            ChoGGiX.ComFuncs.QuestionBox(
              "Are you sure you want to remove telepresence viewing from " .. ChoGGiX.CodeFuncs.Trans(building.display_name),
              CallBackFunc,
              "Solaria Telepresence"
            )
          end
          ---
          ObjModified(context)
        end
      })
    })

    --list controlled buildings
    XT.sectionWorkplace[#XT.sectionWorkplace+1] = PlaceObj("XTemplateTemplate", {
      "__context_of_kind", "Solaria",
      "__template", "InfopanelActiveSection",
      "Icon", "UI/Icons/Upgrades/build_2.tga",
      "Title", "Attached Buildings",
      "RolloverText", "Shows list of all controlled buildings (for removing telepresence control).\nDouble-right to view.",
      "RolloverTitle", "Info",
      "RolloverHint",  "<left_click> Remove telepresence",
    }, {
      PlaceObj("XTemplateFunc", {
        "name", "OnActivate(self, context)",
        "parent", function(parent, context)
          return parent.parent
        end,
        "func", function(self, context)
          context:ListBuildings("remove")
          ObjModified(context)
        end
      })
    })

    --goto controlled building
    XT.sectionWorkplace[#XT.sectionWorkplace+1] = PlaceObj("XTemplateTemplate", {
      "__context_of_kind", "Solaria",
      "__template", "InfopanelActiveSection",
      "Icon", "UI/Icons/Anomaly_Event.tga",
      "Title", "See Controlled Building",
      "RolloverText", "Moves camera to controlled building.",
      "RolloverTitle", "Info",
      "RolloverHint",  "<left_click> Viewing",
    }, {
      PlaceObj("XTemplateFunc", {
        "name", "OnActivate(self, context)",
        "parent", function(parent, context)
          return parent.parent
        end,
        "func", function(self, context)
          local con = context.ChoGGiX_Remote_Controller
          if con then
            ViewPos(con.building:GetVisualPos())
          else
            ChoGGiX.ComFuncs.MsgPopup("Nothing to view.","Solaria")
          end
        end
      })
    })

  end

end --ClassesBuilt




