local unpack = rawget(_G,"unpack") or table.unpack

local orig_ConstructionSite_Complete = ConstructionSite.Complete
function ConstructionSite:Complete(...)
	-- grab priority before site is removed
	local priority = self.priority
	-- returns the building
	local ret_obj = {orig_ConstructionSite_Complete(self,...)}
	-- and apply it to the new bld
	ret_obj[1]:SetPriority(priority)
	-- i wrapped it in a table, just incase devs add something
	return unpack(ret_obj)
end
