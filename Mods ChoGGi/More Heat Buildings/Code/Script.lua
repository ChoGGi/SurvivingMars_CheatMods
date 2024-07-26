-- See LICENSE for terms

local AdvancedStirlingGeneratorHeatRadius
if g_AvailableDlc.gagarin then
	AdvancedStirlingGeneratorHeatRadius = const.AdvancedStirlingGeneratorHeatRadius
else
	AdvancedStirlingGeneratorHeatRadius = 6
end

local function PassthroughHeatUpdate(func, self, ...)
	func(self, ...)
  self:UpdateHeat()
end

local function AddBaseheater(class, heat)
	ChoGGi_Funcs.Common.AddParentToClass(class, "BaseHeater")
	class.heat = heat
end

AddBaseheater(StirlingGenerator, 3 * const.MaxHeat)

local ChoOrig_StirlingGenerator_OnChangeState = StirlingGenerator.OnChangeState
function StirlingGenerator:OnChangeState(...)
	return PassthroughHeatUpdate(ChoOrig_StirlingGenerator_OnChangeState, self, ...)
end

local ChoOrig_StirlingGenerator_OnSetWorking = StirlingGenerator.OnSetWorking
function StirlingGenerator:OnSetWorking(...)
	return PassthroughHeatUpdate(ChoOrig_StirlingGenerator_OnSetWorking, self, ...)
end

function StirlingGenerator:ChoGGi_34Heating()
	return (AdvancedStirlingGeneratorHeatRadius / 4.0) * 3
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
AddBaseheater(Mine, 2 * const.MaxHeat)
AddBaseheater(WaterExtractor, 2 * const.MaxHeat)
-- terraforming stuff
if g_AvailableDlc.armstrong then
	AddBaseheater(CarbonateProcessor, 4 * const.MaxHeat)
	AddBaseheater(GHGFactory, 5 * const.MaxHeat)
end
-- nuclar powar!
AddBaseheater(FusionReactor, 16 * const.MaxHeat)

local function AddFueledExtractorHeat(_, cls, upgrade, radius)
	local ChoOrig_class_OnUpgradeToggled = cls.OnUpgradeToggled
	function cls:OnUpgradeToggled(...)
		return PassthroughHeatUpdate(ChoOrig_class_OnUpgradeToggled, self, ...)
	end

	local ChoOrig_class_OnSetWorking = cls.OnSetWorking
	function cls:OnSetWorking(...)
		return PassthroughHeatUpdate(ChoOrig_class_OnSetWorking, self, ...)
	end

	function cls:UpdateHeat()
		return self:ApplyHeat(
			self.working and self:IsUpgradeOn(self.template_name .. (upgrade or "_FueledExtractor"))
		)
	end
	function cls:GetHeatRange()
		return AdvancedStirlingGeneratorHeatRadius * (radius or 8) * guim
	end
	function cls:GetHeatBorder()
		return const.SubsurfaceHeaterFrameRange
	end
	function cls:GetSelectionRadiusScale()
		if self:IsKindOf(cls.class) then
			return AdvancedStirlingGeneratorHeatRadius
		end
	end
end
-- Don't check for upgrade
local function UpdateHeat_Working(self)
	return self:ApplyHeat(self.working)
end

function OnMsg.ClassesPostprocess()
	AddFueledExtractorHeat(nil, WaterExtractor)
	ClassDescendantsList("Mine", AddFueledExtractorHeat)

	if g_AvailableDlc.armstrong then
		-- Only works with upgrade enabled
		AddFueledExtractorHeat(nil, CarbonateProcessor, "_Amplify", 10)
		-- override updateheat
		AddFueledExtractorHeat(nil, GHGFactory, nil, 12)
	end
	AddFueledExtractorHeat(nil, FusionReactor, nil, 14)
	-- override updateheat 2
	GHGFactory.UpdateHeat = UpdateHeat_Working
	FusionReactor.UpdateHeat = UpdateHeat_Working

end

--~ function OnMsg.LoadGame()
-- loop through all buildings and :UpdateBuilding()
--~ end
