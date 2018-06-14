--See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat

local pcall,tostring = pcall,tostring

local CloseXBuildMenu = CloseXBuildMenu
local GetInGameInterface = GetInGameInterface
local GetXDialog = GetXDialog
local PlaceObj = PlaceObj
local Random = Random
local ShowConsole = ShowConsole
local UIGetBuildingPrerequisites = UIGetBuildingPrerequisites
local ValueToLuaCode = ValueToLuaCode

local g_Classes = g_Classes

function ChoGGi.MsgFuncs.Keys_ChoGGi_Loaded()

  ChoGGi.ComFuncs.AddAction(
    nil,
    function()
      ChoGGi.CodeFuncs.ObjectColourRandom(ChoGGi.CodeFuncs.SelObject())
    end,
    "Shift-F6"
  )
  ChoGGi.ComFuncs.AddAction(
    nil,
    function()
      ChoGGi.CodeFuncs.ObjectColourDefault(ChoGGi.CodeFuncs.SelObject())
    end,
    "Ctrl-F6"
  )

  --use number keys to activate/hide build menus
  if ChoGGi.UserSettings.NumberKeysBuildMenu then
    local function AddMenuKey(Num,Key)
      ChoGGi.ComFuncs.AddAction(nil,
        function()
          ChoGGi.CodeFuncs.ShowBuildMenu(Num)
        end,
        Key
      )
    end
    local skipped = false
    local Table = BuildCategories
    for i = 1, #Table do
      if i < 10 then
        --the key has to be a string
        AddMenuKey(i,tostring(i))
      elseif i == 10 then
        AddMenuKey(i,"0")
      else
        --skip Hidden as it'll have the Rocket Landing Site (hard to remove).
        if Table[i].id == "Hidden" then
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

  --spawn and fill a deposit at mouse pos
  function ChoGGi.MenuFuncs.AddDeposit(sType)
    local obj = PlaceObj(sType, {
      "Pos", ChoGGi.CodeFuncs.CursorNearestHex(),
      "max_amount", Random(1000 * ChoGGi.Consts.ResourceScale,100000 * ChoGGi.Consts.ResourceScale),
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
    local fixed = ChoGGi.Tables.ConstructionNamesListFix[itemname]
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
  ChoGGi.ComFuncs.AddAction(nil,
    function()
      ShowConsole(true)
    end,
    "~"
  )

  ChoGGi.ComFuncs.AddAction(nil,
    function()
      ShowConsole(true)
    end,
    "Enter"
  )

  --show console with restart
  ChoGGi.ComFuncs.AddAction(nil,
    function()
      ShowConsole(true)
      local dlgConsole = dlgConsole
      if dlgConsole then
        dlgConsole.idEdit:SetText("restart")
      end
    end,
    "Ctrl-Alt-Shift-R"
  )

  --goes to placement mode with last built object
  ChoGGi.ComFuncs.AddAction(nil,
    function()
      local last = UICity.LastConstructedBuilding
      if last.entity then
        ChoGGi.MenuFuncs.ConstructionModeSet(last.encyclopedia_id or last.entity)
      end
    end,
    "Ctrl-Space"
  )

  --goes to placement mode with SelectedObj
  ChoGGi.ComFuncs.AddAction(nil,
    function()
      local ChoGGi = ChoGGi
      local sel = ChoGGi.CodeFuncs.SelObject()
      if sel then
        ChoGGi.Temp.LastPlacedObject = sel
        ChoGGi.MenuFuncs.ConstructionModeNameClean(ValueToLuaCode(sel))
      end
    end,
    "Ctrl-Shift-Space"
  )

  ChoGGi.ComFuncs.AddAction(
    nil,
    function()
      local ChoGGi = ChoGGi
      ChoGGi.UserSettings.ShowCheatsMenu = not ChoGGi.UserSettings.ShowCheatsMenu
      ChoGGi.SettingFuncs.WriteSettings()
      g_Classes.UAMenu.ToggleOpen()
    end,
    "F2"
  )

--~   ChoGGi.ComFuncs.AddAction(
--~     nil,
--~     function()
--~       quit("restart")
--~     end,
--~     "Ctrl-Shift-Alt-Numpad Enter"
--~   )

end --OnMsg
