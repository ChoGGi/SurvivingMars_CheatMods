-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
local fire_once
function OnMsg.ModsReloaded()
	if fire_once then
		return
	end
	fire_once = true

	-- version to version check with
	local min_version = 38
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")

	-- if we can't find mod or mod is less then min_version (we skip steam since it updates automatically)
	if not idx or idx and not Platform.steam and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error",string.format([[Disable Drone Maintenance requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
			end
		end)
	end
end

local S
local RetName
local PopupToggle
local RetAllOfClass

-- generate is late enough that my library is loaded
function OnMsg.ClassesGenerate()
	S = ChoGGi.Strings
	RetName = ChoGGi.ComFuncs.RetName
	PopupToggle = ChoGGi.ComFuncs.PopupToggle
	RetAllOfClass = ChoGGi.ComFuncs.RetAllOfClass
end

local orig_RequiresMaintenance_RequestMaintenance = RequiresMaintenance.RequestMaintenance
-- only allow main if disable isn't
function RequiresMaintenance:RequestMaintenance(...)
	if not self.ChoGGi_DisableMaintenance then
		orig_RequiresMaintenance_RequestMaintenance(self,...)
	end
end

local function ToggleMain(obj)
	if obj.ChoGGi_DisableMaintenance then
		-- re-enable main
		obj.ChoGGi_DisableMaintenance = nil

		obj:ResetMaintenanceState()
		obj:RequestMaintenance()
	else
		-- disable it
		obj.ChoGGi_DisableMaintenance = true
		obj:ResetMaintenanceRequests() --zero up reqs and interrupt drones
	end
end

function OnMsg.ClassesBuilt()
	local XTemplates = XTemplates

	-- old version cleanup
	if XTemplates.ipBuilding.ChoGGi_DisableMaintenance then
		ChoGGi.ComFuncs.RemoveXTemplateSections(XTemplates.ipBuilding[1],"ChoGGi_DisableMaintenance")
		XTemplates.ipBuilding.ChoGGi_DisableMaintenance = nil
	end

	ChoGGi.ComFuncs.AddXTemplate("DisableMaintenance","ipBuilding",{
		__context_of_kind = "Building",
		-- only show up for buildings that need maintenance
		__condition = function (parent, context)
			return context:DoesRequireMaintenance()
		end,
		OnContextUpdate = function(self, context)
			local name = RetName(context)
			if context.ChoGGi_DisableMaintenance then
				self:SetRolloverText(string.format([[This %s will not be maintained (press for menu).]],name))
				self:SetTitle("Maintenance Disabled")
				self:SetIcon("UI/Icons/traits_disapprove.tga")
			else
				self:SetRolloverText(string.format([[This %s will be maintained (press for menu).]],name))
				self:SetTitle("Maintenance Enabled")
				self:SetIcon("UI/Icons/traits_approve.tga")
			end
		end,
		func = function(self, context)
			---
			local popup = rawget(terminal.desktop, "idDisableDroneMaintenanceMenu")
			if popup then
				popup:Close()
			else
				local name = RetName(context)
				PopupToggle(self,"idDisableDroneMaintenanceMenu",{
					{
						name = string.format([[Toggle maintenance on this %s only.]],name),
						hint = string.format([[Toggles maintenance on only this %s.]],name),
						clicked = function()
							ToggleMain(context)
						end,
					},
					{
						name = string.format([[Toggle maintenance on all %s.]],name),
						hint = string.format([[Toggles maintenance on all %s (all will be set the same as this one).]],name),
						clicked = function()
							local objs = RetAllOfClass(context.class)
							for i = 1, #objs do
								ToggleMain(objs[i])
							end
						end,
					},
				},"left")
			end
			---
		end,
	})

end --OnMsg
