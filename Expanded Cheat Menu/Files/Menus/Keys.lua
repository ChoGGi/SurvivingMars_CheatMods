--See LICENSE for terms

local AddAction = ChoGGi.ComFuncs.AddAction

--use number keys to activate/hide build menus
do -- NumberKeysBuildMenu
  local function AddMenuKey(num,key)
    AddAction(
      nil,
      nil,
      function()
        ChoGGi.CodeFuncs.ShowBuildMenu(num)
      end,
      key
    )
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
  local fixed = ChoGGi.Tables.ConstructionNamesListFix[itemname]
  if fixed then
    itemname = fixed
  end
  --n all the rest
  local igi = XDialogs.InGameInterface
  if not igi or not igi:GetVisible() then
    return
  end
  local bld_template = DataInstances.BuildingTemplate[itemname]
  --local show,_,can_build,action = UIGetBuildingPrerequisites(bld_template.build_category,bld_template,true)
  local _,_,can_build,action = UIGetBuildingPrerequisites(bld_template.build_category,bld_template,true)

  --if show then --interferes with building passageramp
    local dlg = XDialogs.XBuildMenu
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

AddAction( -- ClearConsoleLog
  nil,
  nil,
  cls,
  ChoGGi.UserSettings.KeyBindings.ClearConsoleLog
)

AddAction( -- ObjectColourRandom
  nil,
  nil,
  function()
    ChoGGi.CodeFuncs.ObjectColourRandom(ChoGGi.CodeFuncs.SelObject())
  end,
  ChoGGi.UserSettings.KeyBindings.ObjectColourRandom
)

AddAction( -- ObjectColourDefault
  nil,
  nil,
  function()
    ChoGGi.CodeFuncs.ObjectColourDefault(ChoGGi.CodeFuncs.SelObject())
  end,
  ChoGGi.UserSettings.KeyBindings.ObjectColourDefault
)

AddAction( -- ShowConsoleTilde
  nil,
  nil,
  function()
    ShowConsole(true)
  end,
  ChoGGi.UserSettings.KeyBindings.ShowConsoleTilde
)

AddAction( -- ShowConsoleEnter
  nil,
  nil,
  function()
    ShowConsole(true)
  end,
  ChoGGi.UserSettings.KeyBindings.ShowConsoleEnter
)

AddAction( -- ConsoleRestart
  nil,
  nil,
  function()
    ShowConsole(true)
    local dlgConsole = dlgConsole
    if dlgConsole then
      dlgConsole.idEdit:SetText("restart")
      dlgConsole.idEdit:SetFocus()
    end
  end,
  ChoGGi.UserSettings.KeyBindings.ConsoleRestart
)

--goes to placement mode with last built object
AddAction( -- LastConstructedBuilding
  nil,
  nil,
  function()
    local last = UICity.LastConstructedBuilding
    if last.entity then
      ChoGGi.MenuFuncs.ConstructionModeSet(last.encyclopedia_id or last.entity)
    end
  end,
  ChoGGi.UserSettings.KeyBindings.LastConstructedBuilding
)

-- goes to placement mode with SelectedObj
AddAction( -- LastPlacedObject
  nil,
  nil,
  function()
    local ChoGGi = ChoGGi
    local sel = ChoGGi.CodeFuncs.SelObject()
    if sel then
      ChoGGi.Temp.LastPlacedObject = sel
      ChoGGi.MenuFuncs.ConstructionModeNameClean(ValueToLuaCode(sel))
    end
  end,
  ChoGGi.UserSettings.KeyBindings.LastPlacedObject
)
