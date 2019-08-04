-- See LICENSE for terms

function OnMsg.ModsReloaded()
	local buildings = ClassTemplates.Building
	for _, bld in pairs(buildings) do
		bld.can_rotate_during_placement = true
	end
end
