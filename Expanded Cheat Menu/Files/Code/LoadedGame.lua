local cCodeFuncs = ChoGGi.CodeFuncs
local cComFuncs = ChoGGi.ComFuncs
local cConsts = ChoGGi.Consts
local cInfoFuncs = ChoGGi.InfoFuncs
local cMsgFuncs = ChoGGi.MsgFuncs
local cSettingFuncs = ChoGGi.SettingFuncs
local cTables = ChoGGi.Tables
local cTesting = ChoGGi.Temp.Testing

function OnMsg.ChoGGi_Loaded()
  local UICity = UICity
  --for new games
  if not UICity then
    return
  end

  --place to store per-game values
  if not UICity.ChoGGi then
    UICity.ChoGGi = {}
  end

  local ChoGGi = ChoGGi
  local Temp = ChoGGi.Temp

  if Temp.IsGameLoaded == true then
    return
  end
  Temp.IsGameLoaded = true

  local UserSettings = ChoGGi.UserSettings
  local Presets = Presets
  local UAMenu = UAMenu
  local DataInstances = DataInstances
  local const = const
  local hr = hr
  local config = config

  --late enough that I can set g_Consts.
  cSettingFuncs.SetConstsToSaved()
  --needed for DroneResourceCarryAmount?
  UpdateDroneResourceUnits()

  --remove all built-in actions
  local UserActions = UserActions
  UserActions.ClearGlobalTables()
  UserActions.Actions = {}
  UserActions.RejectedActions = {}

  cMsgFuncs.Keys_LoadingScreenPreClose()
  cMsgFuncs.MissionFunc_LoadingScreenPreClose()
  if cTesting then
    cMsgFuncs.Testing_LoadingScreenPreClose()
  end

  --add custom actions
  cMsgFuncs.MissionMenu_LoadingScreenPreClose()
  cMsgFuncs.BuildingsMenu_LoadingScreenPreClose()
  cMsgFuncs.CheatsMenu_LoadingScreenPreClose()
  cMsgFuncs.ColonistsMenu_LoadingScreenPreClose()
  cMsgFuncs.DebugMenu_LoadingScreenPreClose()
  cMsgFuncs.DronesAndRCMenu_LoadingScreenPreClose()
  cMsgFuncs.ExpandedMenu_LoadingScreenPreClose()
  cMsgFuncs.HelpMenu_LoadingScreenPreClose()
  cMsgFuncs.MiscMenu_LoadingScreenPreClose()
  cMsgFuncs.ResourcesMenu_LoadingScreenPreClose()

  --add preset menu items
  ClassDescendantsList("Preset", function(name, class)
    local preset_class = class.PresetClass or name
    Presets[preset_class] = Presets[preset_class] or {}
    local map = class.GlobalMap
    if map then
      rawset(_G, map, rawget(_G, map) or {})
    end
    cComFuncs.AddAction(
      "Presets/" .. name,
      function()
        OpenGedApp(g_Classes[name].GedEditor, Presets[name], {
          PresetClass = name,
          SingleFile = class.SingleFile
        })
      end,
      class.EditorShortcut or nil,
      "Open a preset in the editor.",
      class.EditorIcon or "CollectionsEditor.tga"
    )
  end)
  --broken ass shit
  local mod = Mods[ChoGGi.id]
  local text = ""
  for _,bv in pairs(mod) do
    text = text .. tostring(bv)
  end
  --update menu
  UAMenu.UpdateUAMenu(UserActions.GetActiveActions())

-------------------do the above stuff before

  --show completed hidden milestones
  if UICity.ChoGGi.DaddysLittleHitler then
    PlaceObj("Milestone", {
      SortKey = 0,
      base_score = 0,
      bonus_score = 0,
      bonus_score_expiration = 0,
      display_name = "Deutsche Gesellschaft fur Rassenhygiene",
      group = "Default",
      id = "DaddysLittleHitler"
    })
    if not MilestoneCompleted.DaddysLittleHitler then
      MilestoneCompleted.DaddysLittleHitler = 3025359200000
    end
  end
  if UICity.ChoGGi.Childkiller then
    PlaceObj("Milestone", {
      SortKey = 0,
      base_score = 0,
      bonus_score = 0,
      bonus_score_expiration = 0,
      display_name = "Childkiller (You evil, evil person.)",
      group = "Default",
      id = "Childkiller"
    })
    --it doesn't hurt
    if not MilestoneCompleted.Childkiller then
      MilestoneCompleted.Childkiller = 479000000
    end
  end

  --add custom lightmodel
  local data = DataInstances.Lightmodel
  if data.ChoGGi_Custom then
    data.ChoGGi_Custom:delete()
  end
  local _,LightmodelCustom = LuaCodeToTuple(UserSettings.LightmodelCustom)
  if not LightmodelCustom then
    _,LightmodelCustom = LuaCodeToTuple(cConsts.LightmodelCustom)
  end

  if LightmodelCustom then
    data.ChoGGi_Custom = LightmodelCustom
  else
    LightmodelCustom = cConsts.LightmodelCustom
    UserSettings.LightmodelCustom = LightmodelCustom
    data.ChoGGi_Custom = LightmodelCustom
    Temp.WriteSettings = true
  end
  Temp.LightmodelCustom = LightmodelCustom

  --if there's a lightmodel name saved
  local LightModel = UserSettings.LightModel
  if LightModel then
    SetLightmodelOverride(1,LightModel)
  end

  --default only saved 20 items in console history
  const.nConsoleHistoryMaxSize = 100

  --long arsed cables
  if UserSettings.UnlimitedConnectionLength then
    GridConstructionController.max_hex_distance_to_allow_build = 1000
  end

  --on by default, you know all them martian trees (might make a cpu difference, probably not)
  hr.TreeWind = 0

  if UserSettings.DisableTextureCompression then
    --uses more vram (1 toggles it, not sure what 0 does...)
    hr.TR_ToggleTextureCompression = 1
  end

  if UserSettings.ShadowmapSize then
    hr.ShadowmapSize = UserSettings.ShadowmapSize
  end

  if UserSettings.HigherRenderDist then
    --lot of lag for some small rocks in distance
    --hr.DistanceModifier = 260 --default 130
    --hr.AutoFadeDistanceScale = 2200 --def 2200
    --render objects from further away (going to 960 makes a minimal difference, other than FPS on bigger cities)
    if type(UserSettings.HigherRenderDist) == "number" then
      hr.LODDistanceModifier = UserSettings.HigherRenderDist
    else
      hr.LODDistanceModifier = 600 --def 120
    end
  end

  if UserSettings.HigherShadowDist then
    if type(UserSettings.HigherShadowDist) == "number" then
      hr.ShadowRangeOverride = UserSettings.HigherShadowDist
    else
    --shadow cutoff dist
    hr.ShadowRangeOverride = 1000000 --def 0
    end
    --no shadow fade out when zooming
    hr.ShadowFadeOutRangePercent = 0 --def 30
  end

  --gets used a couple times
  local Table

  --not sure why this would be false on a dome
  Table = UICity.labels.Dome or empty_table
  for i = 1, #Table do
    if Table[i].achievement == "FirstDome" and type(Table[i].connected_domes) ~= "table" then
      Table[i].connected_domes = {}
    end
  end

  --something messed up if storage is negative (usually setting an amount then lowering it)
  Table = UICity.labels.Storages or empty_table
  pcall(function()
    for i = 1, #Table do
      if Table[i]:GetStoredAmount() < 0 then
        --we have to empty it first (just filling doesn't fix the issue)
        Table[i]:CheatEmpty()
        Table[i]:CheatFill()
      end
    end
  end)

  --so we can change the max_amount for concrete
  Table = TerrainDepositConcrete.properties
  for i = 1, #Table do
    if Table[i].id == "max_amount" then
      Table[i].read_only = nil
    end
  end

  --override building templates
  Table = DataInstances.BuildingTemplate
  local BuildMenuPrerequisiteOverrides = BuildMenuPrerequisiteOverrides
  for i = 1, #Table do
    local temp = Table[i]

    --make hidden buildings visible
    if UserSettings.Building_hide_from_build_menu then
      BuildMenuPrerequisiteOverrides["StorageMysteryResource"] = true
      BuildMenuPrerequisiteOverrides["MechanizedDepotMysteryResource"] = true
      if temp.name ~= "LifesupportSwitch" and temp.name ~= "ElectricitySwitch" then
        temp.hide_from_build_menu = nil
      end
      if temp.build_category == "Hidden" and temp.name ~= "RocketLandingSite" then
        temp.build_category = "HiddenX"
      end
    end

    --wonder building limit
    if UserSettings.Building_wonder then
      temp.wonder = nil
    end

  end

  --get the +5 bonus from phsy profile
  if UserSettings.NoRestingBonusPsychologistFix then
    local commander_profile = GetCommanderProfile()
    if commander_profile.id == "psychologist" then
      commander_profile.param1 = 5
    end
  end

  --show cheat pane?
  if UserSettings.InfopanelCheats then
    config.BuildingInfopanelCheats = true
    ReopenSelectionXInfopanel()
  end

  --show console log history
  if UserSettings.ConsoleToggleHistory then
    ShowConsoleLog(true)
  end

  --dim that console bg
  if UserSettings.ConsoleDim then
    config.ConsoleDim = 1
  end

  if UserSettings.ShowCheatsMenu or cTesting then
    --always show on my computer
    if not dlgUAMenu then
      UAMenu.ToggleOpen()
    end
  end

  --remove some uselessish Cheats to clear up space
  if UserSettings.CleanupCheatsInfoPane then
    cInfoFuncs.InfopanelCheatsCleanup()
  end

  --default to showing interface in ss
  if UserSettings.ShowInterfaceInScreenshots then
    hr.InterfaceInScreenshot = 1
  end

  --set zoom/border scrolling
  cCodeFuncs.SetCameraSettings()

  --show all traits
  if UserSettings.SanatoriumSchoolShowAll then
    Sanatorium.max_traits = #cTables.NegativeTraits
    School.max_traits = #cTables.PositiveTraits
  end

  --unbreakable cables/pipes
  if UserSettings.BreakChanceCablePipe then
    const.BreakChanceCable = 10000000
    const.BreakChancePipe = 10000000
  end

  --people will likely just copy new mod over old, and I moved stuff around (not as important now that most everything is stored in .hpk)
  if ChoGGi._VERSION ~= UserSettings._VERSION then
    --clean up
    cCodeFuncs.NewThread(cCodeFuncs.RemoveOldFiles)
    --update saved version
    UserSettings._VERSION = ChoGGi._VERSION
    Temp.WriteSettings = true
  end

  cCodeFuncs.NewThread(function()
    --add custom labels for cables/pipes
    local function CheckLabel(Label)
      if not UICity.labels[Label] then
        UICity:InitEmptyLabel(Label)
        if Label == "ChoGGi_ElectricityGridElement" or Label == "ChoGGi_LifeSupportGridElement" then
          local objs = GetObjects({class=Label:gsub("ChoGGi_","")}) or empty_table
          for i = 1, #objs do
            UICity.labels[Label][#UICity.labels[Label]+1] = objs[i]
            UICity.labels.ChoGGi_GridElements[#UICity.labels.ChoGGi_GridElements+1] = objs[i]
          end
        end
      end
    end
    CheckLabel("ChoGGi_GridElements")
    CheckLabel("ChoGGi_ElectricityGridElement")
    CheckLabel("ChoGGi_LifeSupportGridElement")

    --clean up my old notifications (doesn't actually matter if there's a few left, but it can spam log)
    local shown = g_ShownOnScreenNotifications
    for Key,_ in pairs(shown) do
      if type(Key) == "number" or tostring(Key):find("ChoGGi_")then
        shown[Key] = nil
      end
    end

    --remove any dialogs we opened
    ChoGGi.CodeFuncs.CloseDialogsECM()

    --remove any outside buildings i accidentally attached to domes ;)
    Table = UICity.labels.BuildingNoDomes or empty_table
    local sType
    for i = 1, #Table do
      if Table[i].dome_required == false and Table[i].parent_dome then

        sType = false
        --remove it from the dome label
        if Table[i].closed_shifts then
          sType = "Residence"
        elseif Table[i].colonists then
          sType = "Workplace"
        end

        if sType then --get a fucking continue lua
          if Table[i].parent_dome.labels and Table[i].parent_dome.labels[sType] then
            local dome = Table[i].parent_dome.labels[sType]
            for j = 1, #dome do
              if dome[j].class == Table[i].class then
                dome[j] = nil
              end
            end
          end
          --remove parent_dome
          Table[i].parent_dome = nil
        end

      end
    end

    --make the change map dialog movable
    DataInstances.UIDesignerData.MapSettingsDialog.parent_control.Movable = true
    DataInstances.UIDesignerData.MessageQuestionBox.parent_control.Movable = true
  end)

  --make sure to save anything we changed above
  if Temp.WriteSettings then
    cSettingFuncs.WriteSettings()
    Temp.WriteSettings = nil
  end

  --print startup msgs to console log
  local msgs = Temp.StartupMsgs
  for i = 1, #msgs do
    AddConsoleLog(msgs[i],true)
    --ConsolePrint(ChoGGi.Temp.StartupMsgs[i])
  end

  local dickhead
  local nofile,file = AsyncFileToString(ChoGGi.ModPath .. "/LICENSE")
  if nofile then
    --some dickhead removed the LICENSE
    dickhead = true
  elseif abs(xxhash(0,AsyncFileToString(ChoGGi.ModPath .. "/LICENSE"))) ~= 299860815 then
    --LICENSE exists, but was changed
    dickhead = true
  end
  --look ma; a LICENSE!
  if dickhead then
    print("MIT License\n\nCopyright (c) [2018] [ChoGGi]\n\nPermission is hereby granted, free of charge, to any person obtaining a copy\nof this software and associated documentation files (the \"Software\"), to deal\nin the Software without restriction, including without limitation the rights\nto use, copy, modify, merge, publish, distribute, sublicense, and/or sell\ncopies of the Software, and to permit persons to whom the Software is\nfurnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all\ncopies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\nIMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\nFITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\nAUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\nLIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\nOUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\nSOFTWARE.\n")
    print("\n\nSerious?\nI released this mod under the MIT LICENSE, all you gotta do is not delete the LICENSE file.\nIt ain't that hard to do...")
    terminal.SetOSWindowTitle("Zombie baby Jesus eats babies of LICENSE removers.")
  end

end --OnMsg
