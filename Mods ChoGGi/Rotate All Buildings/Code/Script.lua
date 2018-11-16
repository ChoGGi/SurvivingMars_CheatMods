function OnMsg.ModsReloaded()
	for _,bld in pairs(ClassTemplates.Building) do
		bld.can_rotate_during_placement = true
	end
end
