function OnMsg.ClassesGenerate(classdefs)
  --removed functions
  function RequiresMaintenance:GetUIRequestMaintenanceStatus()
    if self.accumulated_maintenance_points > 0 then
      if self.maintenance_phase == false then
        return T({7329, "Maintenance needed"})
      else
        return T({389, "Maintenance already requested"})
      end
    end
    return T({390, "No deterioration"})
  end
  function RequiresMaintenance:UIRequestMaintenance()
    RebuildInfopanel(self)
    return self:RequestMaintenance(true)
  end

end

function OnMsg.ClassesBuilt()
  --restore the button
  local XT = XTemplates
  local PlayFX = PlayFX
  local IsKindOf = IsKindOf
  local IsMassUIModifierPressed = IsMassUIModifierPressed

  if not XT.ipBuilding.ChoGGi_RestoreMain then
    XT.ipBuilding.ChoGGi_RestoreMain = true

    XT.ipBuilding[1][1][#XT.ipBuilding[1][1]+1] = PlaceObj("XTemplateTemplate", {
      "__condition", function(parent, context)
        return IsKindOf(context, "RequiresMaintenance") and context:DoesRequireMaintenance()
      end,
      "__template", "InfopanelButton",
      "RolloverText", T({182273828429, "Request maintenance from nearby Drones. The required maintenance resource must be available in the area.<newline><newline>Status: <em><UIRequestMaintenanceStatus></em>"}),
      "RolloverDisabledText", T({513214256397, "Maintenance already requested."}),
      "RolloverTitle", T({425734571364, "Request Maintenance"}),
      "RolloverHint", T({238148642034, "<left_click> Activate <newline><em>Ctrl + <left_click></em> Activate for all <display_name_pl>"}),
      "RolloverHintGamepad", T({919224409562, "<ButtonA> Activate <newline><ButtonX> Activate for all <display_name_pl>"}),
      "OnContextUpdate", function(self, context)
        --changed it so it only shows the button when main is needed/requested
        self:SetVisible(context.accumulated_maintenance_points > 0)
        self:SetEnabled(context.accumulated_maintenance_points > 0 and context.maintenance_phase == false)
      end,
      "OnPressParam", "UIRequestMaintenance",
      "OnPress", function(self, gamepad)
        PlayFX("UIRequestMaintenance")
        self.context:UIRequestMaintenance(not gamepad and IsMassUIModifierPressed())
      end,
      "AltPress", true,
      "OnAltPress", function(self, gamepad)
        if gamepad then
          self.context:UIRequestMaintenance(true)
        end
      end,
      "Icon", "UI/Icons/IPButtons/rebuild.tga"
    })
  end
end
