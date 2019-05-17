function TriboelectricScrubber:CleanBuildings()
  if not self.working then
    return
  end
  self:ForEachDirtyInRange(function(dirty, self)
    if dirty:IsKindOf("Building") then
      if dirty ~= self then
        if dirty:IsKindOf("DustGridElement") then
          dirty:AddDust(-self.dust_clean)
--~         elseif not dirty.parent_dome then
        else
          dirty:AccumulateMaintenancePoints(-self.dust_clean)
        end
      end
    elseif dirty:IsKindOf("DroneBase") then
      dirty:AddDust(-self.dust_clean)
    end
  end, self)
end
