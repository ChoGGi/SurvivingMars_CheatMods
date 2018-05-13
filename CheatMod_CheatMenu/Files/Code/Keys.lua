local CSettingFuncs = ChoGGi.SettingFuncs
local CCodeFuncs = ChoGGi.CodeFuncs
local CTables = ChoGGi.Tables
local CComFuncs = ChoGGi.ComFuncs
local CConsts = ChoGGi.Consts

function ChoGGi.MsgFuncs.Keys_LoadingScreenPreClose()

  CComFuncs.AddAction(
    nil,
    function()
      CCodeFuncs.ObjectColourRandom(CCodeFuncs.SelObject())
    end,
    "Shift-F6"
  )
  CComFuncs.AddAction(
    nil,
    function()
      CCodeFuncs.ObjectColourDefault(CCodeFuncs.SelObject())
    end,
    "Ctrl-F6"
  )

  --use number keys to activate/hide build menus
  if ChoGGi.UserSettings.NumberKeysBuildMenu then
    local function AddMenuKey(Num,Key)
      CComFuncs.AddAction(nil,
        function()
          CCodeFuncs.ShowBuildMenu(Num)
        end,
        Key
      )
    end
    local skipped = false
    for i = 1, #BuildCategories do
      if i < 10 then
        --the key has to be a string
        AddMenuKey(i,tostring(i))
      elseif i == 10 then
        AddMenuKey(i,"0")
      else
        --skip Hidden as it'll have the Rocket Landing Site (hard to remove).
        if BuildCategories[i].id == "Hidden" then
          skipped = true
        else
          if skipped then
            -- -1 more for skipping Hidden
            AddMenuKey(i,"Shift-" .. i - 11)
          else
            -- -10 since we're doing Shift-*
            AddMenuKey(i,"Shift-" .. i - 10)
          end
        end
      end
    end
  end

  --spawn and fill a deposit at mouse pos
  function ChoGGi.MenuFuncs.AddDeposit(sType)

    local obj = PlaceObj(sType, {
      "Pos", CCodeFuncs.CursorNearestHex(),
      "max_amount", UICity:Random(1000 * CConsts.ResourceScale,100000 * CConsts.ResourceScale),
      "revealed", true,
    })
    obj:CheatRefill()
    obj.amount = obj.max_amount

  end

  --fixup name we get from Object
  function ChoGGi.MenuFuncs.ConstructionModeNameClean(itemname)

    --we want template_name or we have to guess from the placeobj name
    local tempname = itemname:match("^.+template_name%A+([A-Za-z_%s]+).+$")
    if not tempname then
      tempname = itemname:match("^PlaceObj%('(%a+).+$")
    end

    --print(tempname)
    if tempname:find("Deposit") then
      ChoGGi.MenuFuncs.AddDeposit(tempname)
    else
      ChoGGi.MenuFuncs.ConstructionModeSet(tempname)
    end

  end

  --place item under the mouse for construction
  function ChoGGi.MenuFuncs.ConstructionModeSet(itemname)

    --make sure it's closed so we don't mess up selection
    pcall(function()
      CloseXBuildMenu()
    end)
    --fix up some names
    local fixed = CTables.ConstructionNamesListFix[itemname]
    if fixed then
      itemname = fixed
    end
    --n all the rest
    local igi = GetInGameInterface()
    if not igi or not igi:GetVisible() then
      return
    end
    local bld_template = DataInstances.BuildingTemplate[itemname]
    --local show,_,can_build,action = UIGetBuildingPrerequisites(bld_template.build_category,bld_template,true)
    local _,_,can_build,action = UIGetBuildingPrerequisites(bld_template.build_category,bld_template,true)

    --if show then --interferes with building passageramp
      local dlg = GetXDialog("XBuildMenu")
      if action then
        action(dlg,{
          enabled = can_build,
          name = bld_template.name,
          construction_mode = bld_template.construction_mode
        })
      else
        igi:SetMode("construction",{
          template = bld_template.name,
          selected_dome = dlg and dlg.context.selected_dome
        })
      end
      CloseXBuildMenu()
    --end
  end

  --show console
  CComFuncs.AddAction(nil,
    function()
      ShowConsole(true)
    end,
    "~"
  )

  CComFuncs.AddAction(nil,
    function()
      ShowConsole(true)
    end,
    "Enter"
  )

  --show console with restart
  CComFuncs.AddAction(nil,
    function()
      ShowConsole(true)
      CCodeFuncs.AddConsolePrompt("restart")
    end,
    "Ctrl-Alt-Shift-R"
  )

  --goes to placement mode with last built object
  CComFuncs.AddAction(nil,
    function()
      local last = UICity.LastConstructedBuilding
      if last.entity then
        ChoGGi.MenuFuncs.ConstructionModeSet(last.encyclopedia_id or last.entity)
      end
    end,
    "Ctrl-Space"
  )

  --goes to placement mode with SelectedObj
  CComFuncs.AddAction(nil,
    function()
      local sel = CCodeFuncs.SelObject()
      if sel then
        ChoGGi.Temp.LastPlacedObject = sel
        ChoGGi.MenuFuncs.ConstructionModeNameClean(ValueToLuaCode(sel))
      end
    end,
    "Ctrl-Shift-Space"
  )

  --object cloner
  CComFuncs.AddAction(nil,
    function()
      local sel = SelectedObj
      local NewObj = g_Classes[sel.class]:new()
      NewObj:CopyProperties(sel)
      --[[find out which ones we shouldn't copy
      for Key,Value in pairs(sel or empty_table) do
        NewObj[Key] = Value
      end
      --]]
      NewObj:SetPos(CCodeFuncs.CursorNearestHex())
      --if it's a deposit then make max_amount random and add
      --local ObjName = ValueToLuaCode(sel):match("^PlaceObj%('(%a+).+$")
      --if ObjName:find("SubsurfaceDeposit") then
      --NewObj.max_amount = UICity:Random(1000 * CConsts.ResourceScale,5000 * CConsts.ResourceScale)
      if NewObj.max_amount then
        NewObj.amount = NewObj.max_amount
      elseif NewObj.base_death_age then
        --it seems CopyProperties is only some properties
        NewObj.traits = {}
        NewObj.race = sel.race
        NewObj.fx_actor_class = sel.fx_actor_class
        NewObj.entity = sel.entity
        NewObj.infopanel_icon = sel.infopanel_icon
        NewObj.inner_entity = sel.inner_entity
        NewObj.pin_icon = sel.pin_icon
        CCodeFuncs.ColonistUpdateGender(NewObj,sel.gender,sel.entity_gender)
        CCodeFuncs.ColonistUpdateAge(NewObj,sel.age_trait)
        NewObj:SetSpecialization(sel.specialist,"init")
        NewObj.age = sel.age
        NewObj:ChooseEntity()
      end
    end,
    "Shift-Q"
  )

  CComFuncs.AddAction(
    nil,
    function()
      ChoGGi.UserSettings.ShowCheatsMenu = not ChoGGi.UserSettings.ShowCheatsMenu
      CSettingFuncs.WriteSettings()
      UAMenu.ToggleOpen()
    end,
    "F2"
  )

  CComFuncs.AddAction(
    nil,
    function()
      quit("restart")
    end,
    "Ctrl-Shift-Alt-Numpad Enter"
  )

end --OnMsg
