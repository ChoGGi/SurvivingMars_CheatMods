-- See LICENSE for terms

-- tell people know how to get the library
function OnMsg.ModsReloaded()
	local min_version = 19

	local ModsLoaded = ModsLoaded
	local not_found_or_wrong_version
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")

	if idx then
		if min_version > ModsLoaded[idx].version then
			not_found_or_wrong_version = true
		end
	else
		not_found_or_wrong_version = true
	end

	if not_found_or_wrong_version then
		CreateRealTimeThread(function()
			local Sleep = Sleep
			while not UICity do
				Sleep(1000)
			end
			if WaitMarsQuestion(nil,nil,string.format([[Error: This mod requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],library_version)) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
			end
		end)
	end
end

-- generate is late enough that my library is loaded, but early enough to replace anything i need to
function OnMsg.ClassesGenerate()

	local S = ChoGGi.Strings
	local RetName = ChoGGi.ComFuncs.RetName
	local PopupToggle = ChoGGi.ComFuncs.PopupToggle

	local orig_RequiresMaintenance_RequestMaintenance = RequiresMaintenance.RequestMaintenance
	-- only allow main if disable isn't
	function RequiresMaintenance:RequestMaintenance()
		if not self.ChoGGi_DisableMaintenance then
			orig_RequiresMaintenance_RequestMaintenance(self)
		end
	end

	function OnMsg.ClassesBuilt()
		local XTemplates = XTemplates

		if XTemplates.ipBuilding.ChoGGi_DisableMaintenance then
			table.remove(XTemplates.ipBuilding[1],#XTemplates.ipBuilding[1])
			XTemplates.ipBuilding.ChoGGi_DisableMaintenance = nil
		end
		ChoGGi.ComFuncs.RemoveXTemplateSections(XTemplates.ipBuilding[1],"ChoGGi_DisableMaintenance")

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
							name = string.format([[Toggle maintenance on all %s.]],name),
							hint = string.format([[Toggles maintenance on all %s (all will be set the same as this one).]],name),
							clicked = function()
								local objs = UICity.labels[context.class] or ""
								if context.ChoGGi_DisableMaintenance then
									for i = 1, #objs do
										objs[i].ChoGGi_DisableMaintenance = nil
										-- and check if building is malfunctioned then call a fix
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
					},"left")
				end
				---
			end,
		})

	end --OnMsg

end
