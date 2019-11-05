-- See LICENSE for terms

-- removed functions
function RequiresMaintenance:GetUIRequestMaintenanceStatus()
	local status
	if self.accumulated_maintenance_points > 0 then
		if self.maintenance_phase == false then
			status = T(10878, "Maintenance needed")
		else
			status = T(302535920011250, "Maintenance already requested")
		end
		return T{302535920011251,
			"<status>, Remaining: <points>",
			status = status,
			points = self.maintenance_threshold_current - self.accumulated_maintenance_points,
		}
	end
	return T(390, "No deterioration")
end

function RequiresMaintenance:UIRequestMaintenance()
	RebuildInfopanel(self)
	return self:RequestMaintenance(true)
end

-- removed button
function OnMsg.ClassesPostprocess()

	local xt = XTemplates.ipBuilding[1][1]
	ChoGGi.ComFuncs.RemoveXTemplateSections(xt, "ChoGGi_RestoreMaintenance")

	xt[#xt+1] = PlaceObj("XTemplateTemplate", {
		"ChoGGi_RestoreMaintenance", true,
		"__condition", function(_, context)
			return context:IsKindOf("RequiresMaintenance") and context:DoesRequireMaintenance()
		end,
		"__template", "InfopanelButton",
		"RolloverText", T(182273828429, "Request maintenance from nearby Drones. The required maintenance resource must be available in the area.<newline><newline>Status: <em><UIRequestMaintenanceStatus></em>"),
		"RolloverDisabledText", T(513214256397, "Maintenance already requested."),
		"RolloverTitle", T(425734571364, "Request Maintenance"),
		"RolloverHint", T(238148642034, "<left_click> Activate <newline><em>Ctrl + <left_click></em> Activate for all <display_name_pl>"),
		"RolloverHintGamepad", T(919224409562, "<ButtonA> Activate <newline><ButtonX> Activate for all <display_name_pl>"),
		"OnContextUpdate", function(self, context)
			-- changed it so it only shows the button when main is needed/requested
			local points = context.accumulated_maintenance_points > 0
			self:SetVisible(points)
			self:SetEnabled(points and context.maintenance_phase == false)
		end,
		"OnPressParam", "UIRequestMaintenance",
		"OnPress", function(self, gamepad)
			PlayFX("UIRequestMaintenance")
			self.context:UIRequestMaintenance(not gamepad and IsMassUIModifierPressed())
			ObjModified(self.context)
		end,
		"AltPress", true,
		"OnAltPress", function(self, gamepad)
			if gamepad then
				self.context:UIRequestMaintenance(true)
				ObjModified(self.context)
			end
		end,
		"Icon", "UI/Icons/IPButtons/rebuild.tga",
	})
end
