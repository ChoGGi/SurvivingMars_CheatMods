-- See LICENSE for terms

local skips = {
	"Elevator",
}

local ChoOrig_ConstructionSite_Complete = ConstructionSite.Complete
function ConstructionSite:Complete(...)
	-- grab priority before site is removed
	local priority = self.priority
	-- returns the building
	local ret_obj = ChoOrig_ConstructionSite_Complete(self, ...)
	-- who knows...
	if not ret_obj:IsKindOfClasses(skips) then
		-- and apply it to the new bld
		ret_obj:SetPriority(priority)
	end
	-- I wrapped it in a table, just incase devs add something
	return ret_obj
end
