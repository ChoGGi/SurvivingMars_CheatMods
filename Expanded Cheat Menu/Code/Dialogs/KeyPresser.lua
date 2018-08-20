-- See LICENSE for terms

DefineClass.ChoGGi_KeyPresserDlg = {
  __parents = {"ChoGGi_Window"},
}

const.vkLeftWin_ChoGGi = 92
const.vkContext_ChoGGi = 93
const.vkNumpadOff5_ChoGGi = 12
if not VKStrNames[92] then
  VKStrNames[92] = [[vkLeftWin_ChoGGi]]
end
if not VKStrNames[93] then
  VKStrNames[93] = [[vkContext_ChoGGi]]
end
if not VKStrNames[12] then
  VKStrNames[12] = [[vkNumpadOff5_ChoGGi]]
end

function ChoGGi_KeyPresserDlg:Init(parent, context)
  local g_Classes = g_Classes

  self.dialog_width = 500
  self.dialog_height = 300
  self.title = [[Key Presser]]

  -- By the Power of Grayskull!
  self:AddElements(parent, context)

  self:AddScrollEdit()
  self.idEdit:SetFocus()
  self.idEdit:SetText([[See what shows up in the console log when you press different keys]])

  -- let us override enter/esc
  self.idEdit.OnKbdKeyDown = function(obj, vk)
    print("vk:",vk,"key:",VKStrNames[vk])
    return g_Classes.ChoGGi_MultiLineEdit.OnKbdKeyDown(obj, vk)
  end

  self:SetInitPos(context.parent)
end

