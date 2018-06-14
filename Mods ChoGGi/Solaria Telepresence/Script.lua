-- hello
SolariaTelepresence = {
  _LICENSE = [[Any code from https://github.com/HaemimontGames/SurvivingMars is copyright by their LICENSE

All of my code is licensed under the MIT License as follows:

MIT License

Copyright (c) [2018] [ChoGGi]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.]],
  email = "SM_Mods@choggi.org",
  id = "ChoGGi_SolariaTelepresence",
  -- orig funcs that we replace
  OrigFuncs = {},
  -- CommonFunctions.lua
  ComFuncs = {
    FileExists = function(name)
      _,name = AsyncFileOpen(name)
      return name
    end,
  },
  -- /Code/_Functions.lua
  CodeFuncs = {},
  -- /Code/*Menu.lua and /Code/*Func.lua
  MenuFuncs = {},
  -- OnMsgs.lua
  MsgFuncs = {},
  -- InfoPaneCheats.lua
  InfoFuncs = {},
  -- Defaults.lua
  SettingFuncs = {},
  -- temporary settings that aren't saved to SettingsFile
  Temp = {
    -- collect msgs to be displayed when game is loaded
    StartupMsgs = {},
  },
  -- settings that are saved to SettingsFile
  UserSettings = {
    BuildingSettings = {},
    Transparency = {},
  },
}

-- if we use global func more then once: make them local for that small bit o' speed
local dofile,select,tostring,table = dofile,select,tostring,table
-- thanks for replacing concat...
SolariaTelepresence.ComFuncs.TableConcat = oldTableConcat or table.concat
local TConcat = SolariaTelepresence.ComFuncs.TableConcat

local AsyncFileOpen = AsyncFileOpen
local dofolder_files = dofolder_files

-- SM has a tendency to inf loop when you return a non-string value that they want to table.concat
-- so now if i accidentally return say a menu item with a function for a name, it'll just look ugly instead of freezing (cursor moves screen wasd doesn't)

-- this is also used instead of string .. string; anytime you do that lua will hash the new string, and store it till exit
-- which means this is faster, and uses less memory
local concat_table = {}
local concat_value
function SolariaTelepresence.ComFuncs.Concat(...)
  -- reuse old table if it's not that big, else it's quicker to make new one
  if #concat_table > 1000 then
    concat_table = {}
  else
    table.iclear(concat_table) -- i assume sm added a c func to clear tables, which does seem to be faster than a lua for loop
  end
  -- build table from args
  for i = 1, select("#",...) do
    concat_value = select(i,...)
      if type(concat_value) == "string" or type(concat_value) == "number" then
      concat_table[i] = concat_value
    else
      concat_table[i] = tostring(concat_value)
    end
  end
  -- and done
  return TConcat(concat_table)
end

local SolariaTelepresence = SolariaTelepresence
local Mods = Mods
SolariaTelepresence._VERSION = Mods[SolariaTelepresence.id].version
SolariaTelepresence.ModPath = Mods[SolariaTelepresence.id].path
SolariaTelepresence.MountPath = SolariaTelepresence.ModPath
local Concat = SolariaTelepresence.ComFuncs.Concat

local function LoadLocale(file)
  if not pcall(function()
    LoadTranslationTableFile(file)
  end) then
    DebugPrintNL(Concat("Problem loading locale: ",file,"\n\nPlease send me this log file ",SolariaTelepresence.email))
  end
end

-- load locale translation (if any, not likely with the amount of text, but maybe a partial one)
local locale_file = Concat(SolariaTelepresence.ModPath,"Locales/",GetLanguage(),".csv")
if SolariaTelepresence.ComFuncs.FileExists(locale_file) then
  LoadLocale(locale_file)
else
  LoadLocale(Concat(SolariaTelepresence.ModPath,"Locales/","English.csv"))
end
Msg("TranslationChanged")

dofolder_files(Concat(SolariaTelepresence.ModPath,"Code/"))

--~ function OnMsg.ClassesGenerate()
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
    local SolariaTelepresence = SolariaTelepresence
    local Table = UICity.labels.OutsideBuildings or empty_table
    local hint = "\n\nDouble-right click to view selected list item building."
    local ItemList = {}

    --show list to add controller
    if Which == "activate" then
      hint = "Double-click to remotely control building." .. hint
      --remove any we already control
      Table = FilterObjects({
        filter = function(Obj)
          if not Obj.SolariaTelepresence_Remote_Controlled then
            return Obj
          end
        end
      },Table)

      --filter list to the types we want
      Table = SolariaTelepresence.ComFuncs.FilterFromTable(
        Table,
        nil,
        {DroneFactory=true,FungalFarm=true,FusionReactor=true,MetalsExtractor=true,PreciousMetalsExtractor=true},
        "class"
      )
    --show controlled for remove list
    elseif Which == "remove" then
      hint = "Double-click to remove control of building." .. hint
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
      local pos = Table[i]:GetVisualPos()
      ItemList[#ItemList+1] = {
        text = self:BuildingName(Table[i]),
        value = Table[i].handle, --probably don't need it...
        obj = Table[i], --same
        hint = pos, --something to provide a slight reference
        func = Table[i], --for viewing object
      }
    end

    --if list is empty that means no controlled/able buildings so return
    if #ItemList == 0 then
      SolariaTelepresence.ComFuncs.MsgPopup("Nothing to control.",
        "Solaria","UI/Icons/Upgrades/holographic_scanner_04.tga"
      )
      return
    end

    --add controller for ease of movement
    ItemList[#ItemList+1] = {
      text = " Solaria Controller",
      value = self.handle,
      obj = self,
      hint = "Solaria control building.\nYou can't remove... Only view (or maybe seeing would be a better term).",
      func = self,
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
    SolariaTelepresence.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Solaria Telepresence",hint,nil,nil,nil,nil,nil,6,SolariaTelepresence.CodeFuncs.ViewAndSelectObject)
  end

  --Obj bld being controlled, self = controller
  function Solaria:BuildingName(Obj)
    return SolariaTelepresence.CodeFuncs.Trans(Obj.display_name) or Obj.encyclopedia_id or Obj.class
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

    SolariaTelepresence.ComFuncs.MsgPopup("Viewing: " .. self:BuildingName(Obj) .. " pos: " .. tostring(Obj:GetVisualPos()),
      "Solaria","UI/Icons/Upgrades/holographic_scanner_04.tga"
    )
  end

  function Solaria:RemoveBuilding(Obj)
    if Obj.handle == self.handle then
      return
    end

    Obj = Obj or self.SolariaTelepresence_Remote_Controller.building
    --update Solaria
    self.SolariaTelepresence_Remote_Controller = false
    self.max_workers = nil
    if self.working then
      self:ToggleWorking()
    end

    pcall(function()
      --shouldn't happen as RemoveBuilding gets called when buildings are removed
      DebugPrint("Solaria: Controlled building was removed without removing control.")
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

    local UICity = UICity
    UICity.SolariaTelepresence_RemoteControlledBuildings = UICity.SolariaTelepresence_RemoteControlledBuildings - 1

    SolariaTelepresence.ComFuncs.MsgPopup("Removed: " .. self:BuildingName(Obj) .. " pos: " .. tostring(Obj:GetVisualPos()),
      "Solaria","UI/Icons/Upgrades/holographic_scanner_03.tga"
    )
  end

  --update performance on controlled building (fires when worker starts work)
  function Solaria:StartWorkCycle(unit)
    Workplace.StartWorkCycle(self, unit)
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

  function Workplace:OnDestroyed()
    if self.SolariaTelepresence_Remote_Controlled then
      self:RemoveBuilding()
    end
    Workplace.OnDestroyed(self)
  end

--~ end --ClassesGenerate

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
    'display_icon', SolariaTelepresence.ModPath .. "/TheIncal.tga",
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
  local XT = XTemplates
  local ObjModified = ObjModified

  if not XT.sectionWorkplace.SolariaTelepresence_Solaria then
    XT.sectionWorkplace.SolariaTelepresence_Solaria = true
    XT.sectionWorkplace[#XT.sectionWorkplace+1] = PlaceObj("XTemplateTemplate", {
      "__context_of_kind", "Solaria",
      "__template", "InfopanelActiveSection",
      "Icon", "",
      "Title", "",
      "RolloverText", "",
      "RolloverTitle", "Telepresence",
      "RolloverHint",  "",
      "OnContextUpdate", function(self, context)
        ---
        if context.SolariaTelepresence_Remote_Controller then
          self:SetRolloverText("Remove the control of outside building from this building.")
          self:SetTitle("Remove Remote Control")
          self:SetIcon("UI/Icons/Upgrades/factory_ai_03.tga")
        else
          self:SetRolloverText("Shows list of buildings for telepresence control (Double-right click in list to select and view).")
          self:SetTitle("Remote Control Building")
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
            context:ListBuildings("activate")
          else
            local building = context.SolariaTelepresence_Remote_Controller.building
            local CallBackFunc = function()
              context:RemoveBuilding(building)
            end
            SolariaTelepresence.ComFuncs.QuestionBox(
              "Are you sure you want to remove telepresence viewing from " .. context:BuildingName(building) .. " located at " .. tostring(building:GetVisualPos()),
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
      "Title", "All Attached Buildings",
      "RolloverText", "Shows list of all controlled buildings (for removal of telepresence control).\n\nDouble-right click list item to select and view.",
      "RolloverTitle", "Telepresence",
      "RolloverHint",  "<left_click> Remove telepresence",
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
          context:ListBuildings("remove")
          ObjModified(context)
        end
      })
    })

    --go to controlled/controller building
    XT.sectionWorkplace[#XT.sectionWorkplace+1] = PlaceObj("XTemplateTemplate", {
      "__context_of_kind", "Workplace",
      "__template", "InfopanelActiveSection",
      "Icon", "UI/Icons/Anomaly_Event.tga",
      "Title", "",
      "RolloverText", "",
      "RolloverTitle", "Telepresence",
      "RolloverHint",  "<left_click> Viewing",
      "OnContextUpdate", function(self, context)
        --only show if on correct building and remote control is enabled
        if context.SolariaTelepresence_Remote_Controller or context.SolariaTelepresence_Remote_Controlled then
          if context.SolariaTelepresence_Remote_Controller then
            self:SetTitle(context:BuildingName(context.SolariaTelepresence_Remote_Controller.building))
            self:SetRolloverText("Select and view controlled building.")
          elseif context.SolariaTelepresence_Remote_Controlled then
            self:SetTitle("Solaria Telepresence")
            self:SetRolloverText("Select and view Solaria controller.")
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
            SolariaTelepresence.CodeFuncs.ViewAndSelectObject(context.SolariaTelepresence_Remote_Controller.building)
          elseif context.SolariaTelepresence_Remote_Controlled then
            SolariaTelepresence.CodeFuncs.ViewAndSelectObject(context.SolariaTelepresence_Remote_Controlled)
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

end

function OnMsg.CityStart()
  SomeCode()
end

function OnMsg.LoadGame()
  SomeCode()
end

