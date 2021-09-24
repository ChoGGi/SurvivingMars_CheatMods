-- See LICENSE for terms

-- local ChoOrig_ForestationPlant_GetTerraformingBoostSol = ForestationPlant.GetTerraformingBoostSol
function ForestationPlant:GetTerraformingBoostSol(...)
--~   if GetTerraformParam(self.terraforming_param) < self.vegetation_terraforming_threshold then
    return self.terraforming_boost_sol
--~   end
--~   return 0
end
