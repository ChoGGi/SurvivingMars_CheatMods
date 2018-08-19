-- See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local Actions = ChoGGi.Temp.Actions

--use number keys to activate/hide build menus
do -- NumberKeysBuildMenu
  local function AddMenuKey(num,key)
    Actions[#Actions+1] = {
      ActionId = Concat("ChoGGi_AddMenuKey",num),
      OnAction = function()
        ChoGGi.CodeFuncs.ShowBuildMenu(num)
      end,
      ActionShortcut = key,
    }
  end
  if ChoGGi.UserSettings.NumberKeysBuildMenu then
    local Concat = ChoGGi.ComFuncs.Concat
    local tostring = tostring
    local skipped
    local BuildCategories = BuildCategories
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
            AddMenuKey(i,Concat("Shift-",i - 11))
          else
            -- -10 since we're doing Shift-*
            AddMenuKey(i,Concat("Shift-",i - 10))
          end
        end
      end
    end
  end
end

--spawn and fill a deposit at mouse pos
function ChoGGi.MenuFuncs.AddDeposit(sType)
  local obj = PlaceObj(sType, {
    "Pos", ChoGGi.CodeFuncs.CursorNearestHex(),
    "revealed", true,
  })
  obj.max_amount = ChoGGi.ComFuncs.Random(1000 * ChoGGi.Consts.ResourceScale,100000 * ChoGGi.Consts.ResourceScale)
  obj:CheatRefill()
  obj.amount = obj.max_amount
end

--fixup name we get from Object
function ChoGGi.MenuFuncs.ConstructionModeNameClean(itemname,build_category)
  --we want template_name or we have to guess from the placeobj name
  local tempname = itemname:match("^.+template_name%A+([A-Za-z_%s]+).+$")
  if not tempname then
    tempname = itemname:match("^PlaceObj%('(%a+).+$")
  end

  --print(tempname)
  if tempname:find("Deposit") then
    ChoGGi.MenuFuncs.AddDeposit(tempname)
  else
    ChoGGi.MenuFuncs.ConstructionModeSet(tempname,build_category)
  end
end

--place item under the mouse for construction
function ChoGGi.MenuFuncs.ConstructionModeSet(itemname,build_category)
  --make sure it's closed so we don't mess up selection
  pcall(function()
    CloseXBuildMenu()
  end)
  -- fix up some names
  local fixed = ChoGGi.Tables.ConstructionNamesListFix[itemname]
  if fixed then
    itemname = fixed
  end
  -- n all the rest
  local igi = Dialogs.InGameInterface
  if not igi or not igi:GetVisible() then
    return
  end

  local bld_template = Presets.BuildingTemplate[build_category][itemname]
  --local show,_,can_build,action = UIGetBuildingPrerequisites(bld_template.build_category,bld_template,true)
  local _,_,can_build,action = UIGetBuildingPrerequisites(build_category,bld_template,true)

  -- interferes with building passage ramp
  --if show then
    local dlg = Dialogs.XBuildMenu
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

Actions[#Actions+1] = {
  ActionId = "ChoGGi_ClearConsoleLog",
  OnAction = cls,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.ClearConsoleLog,
}

Actions[#Actions+1] = {
  ActionId = "ChoGGi_ObjectColourRandom",
  OnAction = function()
    ChoGGi.CodeFuncs.ObjectColourRandom(ChoGGi.CodeFuncs.SelObject())
  end,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.ObjectColourRandom,
}

Actions[#Actions+1] = {
  ActionId = "ChoGGi_ObjectColourDefault",
  OnAction = function()
    ChoGGi.CodeFuncs.ObjectColourDefault(ChoGGi.CodeFuncs.SelObject())
  end,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.ObjectColourDefault,
}

local function ToggleConsole()
  local dlgConsole = dlgConsole
  if dlgConsole then
    ShowConsole(not dlgConsole:GetVisible())
  end
end

Actions[#Actions+1] = {
  ActionId = "ChoGGi_ShowConsoleTilde",
  OnAction = function()
    ToggleConsole()
  end,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.ShowConsoleTilde,
}

Actions[#Actions+1] = {
  ActionId = "ChoGGi_ShowConsoleEnter",
  OnAction = function()
    ToggleConsole()
  end,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.ShowConsoleEnter,
}

Actions[#Actions+1] = {
  ActionId = "ChoGGi_ConsoleRestart",
  OnAction = function()
    local dlgConsole = dlgConsole
    if dlgConsole then
      if not dlgConsole:GetVisible() then
        ShowConsole(true)
      end
      dlgConsole.idEdit:SetFocus()
      dlgConsole.idEdit:SetText("restart")
    end
  end,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.ConsoleRestart,
}

-- goes to placement mode with last built object
Actions[#Actions+1] = {
  ActionId = "ChoGGi_LastConstructedBuilding",
  OnAction = function()
    local last = UICity.LastConstructedBuilding
    if last.entity then
      ChoGGi.MenuFuncs.ConstructionModeSet(last.encyclopedia_id or last.entity,last.build_category)
    end
  end,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.LastConstructedBuilding,
}

-- goes to placement mode with SelectedObj
Actions[#Actions+1] = {
  ActionId = "ChoGGi_LastPlacedObject",
  OnAction = function()
    local ChoGGi = ChoGGi
    local sel = ChoGGi.CodeFuncs.SelObject()
    if sel then
      ChoGGi.Temp.LastPlacedObject = sel
      ChoGGi.MenuFuncs.ConstructionModeNameClean(ValueToLuaCode(sel),sel.build_category)
    end
  end,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.LastPlacedObject,
}
