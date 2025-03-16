-- See LICENSE for terms

local RebuildInfopanel = RebuildInfopanel

local mod_EnableMod

local ChoOrig_RequiresMaintenance_IsMaintenancePrevented = RequiresMaintenance.IsMaintenancePrevented
function RequiresMaintenance:IsMaintenancePrevented(...)
	if not mod_EnableMod then
		return ChoOrig_RequiresMaintenance_IsMaintenancePrevented(self, ...)
	end

  return self.ChoGGi_MaintenancePrevented
end

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local function ToggleMainCycle(bld)
	if bld.ChoGGi_MaintenancePrevented then
		bld.ChoGGi_MaintenancePrevented = nil
		-- Call a drone
		if bld:GetMaintenanceProgress() > 99 then
			bld:RequestMaintenance(true)
			RebuildInfopanel(bld)
		end
	else
		bld.ChoGGi_MaintenancePrevented = true
	end
end

function OnMsg.ClassesPostprocess()
	local xtemplate = XTemplates.ipBuilding[1]

	-- Check for and remove existing template
	ChoGGi_Funcs.Common.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_IsMaintenancePreventedToggle_button", true)

	xtemplate[#xtemplate+1] = PlaceObj("XTemplateTemplate", {
		"Id" , "ChoGGi_Template_IsMaintenancePreventedToggle_button",
		-- No need to add this (I use it for my RemoveXTemplateSections func)
		"ChoGGi_Template_IsMaintenancePreventedToggle_button", true,
		-- The button only shows when the class object is selected
		"__context_of_kind", "RequiresMaintenance",
		-- Section button (see Source\Lua\XTemplates\Infopanel*.lua for more examples)
		"__template", "InfopanelActiveSection",
		-- Only show button when it meets the req
		"__condition", function(_, context)
			return mod_EnableMod and IsValid(context)
		end,
		--
		"OnContextUpdate", function(self, context)
			--
			if context.ChoGGi_MaintenancePrevented then
				self:SetIcon("UI/Icons/traits_disapprove.tga")
			else
				self:SetIcon("UI/Icons/traits_approve.tga")
			end
			--
		end,

		"Title", T(0000, "Toggle Maintenance"),
		"RolloverTitle", T(0000, "Toggle Allow Maintenance"),
		"RolloverText", T(0000, [[If turned off then drones will not maintain building.

Ctrl-<left_click> to toggle all buildings of same type.]]),
		"Icon", "UI/Icons/IPButtons/traits_approve.tga",
		}, {
		PlaceObj("XTemplateFunc", {
			"name", "OnActivate(self, context)",
			"parent", function(self)
				return self.parent
			end,
			"func", function(_, context)
				--
				if IsMassUIModifierPressed() then
					-- ctrl + left click
					local label = ChoGGi_Funcs.Common.RetTemplateOrClass(context)
					local objs = context.city and context.city.labels[label] or ""
					for i = 1, #objs do
						ToggleMainCycle(objs[i])
					end
				else
					-- left click
					ToggleMainCycle(context)
				end
				--
			end,
		}),
	})

end
