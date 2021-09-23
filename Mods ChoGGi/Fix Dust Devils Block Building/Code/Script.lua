-- See LICENSE for terms

local HexGetUnits = HexGetUnits
local GetRealm = GetRealm
local IsKindOf = IsKindOf

local ChoGGi_OnTopOfDustDevil = {
	type = "error",
	priority = 100,
	text = T(0000, "Dust devil rejects your futile attempt of cheese."),
	short = T(0000, "Overlaps dust devil")
}
ConstructionStatus.ChoGGi_OnTopOfDustDevil = ChoGGi_OnTopOfDustDevil

local mod_EnableMod

local orig_FinalizeStatusGathering = ConstructionController.FinalizeStatusGathering
function ConstructionController:FinalizeStatusGathering(...)
	if not mod_EnableMod then
		return orig_FinalizeStatusGathering(self, ...)
	end

	-- shameless copy pasta of function ConstructionController:HasDepositUnderneath()
  local force_extend_bb = self.template_obj:HasMember("force_extend_bb_during_placement_checks") and self.template_obj.force_extend_bb_during_placement_checks ~= 0 and self.template_obj.force_extend_bb_during_placement_checks or false
  local underneath = HexGetUnits(GetRealm(self), self.cursor_obj, self.template_obj:GetEntity(), nil, nil, true, function(o)
    return IsKindOf(o, "BaseDustDevil")
  end, "BaseDustDevil", force_extend_bb, self.template_obj_points)

  if underneath then
		self.construction_statuses[#self.construction_statuses + 1] = ChoGGi_OnTopOfDustDevil
  end

	return orig_FinalizeStatusGathering(self, ...)
end

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

