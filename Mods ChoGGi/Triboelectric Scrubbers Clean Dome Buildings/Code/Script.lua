
function TriboelectricScrubber:CleanBuildings()
	if not self.working then
		return
	end

	self:ForEachDirtyInRange(function(dirty, self)
		if dirty ~= self then
			if dirty:IsKindOf("Building") then
					if dirty:IsKindOf("DustGridElement") then
						dirty:AddDust(-self.dust_clean)
--~ 					elseif not dirty.parent_dome and dirty.accumulate_maintenance_points then
					elseif dirty.accumulate_maintenance_points then
						dirty:AccumulateMaintenancePoints(-self.dust_clean)
					end
			elseif dirty:IsKindOf("DroneBase") then
				dirty:AddDust(-self.dust_clean)
			end
		end
	end, self)
end
