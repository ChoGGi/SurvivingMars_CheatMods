-- See LICENSE for terms

local IsValid = IsValid
local DoneObject = DoneObject
local SelectionMouseObj = SelectionMouseObj
local GetTerrainCursorObj = GetTerrainCursorObj

local orig_CanDemolish = DemolishModeDialog.CanDemolish
function DemolishModeDialog:CanDemolish(pt, obj, ...)
	obj = obj or SelectionMouseObj() or GetTerrainCursorObj()
	if IsValid(obj) and obj:IsKindOf("VegetationObject") then
		return true
	end

	return orig_CanDemolish(self, pt, obj, ...)
end

local orig_OnMouseButtonDown = DemolishModeDialog.OnMouseButtonDown
function DemolishModeDialog:OnMouseButtonDown(pt, button, obj, ...)
	if button == "L" then
		obj = obj or SelectionMouseObj() or GetTerrainCursorObj()
		if IsValid(obj) and obj:IsKindOf("VegetationObject") then
			DoneObject(obj)
			return "break"
		end
	end

	return orig_OnMouseButtonDown(self, pt, button, obj, ...)
end
