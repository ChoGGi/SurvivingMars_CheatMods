function OnMsg.ClassesGenerate()
  function BuildingVisualDustComponent:SetDustVisuals(dust, in_dome)

    if not self.ChoGGi_AlwaysDust or self.ChoGGi_AlwaysDust < dust then
      self.ChoGGi_AlwaysDust = dust
    end
    dust = self.ChoGGi_AlwaysDust

    local normalized_dust = MulDivRound(dust, 255, self.visual_max_dust)
    ApplyToObjAndAttaches(self, SetObjDust, normalized_dust, in_dome)
  end
end

--[[
function OnMsg.LoadGame()
  --dust removal, uncomment and restart the game (or maybe just reload it).
  local objs = local objs = UICity.labels.Building or ""
  for i = 1, #objs do
    objs[i].ChoGGi_AlwaysDust = nil
  end
end
--]]
