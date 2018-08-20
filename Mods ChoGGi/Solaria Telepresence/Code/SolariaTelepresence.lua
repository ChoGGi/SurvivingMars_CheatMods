--See LICENSE for terms

local Concat = SolariaTelepresence.ComFuncs.Concat
local PopupToggle = SolariaTelepresence.ComFuncs.PopupToggle
local RetName = SolariaTelepresence.ComFuncs.RetName
local FilterFromTable = SolariaTelepresence.ComFuncs.FilterFromTable
local MsgPopup = SolariaTelepresence.ComFuncs.MsgPopup

local type,tostring,pcall,string = type,tostring,pcall,string

local DebugPrint = DebugPrint
local OnMsg = OnMsg
local FilterObjects = FilterObjects
local IsValid = IsValid
local RebuildInfopanel = RebuildInfopanel
local XTemplates = XTemplates
local ObjModified = ObjModified
local PlaceObj = PlaceObj
local ViewPos = ViewPos
local SelectObj = SelectObj

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
  SolariaTelepresence_Remote_Controller = false,
}

local g_Classes = g_Classes

function Solaria:GameInit()
  g_Classes.Workplace.GameInit(self)
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
local filter_table = {DroneFactory=true,FungalFarm=true,FusionReactor=true,MetalsExtractor=true,PreciousMetalsExtractor=true}
local function ClickObj(self,obj,button,which)
  if button == "R" then
    ViewPos(obj:GetVisualPos())
  else
    if obj.handle ~= self.handle and IsValid(obj) then
      if which == "activate" then
        self:AttachBuilding(obj)
      elseif which == "remove" then
        self:RemoveBuilding(obj)
      end
    end
  end
end

function Solaria:ListBuildings(which,parent)
  local Table = UICity.labels.OutsideBuildings or empty_table
  local hint = [[

Right click to view selected list item building.]]
  local ItemList = {}

  --show list to add controller
  if which == "activate" then
    hint = Concat([[Click to remotely control building.]],hint)
    --remove any we already control
    Table = FilterObjects({
      filter = function(Obj)
        if not Obj.SolariaTelepresence_Remote_Controlled then
          return Obj
        end
      end
    },Table)

    --filter list to the types we want
    Table = FilterFromTable(
      Table,
      nil,
      filter_table,
      "class"
    )
  --show controlled for remove list
  elseif which == "remove" then
    hint = Concat([[Click to remove control of building.]],hint)
    Table = FilterObjects({
      filter = function(Obj)
        if Obj.SolariaTelepresence_Remote_Controlled then
          return Obj
        end
      end
    },Table)
  end

  --make it pretty
  for i = 1, #Table do
    local obj = Table[i]
    local pos = obj:GetVisualPos()
    ItemList[#ItemList+1] = {
      pos = pos,
      name = RetName(obj),
      class = "XTextButton",
      hint = Concat(hint," at pos: ",pos), --something to provide a slight reference
      clicked = function(_,_,button)
        ClickObj(self,obj,button,which)
      end,
    }
  end

  --if list is empty that means no controlled/able buildings so return
  if #ItemList == 0 then
    MsgPopup([[Nothing to control.]],
      [[Solaria]],"UI/Icons/Upgrades/holographic_scanner_04.tga"
    )
    return
  end

  --add controller for ease of movement
  ItemList[#ItemList+1] = {
    name = [[ Solaria Controller]],
    pos = self:GetVisualPos(),
--~     value = self.handle,
--~     obj = self,
    class = "XTextButton",
    hint = [[Solaria control building.
You can't remove... Only view (or maybe See would be a better term).]],
    clicked = function(_,_,button)
      ClickObj(self,obj,button,which)
    end,
--~     func = self,
  }

  local popup = rawget(terminal.desktop, "idSolariaTelepresenceMenu")
  if popup then
    popup:Close()
  else
    PopupToggle(parent,"idSolariaTelepresenceMenu",ItemList)
  end

end

function Solaria:AttachBuilding(Obj)
  if not IsValid(Obj) or Obj.handle == self.handle then
    return
  end
  local UICity = UICity
  UICity.SolariaTelepresence_RemoteControlledBuildings = UICity.SolariaTelepresence_RemoteControlledBuildings + 1

  --setup controller
  self.SolariaTelepresence_Remote_Controller = {
    building = Obj,
    handle = Obj.handle,
    workers = Obj.max_workers
  }
  self.max_workers = Obj.max_workers

  --controlled
  Obj.SolariaTelepresence_Remote_Controlled = self
  --needed for not needing any workers
  Obj.max_workers = 0
  Obj.automation = 1

  --lower base prod to 0 (no workers no prod
  if type(Obj.GetProducerObj) == "function" then
    Obj:GetProducerObj().production_per_day = 0
  elseif Obj.electricity.production then
    Obj.electricity.production = 0
  end

  --turn them on if off
  RebuildInfopanel(self)
  self:SetUIWorking(true)
  Obj:SetUIWorking(true)

  MsgPopup(string.format([[Viewing: %s Pos: %s]],RetName(Obj),tostring(Obj:GetVisualPos())),
    [[Solaria]],"UI/Icons/Upgrades/holographic_scanner_04.tga"
  )
end

function Solaria:RemoveBuilding(Obj)
  if Obj.handle == self.handle then
    return
  end

  local UICity = UICity

  Obj = Obj or self.SolariaTelepresence_Remote_Controller.building
  --update Solaria
  self.SolariaTelepresence_Remote_Controller = false
  self.max_workers = nil
  if self.working then
    self:ToggleWorking()
  end

  pcall(function()
    --this shouldn't happen as RemoveBuilding gets called when buildings are removed
    DebugPrintNL([[Solaria Telepresence Error: Controlled building was removed without removing control.]])
    --update controlled building
    Obj.SolariaTelepresence_Remote_Controlled = nil
    Obj.production_per_day = nil

    if type(Obj.GetProducerObj) == "function" then
      local prod = Obj:GetProducerObj()
      prod.production_per_day = prod.base_production_per_day
    elseif Obj.electricity.production then
      Obj.electricity.production = Obj.base_electricity_production
    end

    Obj.max_workers = nil
    Obj.automation = nil
    Obj.auto_performance = nil
  end)

  UICity.SolariaTelepresence_RemoteControlledBuildings = UICity.SolariaTelepresence_RemoteControlledBuildings - 1

  MsgPopup(string.format([[Removed: %s Pos: %s]],RetName(Obj),tostring(Obj:GetVisualPos())),
    [[Solaria]],"UI/Icons/Upgrades/holographic_scanner_03.tga"
  )
end

--update performance on controlled building (fires when worker starts work)
function Solaria:StartWorkCycle(unit)
  g_Classes.Workplace.StartWorkCycle(self, unit)
  --only update if Solaria is controlling a building
  if self.SolariaTelepresence_Remote_Controller then
    local Obj = self.SolariaTelepresence_Remote_Controller.building
    --controlled building was removed
    if not IsValid(Obj) then
      self.SolariaTelepresence_Remote_Controller = false
      self.max_workers = nil
      return
    end

    --get amount of workers for shifts
    local shift = self.current_shift
    --if shift is closed then 0
    local workers = 0
    --toggle Solaria shift based on controlled building
    if Obj.closed_shifts[shift] then
      self.closed_shifts[shift] = true
    else
      self.closed_shifts[shift] = false
    end
    --update perf for controlled
    if not self.closed_shifts[shift] then
      workers = #self.workers[shift]
      --amount of workers * perf_per_viewer = amount of perf (even idiots can do this job, make a filter for only idiots?)
      Obj.auto_performance = workers * self.perf_per_viewer
    else
      --no workers no perf
      Obj.auto_performance = 0
    end
    --update prod
    if type(Obj.GetProducerObj) == "function" then
      local prod = Obj:GetProducerObj()
      prod.production_per_day = workers * (prod.base_production_per_day / 4)
    elseif Obj.electricity.production then
      Obj.electricity.production = workers * (Obj.base_electricity_production / 4)
    end

  --turn off Solaria if it isn't controlling
  elseif self.working then
    self:ToggleWorking()
  end
end

function OnMsg.ClassesGenerate()
  local g_Classes = g_Classes

  local g_Classes_Workplace_OnDestroyed = g_Classes.Workplace.OnDestroyed
  function g_Classes.Workplace:OnDestroyed()
    if self.SolariaTelepresence_Remote_Controlled then
      self:RemoveBuilding()
    end
    g_Classes_Workplace_OnDestroyed(self)
  end

end

function OnMsg.ClassesPostprocess()
  --add building to building template list
  PlaceObj("BuildingTemplate", {
    "Id", "Solaria",
    "template_class", "Solaria",
    "construction_cost_Concrete", 40000,
    "construction_cost_Electronics", 10000,
    "build_points", 10000,
    "dome_required", true,
    "maintenance_resource_type", "Concrete",
    "consumption_resource_type", "Electronics",
    "consumption_max_storage", 6000,
    "consumption_amount", 1500,
    "consumption_type", 4,
    "display_name", [[Solaria Telepresence]],
    "display_name_pl", [[Solaria Telepresence]],
    "description", [[A telepresence VR building, remote control factories and mines (with reduced production).
Worker amount is dependent on controlled building.

Telepresence control may take up to a shift to propagate to controlled building.]],
    "Group", "Dome Services",
    "build_category", "Dome Services",
    "display_icon", Concat(SolariaTelepresence.ModPath,"/TheIncal.tga"),
    "build_pos", 12,
    "label1", "InsideBuildings",
    "label2", "Workshop",
    "entity", "VRWorkshop",
    "palettes", "VRWorkshop",
    "demolish_sinking", range(5, 10),
    "demolish_debris", 80,
    "electricity_consumption", 15000,
    "max_workers", 0, --changed when controlling
  })

  PlaceObj("TechPreset", {
    SortKey = 11,
    description = T{0,[[New Building: <em>Solaria</em> (<buildinginfo('Solaria')>) - a building that allows colonists to remote control production buildings. Consumes Electronics.

<grey>"How do you know it's Sci-Fi? VR is commercially viable."
<right>Shams Jorjani</grey><left>]]},
    display_name = [[Creative Realities Solaria]],
    group = "Physics",
    icon = "UI/Icons/Research/creative_realities.tga",
    id = "CreativeRealitiesSolaria",
    position = range(11, 14),
    PlaceObj("Effect_TechUnlockBuilding", {
      Building = "Solaria",
      HideBuilding = true,
    }),
  })

end --ClassesPostprocess

function OnMsg.ClassesBuilt()

  if not XTemplates.sectionWorkplace.SolariaTelepresence_Solaria then
    XTemplates.sectionWorkplace.SolariaTelepresence_Solaria = true

    XTemplates.sectionWorkplace[#XTemplates.sectionWorkplace+1] = PlaceObj("XTemplateTemplate", {
      "SolariaTelepresence_sectionWorkplace1", true,
      "__context_of_kind", "Solaria",
      "__template", "InfopanelActiveSection",
      "Icon", "",
      "Title", "",
      "RolloverText", "",
      "RolloverTitle", [[Telepresence]],
      "RolloverHint",  "",
      "OnContextUpdate", function(self, context)
        ---
        if context.SolariaTelepresence_Remote_Controller then
          self:SetRolloverText([[Remove the control of outside building from this building.]])
          self:SetTitle([[Remove Remote Control]])
          self:SetIcon("UI/Icons/Upgrades/factory_ai_03.tga")
        else
          self:SetRolloverText([[Shows list of buildings for telepresence control.

Right click in list to view (closes menu).]])
          self:SetTitle([[Remote Control Building]])
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
          if not context.SolariaTelepresence_Remote_Controller then
            context:ListBuildings("activate",self)
          else
            local building = context.SolariaTelepresence_Remote_Controller.building
            local CallBackFunc = function()
              context:RemoveBuilding(building)
            end
            SolariaTelepresence.ComFuncs.QuestionBox(
              string.format([[Are you sure you want to remove telepresence viewing from %s located at %s]],RetName(building),tostring(building:GetVisualPos())),
              CallBackFunc,
              [[Solaria Telepresence]]
            )
          end
          ---
          ObjModified(context)
        end
      })
    })

    --list controlled buildings
    XTemplates.sectionWorkplace[#XTemplates.sectionWorkplace+1] = PlaceObj("XTemplateTemplate", {
      "SolariaTelepresence_sectionWorkplace2", true,
      "__context_of_kind", "Solaria",
      "__template", "InfopanelActiveSection",
      "Icon", "UI/Icons/Upgrades/build_2.tga",
      "Title", [[All Attached Buildings]],
      "RolloverText", [[Shows list of all controlled buildings (for removal of telepresence control).

Right click list item to view (closes menu).]],
      "RolloverTitle", [[Telepresence]],
      "RolloverHint",  [[<left_click> Remove telepresence]],
      "OnContextUpdate", function(self, context)
        if UICity.SolariaTelepresence_RemoteControlledBuildings > 0 then
          self:SetVisible(true)
          self:SetMaxHeight()
        else
          self:SetVisible(false)
          self:SetMaxHeight(0)
        end
      end,
    }, {
      PlaceObj("XTemplateFunc", {
        "name", "OnActivate(self, context)",
        "parent", function(parent, context)
          return parent.parent
        end,
        "func", function(self, context)
          context:ListBuildings("remove",self)
          ObjModified(context)
        end
      })
    })

    --go to controlled/controller building
    XTemplates.sectionWorkplace[#XTemplates.sectionWorkplace+1] = PlaceObj("XTemplateTemplate", {
      "SolariaTelepresence_sectionWorkplace3", true,
      "__context_of_kind", "Workplace",
      "__template", "InfopanelActiveSection",
      "Icon", "UI/Icons/Anomaly_Event.tga",
      "Title", "",
      "RolloverText", "",
      "RolloverTitle", [[Telepresence]],
      "RolloverHint",  [[<left_click> Viewing]],
      "OnContextUpdate", function(self, context)
        --only show if on correct building and remote control is enabled
        if context.SolariaTelepresence_Remote_Controller or context.SolariaTelepresence_Remote_Controlled then
          if context.SolariaTelepresence_Remote_Controller then
            self:SetTitle(RetName(context.SolariaTelepresence_Remote_Controller.building))
            self:SetRolloverText([[Select and view controlled building.]])
          elseif context.SolariaTelepresence_Remote_Controlled then
            self:SetTitle([[Solaria Telepresence]])
            self:SetRolloverText([[Select and view Solaria controller.]])
          end
          self:SetVisible(true)
          self:SetMaxHeight()
        else
          self:SetVisible(false)
          self:SetMaxHeight(0)
        end
      end,
    }, {
      PlaceObj("XTemplateFunc", {
        "name", "OnActivate(self, context)",
        "parent", function(parent, context)
          return parent.parent
        end,
        "func", function(self, context)
          if context.SolariaTelepresence_Remote_Controller then
            ViewAndSelectObject(context.SolariaTelepresence_Remote_Controller.building)
          elseif context.SolariaTelepresence_Remote_Controlled then
            ViewAndSelectObject(context.SolariaTelepresence_Remote_Controlled)
          end

        end
      })
    })

  end --XTemplates
end --ClassesBuilt

local function SomeCode()
  --store amount of controlled buildings for toggling visiblity of "All Attached Buildings" button
  local UICity = UICity
  if UICity and not UICity.SolariaTelepresence_RemoteControlledBuildings then
    UICity.SolariaTelepresence_RemoteControlledBuildings = 0
  end

  if not UICity.tech_status.CreativeRealitiesSolaria then
    UICity.tech_status.CreativeRealitiesSolaria = {
      cost = 7000,
      field = "Physics",
      points = 0
    }
    UICity.tech_field.Physics[#UICity.tech_field.Physics+1] = "CreativeRealitiesSolaria"
  end

end

function OnMsg.CityStart()
  SomeCode()
end

function OnMsg.LoadGame()
  SomeCode()
end
