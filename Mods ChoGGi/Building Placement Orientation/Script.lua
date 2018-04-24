ChoGGiX = {
  OrigFunc = {},
--Some names need to be fixed when doing construction placement
ConstructionNamesListFix = {
  RCRover = "RCRoverBuilding",
  RCDesireTransport = "RCDesireTransportBuilding",
  RCTransport = "RCTransportBuilding",
  ExplorerRover = "RCExplorerBuilding",
  Rocket = "SupplyRocket"
  }
}

--for orientation
function OnMsg.BuildingPlaced(Object)
  ChoGGiX.LastPlacedObject = Object
end
function OnMsg.ConstructionSitePlaced(Object)
  ChoGGiX.LastPlacedObject = Object
end
--for ctrl-space
function OnMsg.ConstructionComplete(building)
  ChoGGiX.LastPlacedBuildingObj = building
end

function OnMsg.LoadGame()
  --for setting the orientation
  if not ChoGGiX.OrigFunc.CC_ChangeCursorObj then
    ChoGGiX.OrigFunc.CC_ChangeCursorObj = ConstructionController.CreateCursorObj
  end
  function ConstructionController:CreateCursorObj(alternative_entity, template_obj, override_palette)

    local cursor_obj = ChoGGiX.OrigFunc.CC_ChangeCursorObj(self,alternative_entity, template_obj, override_palette)

    --set orientation to last object if same entity (should I just do it for everything)
    --if ChoGGiX.LastPlacedObject and ChoGGiX.LastPlacedObject.entity == cursor_obj.entity then
    if ChoGGiX.LastPlacedObject then
      pcall(function()
        cursor_obj:SetOrientation(ChoGGiX.LastPlacedObject:GetOrientation())
      end)
    end

    return cursor_obj
  end

  --spawn and fill a deposit at mouse pos
  function ChoGGiX.AddDeposit(sType)
    local obj = PlaceObj(sType, {
      "Pos", GetTerrainCursor(),
      "max_amount", UICity:Random(1000 * ChoGGiX.Consts.ResourceScale,100000 * ChoGGiX.Consts.ResourceScale),
      "revealed", true,
    })
    obj:CheatRefill()
    obj.amount = obj.max_amount
  end

  --fixup name we get from Object
  function ChoGGiX.ConstructionModeNameClean(itemname)
    --we want template_name or we have to guess from the placeobj name
    local tempname = itemname:match("^.+template_name%A+([A-Za-z_%s]+).+$")
    if not tempname then
      tempname = itemname:match("^PlaceObj%('(%a+).+$")
    end

    --print(tempname)
    if tempname:find("Deposit") then
      ChoGGiX.AddDeposit(tempname)
    else
      ChoGGiX.ConstructionModeSet(tempname)
    end
  end

  --place item under the mouse for construction
  function ChoGGiX.ConstructionModeSet(itemname)
    --make sure it's closed so we don't mess up selection
    pcall(function()
      CloseXBuildMenu()
    end)
    --fix up some names
    itemname = pcall(ChoGGiX.ConstructionNamesListFix[itemname]) or itemname
    --n all the rest
    local igi = GetInGameInterface()
    if not igi or not igi:GetVisible() then
      return
    end
    local bld_template = DataInstances.BuildingTemplate[itemname]
    local show,prefabs,can_build,action = UIGetBuildingPrerequisites(bld_template.build_category,bld_template,true)

    if show then
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
    end
  end

  --change some annoying stuff about UserActions.AddActions()
  local g_idxAction = 0
  function ChoGGiX.UserAddActions(ActionsToAdd)
    for k, v in pairs(ActionsToAdd) do
      if type(v.action) == "function" and (v.key ~= nil and v.key ~= "" or v.xinput ~= nil and v.xinput ~= "" or v.menu ~= nil and v.menu ~= "" or v.toolbar ~= nil and v.toolbar ~= "") then
        if v.key ~= nil and v.key ~= "" then
          if type(v.key) == "table" then
            local keys = v.key
            if #keys <= 0 then
              v.description = ""
            else
              v.description = v.description .. " (" .. keys[1]
              for i = 2, #keys do
                v.description = v.description .. " or " .. keys[i]
              end
              v.description = v.description .. ")"
            end
          else
            v.description = tostring(v.description) .. " (" .. v.key .. ")"
          end
        end
        v.id = k
        v.idx = g_idxAction
        g_idxAction = g_idxAction + 1
        UserActions.Actions[k] = v
      else
        UserActions.RejectedActions[k] = v
      end
    end
    UserActions.SetMode(UserActions.mode)
  end

  function ChoGGiX.AddAction(Menu,Action,Key,Des,Icon,Toolbar,Mode,xInput,ToolbarDefault)
    if Menu then
      Menu = "/" .. tostring(Menu)
    end

    ChoGGiX.UserAddActions({
      ["ChoGGiX_" .. AsyncRand()] = {
        menu = Menu,
        action = Action,
        key = Key,
        description = Des or "",
        icon = Icon,
        toolbar = Toolbar,
        mode = Mode,
        xinput = xInput,
        toolbar_default = ToolbarDefault
      }
    })
  end

  --goes to placement mode with last built object
  ChoGGiX.AddAction(nil,
    function()
      local last = ChoGGiX.LastPlacedBuildingObj
      if last.entity then
        ChoGGiX.ConstructionModeSet(last.encyclopedia_id or last.entity)
      end
    end,
    "Ctrl-Space"
  )

  --goes to placement mode with SelectedObj
  ChoGGiX.AddAction(nil,
    function()
      local sel = SelectedObj or SelectionMouseObj()
      if sel then
        ChoGGiX.LastPlacedObject = sel
        ChoGGiX.ConstructionModeNameClean(ValueToLuaCode(sel))
      end
    end,
    "Ctrl-Shift-Space"
  )
end
