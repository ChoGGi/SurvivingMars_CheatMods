function OnMsg.ClassesBuilt()
	function TriboelectricScrubber:CleanBuildings()
		if not self.working then
			return
		end

		self:ForEachBuildingInRange(function(building, self)
			if building ~= self then
				if building:IsKindOf("DustGridElement") then
					building:AddDust(-self.dust_clean)
--~				 elseif not building.parent_dome then --outside of dome
				else
					building:AccumulateMaintenancePoints(-self.dust_clean)
				end
				PlayFX("ChargedCleanBuilding", "start", self.sphere, building)
			end
		end, self)
	end
end