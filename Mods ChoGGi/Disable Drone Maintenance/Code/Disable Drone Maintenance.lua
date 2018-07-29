local T = DisableDroneMaintenance.ComFuncs.Trans
local Concat = DisableDroneMaintenance.ComFuncs.Concat
local RetName = DisableDroneMaintenance.ComFuncs.RetName
local PopupToggle = DisableDroneMaintenance.ComFuncs.PopupToggle

local rawget = rawget

local XTemplates = XTemplates
local PlaceObj = PlaceObj

function OnMsg.ClassesGenerate()

  local orig_RequiresMaintenance_RequestMaintenance = RequiresMaintenance.RequestMaintenance
  --only allow main if disable isn't
  function RequiresMaintenance:RequestMaintenance()
    if not self.ChoGGi_DisableMaintenance then
      orig_RequiresMaintenance_RequestMaintenance(self)
    end
  end

end

function OnMsg.ClassesBuilt()

  --don't add if button already added
  if not XTemplates.ipBuilding.ChoGGi_DisableMaintenance then
    XTemplates.ipBuilding.ChoGGi_DisableMaintenance = true

    XTemplates.ipBuilding[1][#XTemplates.ipBuilding[1]+1] = PlaceObj("XTemplateTemplate", {
      "ChoGGi_DisableMaintenance", true,
      "__context_of_kind", "Building",
      "__template", "InfopanelSection",
      --only show up for buildings that need maintenance
      "__condition", function (parent, context) return context:DoesRequireMaintenance() end,
      "RolloverTitle", " ",
      "RolloverHint",  "",
      "OnContextUpdate", function(self, context)
        if context.ChoGGi_DisableMaintenance then
          self:SetRolloverText(Concat("This ",RetName(context)," will not be maintained (press for menu)."))
          self:SetTitle("Maintenance Disabled")
          self:SetIcon("UI/Icons/traits_disapprove.tga")
        else
          self:SetRolloverText(Concat("This ",RetName(context)," will be maintained (press for menu)."))
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
          local popup = rawget(terminal.desktop, "idDisableDroneMaintenanceMenu")
          if popup then
            popup:Close()
          else
            PopupToggle(self,"idDisableDroneMaintenanceMenu",{
              {
                name = Concat("Toggle maintenance on this ",RetName(context)," only."),
                hint = Concat("Toggles maintenance on only this ",RetName(context),"."),
                class = "XTextButton",
                clicked = function()
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
                end,
              },
              {
                name = Concat("Toggle maintenance on all ",RetName(context),"."),
                hint = Concat("Toggles maintenance on all ",RetName(context)," (all will be set the same as this one)."),
                class = "XTextButton",
                clicked = function()
                  local objs = UICity.labels[context.class] or ""
                  if context.ChoGGi_DisableMaintenance then
                    for i = 1, #objs do
                      objs[i].ChoGGi_DisableMaintenance = nil
                      --and check if building is malfunctioned then call a fix
                      if objs[i].accumulated_maintenance_points == objs[i].maintenance_threshold_current then
                        objs[i]:RequestMaintenance()
                      end
                    end
                  else
                    for i = 1, #objs do
                      objs[i].ChoGGi_DisableMaintenance = true
                    end
                  end
                end,
              },
            })
          end
          ---
        end
      })
    })

  end --if

end --OnMsg
