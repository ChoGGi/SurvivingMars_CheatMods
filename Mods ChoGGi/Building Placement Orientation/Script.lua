BuildingPlacementOrientation = {
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
function OnMsg.BuildingPlaced(Obj)
  if IsKindOf(Obj,"Building") then
    BuildingPlacementOrientation.LastPlacedObject = Obj
  end
end
function OnMsg.ConstructionSitePlaced(Obj)
  if IsKindOf(Obj,"Building") then
    BuildingPlacementOrientation.LastPlacedObject = Obj
  end
end
--for ctrl-space
function OnMsg.ConstructionComplete(Obj)
  if IsKindOf(Obj,"Building") then
    BuildingPlacementOrientation.LastPlacedObject = Obj
  end
end

function BuildingPlacementOrientation.FilterFromTable(Table,ExcludeList,Type)
  return FilterObjects({
      filter = function(o)
        if not ExcludeList[o[Type]] then
          return o
        end
      end
    },Table)
end

function BuildingPlacementOrientation.SelObject()
  return SelectedObj or SelectionMouseObj() or NearestObject(
    GetTerrainCursor(),
    GetObjects{
      filter = function(o)
        if o.class ~= "ParSystem" then
          return o
        end
      end,
    },
    1500
  )
end

local function SomeCode()
  --for setting the orientation
  if not BuildingPlacementOrientation.OrigFunc.CC_ChangeCursorObj then
    BuildingPlacementOrientation.OrigFunc.CC_ChangeCursorObj = ConstructionController.CreateCursorObj
  end
  function ConstructionController:CreateCursorObj(alternative_entity, template_obj, override_palette)

    local ret = BuildingPlacementOrientation.OrigFunc.CC_ChangeCursorObj(self,alternative_entity, template_obj, override_palette)

    local last = BuildingPlacementOrientation.LastPlacedObject
    if last then
      pcall(function()
        ret:SetAngle(last:GetAngle())
      end)
    end

    return ret
  end

  --spawn and fill a deposit at mouse pos
  function BuildingPlacementOrientation.AddDeposit(sType)
    local obj = PlaceObj(sType, {
      "Pos", GetTerrainCursor(),
      "max_amount", UICity:Random(1000 * BuildingPlacementOrientation.Consts.ResourceScale,100000 * BuildingPlacementOrientation.Consts.ResourceScale),
      "revealed", true,
    })
    obj:CheatRefill()
    obj.amount = obj.max_amount
  end

  --fixup name we get from Object
  function BuildingPlacementOrientation.ConstructionModeNameClean(itemname)
    --we want template_name or we have to guess from the placeobj name
    local tempname = itemname:match("^.+template_name%A+([A-Za-z_%s]+).+$")
    if not tempname then
      tempname = itemname:match("^PlaceObj%('(%a+).+$")
    end

    --print(tempname)
    if tempname:find("Deposit") then
      BuildingPlacementOrientation.AddDeposit(tempname)
    else
      BuildingPlacementOrientation.ConstructionModeSet(tempname)
    end
  end

  --place item under the mouse for construction
  function BuildingPlacementOrientation.ConstructionModeSet(itemname)
    --make sure it's closed so we don't mess up selection
    pcall(function()
      CloseXBuildMenu()
    end)
    --fix up some names
    itemname = pcall(BuildingPlacementOrientation.ConstructionNamesListFix[itemname]) or itemname
    --n all the rest
    local igi = GetInGameInterface()
    if not igi or not igi:GetVisible() then
      return
    end
    local bld_template = BuildingTemplates[itemname]
    local _,prefabs,can_build,action = UIGetBuildingPrerequisites(bld_template.build_category,bld_template,true)

    --if show then
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

  --change some annoying stuff about UserActions.AddActions()
  local g_idxAction = 0
  function BuildingPlacementOrientation.UserAddActions(ActionsToAdd)
    for k, v in pairs(ActionsToAdd) do
      if type(v.action) == "function" and (v.key ~= nil and v.key ~= "" or v.xinput ~= nil and v.xinput ~= "" or v.menu ~= nil and v.menu ~= "" or v.toolbar ~= nil and v.toolbar ~= "") then
        if v.key ~= nil and v.key ~= "" then
          if type(v.key) == "table" then
            local keys = v.key
            if #keys <= 0 then
              v.description = ""
            else
              v.description = table.concat{v.description," (",keys[1]}
              for i = 2, #keys do
                v.description = table.concat{v.description," or ",keys[i]}
              end
              v.description = table.concat{v.description,")"}
            end
          else
            v.description = table.concat{tostring(v.description)," (",v.key,")"}
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

  function BuildingPlacementOrientation.AddAction(Menu,Action,Key,Des,Icon,Toolbar,Mode,xInput,ToolbarDefault)
    if Menu then
      Menu = "/" .. tostring(Menu)
    end

    BuildingPlacementOrientation.UserAddActions({
      ["BuildingPlacementOrientation_" .. AsyncRand()] = {
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
  BuildingPlacementOrientation.AddAction(nil,
    function()
      local last = BuildingPlacementOrientation.LastPlacedBuildingObj
      if last.entity then
        BuildingPlacementOrientation.ConstructionModeSet(last.encyclopedia_id or last.entity)
      end
    end,
    "Ctrl-Space"
  )

  --goes to placement mode with SelectedObj
  BuildingPlacementOrientation.AddAction(nil,
    function()
      local sel = BuildingPlacementOrientation.SelObject()
      if sel then
        BuildingPlacementOrientation.LastPlacedObject = sel
        BuildingPlacementOrientation.ConstructionModeNameClean(ValueToLuaCode(sel))
      end
    end,
    "Ctrl-Shift-Space"
  )

end

function OnMsg.CityStart()
  SomeCode()
end

function OnMsg.LoadGame()
  SomeCode()
end
