-- See LICENSE for terms

local IsValid = IsValid
local DoneObject = DoneObject
local GetCursorOrGamePadSelectObj = ChoGGi_Funcs.Common.GetCursorOrGamePadSelectObj

local ChoOrig_CanDemolish = DemolishModeDialog.CanDemolish
function DemolishModeDialog:CanDemolish(pt, obj, ...)
	obj = obj or GetCursorOrGamePadSelectObj()
	if IsValid(obj) and obj:IsKindOf("VegetationObject") then
		return true
	end

	return ChoOrig_CanDemolish(self, pt, obj, ...)
end

local ChoOrig_OnMouseButtonDown = DemolishModeDialog.OnMouseButtonDown
function DemolishModeDialog:OnMouseButtonDown(pt, button, obj, ...)
	if button == "L" then
		obj = obj or GetCursorOrGamePadSelectObj()
		if IsValid(obj) and obj:IsKindOf("VegetationObject") then
			DoneObject(obj)
			return "break"
		end
	end

	return ChoOrig_OnMouseButtonDown(self, pt, button, obj, ...)
end
