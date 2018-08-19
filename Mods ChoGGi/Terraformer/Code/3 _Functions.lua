local select,pcall = select,pcall

local SelectionMouseObj = SelectionMouseObj
local NearestObject = NearestObject
local GetTerrainCursor = GetTerrainCursor

function Terraformer.CodeFuncs.SelObject()
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

local function AttachmentsCollisionToggle(sel,flag)
  local att = sel:GetAttaches() or empty_table
  if #att > 0 then
    local const = const
    for i = 1, #att do
      att[i][flag](att[i],const.efCollision + const.efApplyToGrids)
    end
  end
end

function Terraformer.CodeFuncs.CollisionsObject_Toggle(obj)
  obj = obj or Terraformer.CodeFuncs.SelObject()
  --menu item
  if not obj.class then
    obj = Terraformer.CodeFuncs.SelObject()
  end
  if not obj then
    return
  end
  local const = const

  local which
  if obj.Terraformer_CollisionsDisabled then
    obj:SetEnumFlags(const.efCollision + const.efApplyToGrids)
    AttachmentsCollisionToggle(obj,"SetEnumFlags")
    obj.Terraformer_CollisionsDisabled = nil
    which = "enabled"
  else
    obj:ClearEnumFlags(const.efCollision + const.efApplyToGrids)
    AttachmentsCollisionToggle(obj,"ClearEnumFlags")
    obj.Terraformer_CollisionsDisabled = true
    which = "disabled"
  end

end

function Terraformer.CodeFuncs.Editor_Toggle()
  local Platform = Platform

  Platform.editor = true
  Platform.developer = true

  if IsEditorActive() then
    EditorState(0)
    table.restore(hr, "Editor")
    editor.SavedDynRes = false
    XShortcutsSetMode("Game")
    Platform.editor = false
    Platform.developer = false
  else
    table.change(hr, "Editor", {
      ResolutionPercent = 100,
      SceneWidth = 0,
      SceneHeight = 0,
      DynResTargetFps = 0
    })
    XShortcutsSetMode("Game")
    EditorState(1,1)
    GetEditorInterface():Show(true)

    editor.OldCameraType = {
      GetCamera()
    }
    editor.CameraWasLocked = camera.IsLocked(1)
    camera.Unlock(1)

    GetEditorInterface():SetVisible(true)
    GetEditorInterface():ShowActionBar(true)
  end

end
