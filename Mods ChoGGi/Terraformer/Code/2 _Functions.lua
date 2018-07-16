local select,pcall = select,pcall

local SelectionMouseObj = SelectionMouseObj
local NearestObject = NearestObject
local GetTerrainCursor = GetTerrainCursor

function FlattenGround.CodeFuncs.SelObject()
  return SelectedObj or SelectionMouseObj() or NearestObject(
    GetTerrainCursor(),
    FlattenGround.ComFuncs.FilterFromTable(GetObjects{} or empty_table,{ParSystem=1},"class"),
    1000
  )
end

local function AttachmentsCollisionToggle(sel,flag)
  local att = sel:GetAttaches() or empty_table
  if #att > 0 then
    local const = const
    for i = 1, #att do
      att[i][flag](att[i],const.efCollision + const.efApplyToGrids)
    end
  end
end

function FlattenGround.CodeFuncs.CollisionsObject_Toggle(obj)
  obj = obj or FlattenGround.CodeFuncs.SelObject()
  --menu item
  if not obj.class then
    obj = FlattenGround.CodeFuncs.SelObject()
  end
  if not obj then
    return
  end
  local const = const

  local which
  if obj.FlattenGround_CollisionsDisabled then
    obj:SetEnumFlags(const.efCollision + const.efApplyToGrids)
    AttachmentsCollisionToggle(obj,"SetEnumFlags")
    obj.FlattenGround_CollisionsDisabled = nil
    which = "enabled"
  else
    obj:ClearEnumFlags(const.efCollision + const.efApplyToGrids)
    AttachmentsCollisionToggle(obj,"ClearEnumFlags")
    obj.FlattenGround_CollisionsDisabled = true
    which = "disabled"
  end

end
