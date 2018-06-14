local XTemplates,PlaceObj,SelectionArrowAdd = XTemplates,PlaceObj,SelectionArrowAdd

local g_Classes = g_Classes

function OnMsg.ClassesBuilt()
  if not XTemplates.ipCable then
    PlaceObj('XTemplate', {
      group = "Infopanel Sections",
      id = "ipCable",
      PlaceObj('XTemplateTemplate', {
        '__context_of_kind', "ElectricityGridElement",
        '__condition', function (parent, context) return context.is_hub or not context.is_switch end,
        '__template', "Infopanel",
        'Description', T{313911890683, --[[XTemplate ipSwitch Description]] "<description>"},
      }, {
      PlaceObj('XTemplateTemplate', {
        'comment', "salvage",
        '__template', "InfopanelButton",
        'RolloverText', T{640016954592, --[[XTemplate ipSwitch RolloverText]] "Remove this switch or valve."},
        'RolloverTitle', T{3973, --[[XTemplate ipSwitch RolloverTitle]] "Salvage"},
        'RolloverHintGamepad', T{7657, --[[XTemplate ipSwitch RolloverHintGamepad]] "<ButtonY> Activate"},
        'ContextUpdateOnOpen', false,
        'OnPressParam', "Demolish",
        'Icon', "UI/Icons/IPButtons/salvage_1.tga",
      }, {
          PlaceObj('XTemplateFunc', {
            'name', "OnXButtonDown(self, button)",
            'func', function (self, button)
              if button == "ButtonY" then
                return self:OnButtonDown(false)
              elseif button == "ButtonX" then
                return self:OnButtonDown(true)
              end
              return (button == "ButtonA") and "break"
            end,
          }),
          PlaceObj('XTemplateFunc', {
            'name', "OnXButtonUp(self, button)",
            'func', function (self, button)
              if button == "ButtonY" then
                return self:OnButtonUp(false)
              elseif button == "ButtonX" then
                return self:OnButtonUp(true)
              end
              return (button == "ButtonA") and "break"
            end,
          }),
        }),
      }),
    })
  end --XTemplates

  --we need to return our new infopanel (if it isn't another panel)
  local orig_ElectricityGridElement_GetInfopanelTemplate = g_Classes.ElectricityGridElement.GetInfopanelTemplate
  function g_Classes.ElectricityGridElement:GetInfopanelTemplate()
    local ret = orig_ElectricityGridElement_GetInfopanelTemplate(self)
    if not ret then
      return "ipCable"
    end
    return ret
  end

  --so we know something is selected
  function g_Classes.ElectricityGridElement:OnSelected()
    SelectionArrowAdd(self)
  end

end --OnMsg
