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

local ChoOrig_StirlingGenerator_OnChangeState = StirlingGenerator.OnChangeState
function StirlingGenerator:OnChangeState(...)
	return PassthroughHeatUpdate(ChoOrig_StirlingGenerator_OnChangeState, self, ...)
end

local ChoOrig_StirlingGenerator_OnSetWorking = StirlingGenerator.OnSetWorking
function StirlingGenerator:OnSetWorking(...)
	return PassthroughHeatUpdate(ChoOrig_StirlingGenerator_OnSetWorking, self, ...)
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
	-- self can be the template/cursor building (or at least it can be in picard)
	if self:IsKindOf("StirlingGenerator") then
		return self:ChoGGi_34Heating()
	end
end



-- Extractors



AddBaseheater(Mine, 2 * const.MaxHeat, 5)
AddBaseheater(WaterExtractor, 2 * const.MaxHeat, 5)



local function AddFueledExtractorHeat(_, cls)
	local ChoOrig_class_OnUpgradeToggled = cls.OnUpgradeToggled
	function cls:OnUpgradeToggled(...)
		return PassthroughHeatUpdate(ChoOrig_class_OnUpgradeToggled, self, ...)
	end

	local ChoOrig_class_OnSetWorking = cls.OnSetWorking
	function cls:OnSetWorking(...)
		return PassthroughHeatUpdate(ChoOrig_class_OnSetWorking, self, ...)
	end

	function cls:UpdateHeat()
		self:ApplyHeat(self.working and self:IsUpgradeOn(self.template_name .. "_FueledExtractor"))
	end
	function cls:GetHeatRange()
		return const.AdvancedStirlingGeneratorHeatRadius * 10 * guim
	end
	function cls:GetHeatBorder()
		return const.SubsurfaceHeaterFrameRange
	end
	function cls:GetSelectionRadiusScale()
		if self:IsKindOf(cls.class) then
			return const.AdvancedStirlingGeneratorHeatRadius
		end
	end
end

function OnMsg.ClassesPostprocess()
	AddFueledExtractorHeat(nil, WaterExtractor)
	ClassDescendantsList("Mine", AddFueledExtractorHeat)
end
