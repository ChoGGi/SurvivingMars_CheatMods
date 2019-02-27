-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 56
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error","Restore Request Main requires ChoGGi's Library (at least v" .. min_version .. [[).
Press OK to download it or check the Mod Manager to make sure it's enabled.]]) == "ok" then
				if p.steam then
					OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
				elseif p.pops then
					OpenUrl("https://mods.paradoxplaza.com/mods/505/Any")
				else
					OpenUrl("https://www.nexusmods.com/survivingmars/mods/89?tab=files")
				end
			end
		end)
	end
end

local RebuildInfopanel = RebuildInfopanel
local T = T
local PlayFX = PlayFX
local IsKindOf = IsKindOf

-- generate is late enough that my library is loaded, but early enough to replace anything i need to
function OnMsg.ClassesGenerate()
	-- removed functions
	local Trans = ChoGGi.ComFuncs.Translate

	function RequiresMaintenance:GetUIRequestMaintenanceStatus()
		local status
		if self.accumulated_maintenance_points > 0 then
			if self.maintenance_phase == false then
				status = Trans(7329--[[Maintenance needed--]])
			else
				status = Trans(389--[[Maintenance already requested--]])
			end
			return status .. ", Remaining: " .. (self.maintenance_threshold_current - self.accumulated_maintenance_points)
		end
		return T(390, "No deterioration")
	end
	function RequiresMaintenance:UIRequestMaintenance()
		RebuildInfopanel(self)
		return self:RequestMaintenance(true)
	end

end

function OnMsg.ClassesBuilt()

	-- old version cleanup
	if XTemplates.ipBuilding.ChoGGi_RestoreMain then
		XTemplates.ipBuilding.ChoGGi_RestoreMain = nil
	end

	-- restore the button
	ChoGGi.ComFuncs.RemoveXTemplateSections(XTemplates.ipBuilding[1][1],"ChoGGi_RestoreMaintenance")
	XTemplates.ipBuilding[1][1][#XTemplates.ipBuilding[1][1]+1] = PlaceObj("XTemplateTemplate", {
		"ChoGGi_RestoreMaintenance", true,
		"__condition", function(parent, context)
			return IsKindOf(context, "RequiresMaintenance") and context:DoesRequireMaintenance()
		end,
		"__template", "InfopanelButton",
		"RolloverText", T(182273828429, "Request maintenance from nearby Drones. The required maintenance resource must be available in the area.<newline><newline>Status: <em><UIRequestMaintenanceStatus></em>"),
		"RolloverDisabledText", T(513214256397, "Maintenance already requested."),
		"RolloverTitle", T(425734571364, "Request Maintenance"),
		"RolloverHint", T(238148642034, "<left_click> Activate <newline><em>Ctrl + <left_click></em> Activate for all <display_name_pl>"),
		"RolloverHintGamepad", T(919224409562, "<ButtonA> Activate <newline><ButtonX> Activate for all <display_name_pl>"),
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
