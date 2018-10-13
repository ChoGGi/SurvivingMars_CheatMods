-- See LICENSE for terms

-- tell people know how to get the library
function OnMsg.ModsReloaded()
	local min_version = 21

	local ModsLoaded = ModsLoaded
	local not_found_or_wrong_version
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")

	if idx then
		-- steam updates automatically
		if not Platform.steam and min_version > ModsLoaded[idx].version then
			not_found_or_wrong_version = true
		end
	else
		not_found_or_wrong_version = true
	end

	if not_found_or_wrong_version then
		CreateRealTimeThread(function()
			local Sleep = Sleep
			while not UICity do
				Sleep(2500)
			end
			if WaitMarsQuestion(nil,nil,string.format([[Error: Restore Request Main requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
			end
		end)
	end
end

-- generate is late enough that my library is loaded, but early enough to replace anything i need to
function OnMsg.ClassesGenerate()

	-- removed functions
	local T = T
	local _InternalTranslate = _InternalTranslate
	local RebuildInfopanel = RebuildInfopanel
	local StringFormat = string.format

	function RequiresMaintenance:GetUIRequestMaintenanceStatus()
		local status
		if self.accumulated_maintenance_points > 0 then
			if self.maintenance_phase == false then
				status = _InternalTranslate(T{7329, "Maintenance needed"})
			else
				status = _InternalTranslate(T{389, "Maintenance already requested"})
			end
			return StringFormat("%s, Remaining: %s",status,self.maintenance_threshold_current - self.accumulated_maintenance_points)
		end
		return T{390, "No deterioration"}
	end
	function RequiresMaintenance:UIRequestMaintenance()
		RebuildInfopanel(self)
		return self:RequestMaintenance(true)
	end

end

function OnMsg.ClassesBuilt()

	if XTemplates.ipBuilding.ChoGGi_RestoreMain then
		table.remove(XTemplates.ipBuilding[1][1],#XTemplates.ipBuilding[1][1])
		XTemplates.ipBuilding.ChoGGi_RestoreMain = nil
	end
	local PlayFX = PlayFX
	local IsKindOf = IsKindOf

	-- restore the button
	ChoGGi.ComFuncs.RemoveXTemplateSections(XTemplates.ipBuilding[1][1],"ChoGGi_RestoreMaintenance")
	XTemplates.ipBuilding[1][1][#XTemplates.ipBuilding[1][1]+1] = PlaceObj("XTemplateTemplate", {
		"ChoGGi_RestoreMaintenance", true,
		"__condition", function(parent, context)
			return IsKindOf(context, "RequiresMaintenance") and context:DoesRequireMaintenance()
		end,
		"__template", "InfopanelButton",
		"RolloverText", T{182273828429, "Request maintenance from nearby Drones. The required maintenance resource must be available in the area.<newline><newline>Status: <em><UIRequestMaintenanceStatus></em>"},
		"RolloverDisabledText", T{513214256397, "Maintenance already requested."},
		"RolloverTitle", T{425734571364, "Request Maintenance"},
		"RolloverHint", T{238148642034, "<left_click> Activate <newline><em>Ctrl + <left_click></em> Activate for all <display_name_pl>"},
		"RolloverHintGamepad", T{919224409562, "<ButtonA> Activate <newline><ButtonX> Activate for all <display_name_pl>"},
		"OnContextUpdate", function(self, context)
			-- changed it so it only shows the button when main is needed/requested
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
