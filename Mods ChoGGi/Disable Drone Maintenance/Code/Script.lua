-- See LICENSE for terms

--~ local Strings = ChoGGi.Strings
local RetName = ChoGGi.ComFuncs.RetName
local PopupToggle = ChoGGi.ComFuncs.PopupToggle
local RetAllOfClass = ChoGGi.ComFuncs.RetAllOfClass

local orig_RequiresMaintenance_RequestMaintenance = RequiresMaintenance.RequestMaintenance
-- only allow main if disable isn't
function RequiresMaintenance:RequestMaintenance(...)
	if not self.ChoGGi_DisableMaintenance then
		orig_RequiresMaintenance_RequestMaintenance(self, ...)
	end
end

local function ToggleMain(obj)
	obj.maintenance_phase = false
	if obj.ChoGGi_DisableMaintenance then
		-- re-enable main
		obj.ChoGGi_DisableMaintenance = nil
		-- reset main requests (thanks mk-fg)
		obj:AccumulateMaintenancePoints(0)
		-- and check if building is malfunctioned then call a fix
		if obj.accumulated_maintenance_points == obj.maintenance_threshold_current then
			obj:RequestMaintenance()
		end
	else
		-- disable it
		obj.ChoGGi_DisableMaintenance = true
		-- reset main requests (thanks mk-fg)
		obj:ResetMaintenanceRequests()
	end
end

function OnMsg.ClassesBuilt()
	local XTemplates = XTemplates

	-- old version cleanup
	if XTemplates.ipBuilding.ChoGGi_DisableMaintenance then
		ChoGGi.ComFuncs.RemoveXTemplateSections(XTemplates.ipBuilding[1], "ChoGGi_DisableMaintenance")
		XTemplates.ipBuilding.ChoGGi_DisableMaintenance = nil
	end

	ChoGGi.ComFuncs.AddXTemplate("DisableMaintenance", "ipBuilding", {
		__context_of_kind = "Building",
		-- only show up for buildings that need maintenance
		__condition = function (_, context)
			return context:IsKindOf("RequiresMaintenance") and context:DoesRequireMaintenance()
		end,
		OnContextUpdate = function(self, context)
			local name = RetName(context)
			if context.ChoGGi_DisableMaintenance then
				self:SetRolloverText("This " .. name .. " will not be maintained (press for menu).")
				self:SetTitle("Maintenance Disabled")
				self:SetIcon("UI/Icons/traits_disapprove.tga")
			else
				self:SetRolloverText("This " .. name .. " will be maintained (press for menu).")
				self:SetTitle("Maintenance Enabled")
				self:SetIcon("UI/Icons/traits_approve.tga")
			end
		end,
		func = function(self, context)
			---
			local popup = terminal.desktop.idDisableDroneMaintenanceMenu
			if popup then
				popup:Close()
			else
				local name = RetName(context)
				PopupToggle(self, "idDisableDroneMaintenanceMenu", {
					{
						name = "Toggle maintenance on this " .. name .. " only.",
						hint = "Toggles maintenance on only this " .. name .. ".",
						clicked = function()
							ToggleMain(context)
						end,
					},
					{
						name = "Toggle maintenance on all " .. name .. ".",
						hint = "Toggles maintenance on all " .. name .. " (all will be set the same as this one).",
						clicked = function()
							local objs = RetAllOfClass(context.class)
							for i = 1, #objs do
								ToggleMain(objs[i])
							end
						end,
					},
				}, "left")
			end
			---
		end,
	})

end --OnMsg
