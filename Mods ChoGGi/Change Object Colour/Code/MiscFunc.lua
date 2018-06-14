--See LICENSE for terms

local Concat = ChangeObjectColour.ComFuncs.Concat
local T = ChangeObjectColour.ComFuncs.Trans
local UsualIcon = "UI/Icons/Anomaly_Event.tga"

local next,tostring,type,table = next,tostring,type,table

local ChangeGameSpeedState = ChangeGameSpeedState
local CreateRealTimeThread = CreateRealTimeThread
local GetObjects = GetObjects
local PlayFX = PlayFX
local Random = Random
local RebuildFXRules = RebuildFXRules
local RemoveFromRules = RemoveFromRules
local ReopenSelectionXInfopanel = ReopenSelectionXInfopanel
local Sleep = Sleep

--build and show a list of attachments for changing their colours
function ChangeObjectColour.MenuFuncs.CreateObjectListAndAttaches()
  local ChangeObjectColour = ChangeObjectColour
  local obj = ChangeObjectColour.CodeFuncs.SelObject()
  if not obj or obj and not obj:IsKindOf("ColorizableObject") then
    ChangeObjectColour.ComFuncs.MsgPopup(T(302535920001105--[[Select/mouse over an object (buildings, vehicles, signs, rocky outcrops).--]]),T(302535920000016--[[Colour--]]))
    return
  end
  local ItemList = {}

  --has no Attaches so just open as is
  if obj:GetNumAttaches() == 0 then
    ChangeObjectColour.CodeFuncs.ChangeObjectColour(obj)
    return
  else
    ItemList[#ItemList+1] = {
      text = Concat(" ",obj.class),
      value = obj.class,
      obj = obj,
      hint = T(302535920001106--[[Change main object colours.--]])
    }
    local Attaches = obj:GetAttaches()
    for i = 1, #Attaches do
      ItemList[#ItemList+1] = {
        text = Attaches[i].class,
        value = Attaches[i].class,
        parentobj = obj,
        obj = Attaches[i],
        hint = T(302535920001107--[[Change colours of an attached object.--]])
      }
    end
  end

  local CallBackFunc = function() return end

  ChangeObjectColour.ComFuncs.OpenInListChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = Concat(T(302535920000021--[[Change Colour--]]),": ",ChangeObjectColour.ComFuncs.RetName(obj)),
    hint = T(302535920001108--[[Double click to open object/attachment to edit.--]]),
    custom_type = 1,
  })
end
