
function OnMsg.ClassesGenerate()
  --only allow main if disable isn't
  local orig_RequiresMaintenance_RequestMaintenance = RequiresMaintenance.RequestMaintenance
  function RequiresMaintenance:RequestMaintenance()
    if not self.ChoGGi_DisableMaintenance then
      orig_RequiresMaintenance_RequestMaintenance(self)
    end
  end

end

function OnMsg.ClassesBuilt()

  --local is faster then global (assuming you call it more then once)
  local XT = XTemplates
  local PlaceObj = PlaceObj

  --don't add if button already added
  if not XT.ipBuilding.ChoGGi_DisableMaintenance then
    XT.ipBuilding.ChoGGi_DisableMaintenance = true

    XT.ipBuilding[1][#XT.ipBuilding[1]+1] = PlaceObj("XTemplateTemplate", {
      "__context_of_kind", "Building",
      "__template", "InfopanelSection",
      --only show up for buildings that need maintenance
      "__condition", function (parent, context) return context:DoesRequireMaintenance() end,
      "RolloverTitle", " ",
      "RolloverHint",  "",
      "OnContextUpdate", function(self, context)
        if context.ChoGGi_DisableMaintenance then
          self:SetRolloverText("This building will not be maintained.")
          self:SetTitle("Maintenance Disabled")
          self:SetIcon("UI/Icons/traits_disapprove.tga")
        else
          self:SetRolloverText("This building will be maintained.")
          self:SetTitle("Maintenance Enabled")
          self:SetIcon("UI/Icons/traits_approve.tga")
        end
      end
    }, {
      PlaceObj("XTemplateFunc", {
        "name", "OnActivate(self, context)",
        "parent", function(parent, context)
          return parent.parent
        end,
        "func", function(self, context)
          ---
          if context.ChoGGi_DisableMaintenance then
            --re-enable main
            context.ChoGGi_DisableMaintenance = nil
            --and check if building is malfunctioned then call a fix
            if context.accumulated_maintenance_points == context.maintenance_threshold_current then
              context:RequestMaintenance()
            end
          else
            --disable it
            context.ChoGGi_DisableMaintenance = true
          end

          ---
        end
      })
    })

  end --if

end --OnMsg
