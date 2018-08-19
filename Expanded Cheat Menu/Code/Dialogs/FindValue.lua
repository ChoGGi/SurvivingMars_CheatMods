-- See LICENSE for terms

-- shows a dialog with a single line edit to execute code in

local Concat = ChoGGi.ComFuncs.Concat
local S = ChoGGi.Strings
local RetName = ChoGGi.ComFuncs.RetName

DefineClass.ChoGGi_FindValueDlg = {
  __parents = {"ChoGGi_Window"},
  obj = false,
  obj_name = false,
  dialog_width = 700,
  dialog_height = 110,
}

function ChoGGi_FindValueDlg:Init(parent, context)
  local g_Classes = g_Classes

  self.obj = context.obj
  self.obj_name = RetName(self.obj)
  self.title = Concat(S[302535920001305--[[Find Within--]]],": ",self.obj_name)

  -- By the Power of Grayskull!
  self:AddElements(parent, context)

  self.idTextArea = g_Classes.ChoGGi_DialogSection:new({
    Id = "idTextArea",
    Dock = "top",
  }, self.idDialog)

  self.idEdit = g_Classes.ChoGGi_TextInput:new({
    Id = "idEdit",
    Dock = "left",
    MinWidth = 565,
    RolloverText = S[302535920001303--[[Search for text within %s.--]]]:format(self.obj_name),
    Hint = S[302535920001306--[[Enter text to find--]]],
    OnKbdKeyDown = function(obj, vk)
      return self:idEditOnKbdKeyDown(obj, vk)
    end,
  }, self.idTextArea)
  -- focus on textbox
  self.idEdit:SetFocus()

  self.idLimit = g_Classes.ChoGGi_TextInput:new({
    Id = "idLimit",
    Dock = "right",
    MinWidth = 35,
    RolloverText = S[302535920001304--[[Set how many levels within this table we check into (careful making it too large).--]]],
  }, self.idTextArea)
  self.idLimit:SetText("1")

  self.idButtonContainer = g_Classes.ChoGGi_DialogSection:new({
    Id = "idButtonContainer",
    Dock = "bottom",
  }, self.idDialog)

  self.idFind = g_Classes.ChoGGi_Button:new({
    Id = "idFind",
    Dock = "left",
    Text = S[302535920001302--[[Find--]]],
    RolloverText = S[302535920001303--[[Search for text within %s.--]]]:format(self.obj_name),
    Margins = box(10, 0, 0, 0),
    OnPress = function()
      self:FindText()
    end,
  }, self.idButtonContainer)

  self.idCancel = g_Classes.ChoGGi_Button:new({
    Id = "idCancel",
    Dock = "right",
    Text = S[6879--[[Cancel--]]],
    RolloverText = S[302535920000074--[[Cancel without changing anything.--]]],
    Margins = box(0, 0, 10, 0),
    OnPress = self.idCloseX.OnPress,
  }, self.idButtonContainer)

  self:SetInitPos(context.parent)
end

local found_objs
function ChoGGi_FindValueDlg:FindText()
  -- always start off empty
  found_objs = {}
  -- build our list of objs
  self:RetObjects(
    self.obj,
--~     self.idEdit:GetText():lower(),
    self.idEdit:GetText(),
    tonumber(self.idLimit:GetText())
  )
  -- and fire off a new dialog
  ChoGGi.ComFuncs.OpenInExamineDlg(found_objs):SetPos(self:GetPos()+point(0,self.header))
end

local function ReturnStr(obj)
  local obj_type = type(obj)
  if obj_type == "string" then
--~     return obj:lower(), obj_type
    return obj, obj_type
  else
--~     return tostring(obj):lower(), obj_type
    return tostring(obj), obj_type
  end
end
function ChoGGi_FindValueDlg:RetObjects(obj,str,limit,level)
  if not level then
    level = 0
  end
  if level > limit then
    return
  end

  if type(obj) == "table" then
    local name1 = RetName(obj)
    local name2 = tostring(obj)
    local obj_string
    if name1 == name2 then
      obj_string = Concat(S[302535920001307--[[L%s--]]]:format(level),": ",name1)
    else
      obj_string = Concat(S[302535920001307--[[L%s--]]]:format(level),": ",name1," (",name2,")")
    end
    for key,value in pairs(obj) do
      local key_str,key_type = ReturnStr(key)
      local value_str,value_type = ReturnStr(value)

--~       if key_str:find(str) or value_str:find(str) then
      if key_str:find_lower(str) or value_str:find_lower(str) then
        -- makes dupes
        -- found_objs[#found_objs+1] = obj
        -- should be decent enough?
        if not found_objs[obj_string] then
          found_objs[obj_string] = obj
        end
      else
        if key_type == "table" then
          self:RetObjects(key,str,limit,level+1)
        elseif value_type == "table" then
          self:RetObjects(value,str,limit,level+1)
        end
      end

    end
  end

end --RetObjects

function ChoGGi_FindValueDlg:idEditOnKbdKeyDown(obj,vk)
  if vk == const.vkEnter then
    self:FindText()
    return "break"
  elseif vk == const.vkEsc then
    self.idCloseX:Press()
    return "break"
  end
  return ChoGGi_TextInput.OnKbdKeyDown(obj, vk)
end
