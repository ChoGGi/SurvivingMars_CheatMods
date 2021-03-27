-- See LICENSE for terms

local function PassthroughHeatUpdate(func, self, ...)
	func(self, ...)
  self:UpdateHeat()
end

local function AddBaseheater(class, heat, max_neighbors)
	ChoGGi.ComFuncs.AddParentToClass(class, "BaseHeater")
	class.heat = heat
	class.max_neighbors = max_neighbors
end

AddBaseheater(StirlingGenerator, 3 * const.MaxHeat, 10)

local orig_StirlingGenerator_OnChangeState = StirlingGenerator.OnChangeState
function StirlingGenerator:OnChangeState(...)
	return PassthroughHeatUpdate(orig_StirlingGenerator_OnChangeState, self, ...)
end

local orig_StirlingGenerator_OnSetWorking = StirlingGenerator.OnSetWorking
function StirlingGenerator:OnSetWorking(...)
	return PassthroughHeatUpdate(orig_StirlingGenerator_OnSetWorking, self, ...)
end

function StirlingGenerator:ChoGGi_34Heating()
	return (const.AdvancedStirlingGeneratorHeatRadius / 4.0) * 3
end

function StirlingGenerator:UpdateHeat()
  self:ApplyHeat(self.working and self.opened)
end
function StirlingGenerator:GetHeatRange()
  return self:ChoGGi_34Heating() * 10 * guim
end
function StirlingGenerator:GetHeatBorder()
  return const.SubsurfaceHeaterFrameRange
end
function StirlingGenerator:GetSelectionRadiusScale()
  return self:ChoGGi_34Heating()
end



-- Extractors



AddBaseheater(Mine, 2 * const.MaxHeat, 5)
AddBaseheater(WaterExtractor, 2 * const.MaxHeat, 5)



local function AddFueledExtractorHeat(name, class)
	local orig_class_OnUpgradeToggled = class.OnUpgradeToggled
	function class:OnUpgradeToggled(...)
		return PassthroughHeatUpdate(orig_class_OnUpgradeToggled, self, ...)
	end

	local orig_class_OnSetWorking = class.OnSetWorking
	function class:OnSetWorking(...)
		return PassthroughHeatUpdate(orig_class_OnSetWorking, self, ...)
	end

	function class:UpdateHeat()
		self:ApplyHeat(self.working and self:IsUpgradeOn(self.template_name .. "_FueledExtractor"))
	end
	function class:GetHeatRange()
		return const.AdvancedStirlingGeneratorHeatRadius * 10 * guim
	end
	function class:GetHeatBorder()
		return const.SubsurfaceHeaterFrameRange
	end
	function class:GetSelectionRadiusScale()
		return const.AdvancedStirlingGeneratorHeatRadius
	end
end

function OnMsg.ClassesPostprocess()
	AddFueledExtractorHeat(nil, WaterExtractor)
	ClassDescendantsList("Mine", AddFueledExtractorHeat)
end
