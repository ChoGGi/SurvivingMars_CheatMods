-- See LICENSE for terms

local Actions = ChoGGi.Temp.Actions
local c = #Actions

-- goes to placement mode with SelectedObj or last built object
c = c + 1
Actions[c] = {ActionName = T(302535920001350, "Place Last Selected/Constructed Building"),
	ActionId = "BuildingPlacementOrientation.LastSelectedObject",
	OnAction = ChoGGi.ComFuncs.PlaceLastSelectedConstructedBld,
	ActionShortcut = "Ctrl-Space",
	replace_matching_id = true,
}

local function UpdateLast(obj)
	if obj:IsKindOf("Building") then
		ChoGGi.Temp.LastPlacedObject = obj
	end
end

OnMsg.BuildingPlaced = UpdateLast
OnMsg.ConstructionSitePlaced = UpdateLast
OnMsg.SelectionAdded = UpdateLast

local function StartupCode()
	local IsValid = IsValid
	local table_unpack = table.unpack

	-- set orientation to same as last object
	local orig_ConstructionController_CreateCursorObj = ConstructionController.CreateCursorObj
	function ConstructionController:CreateCursorObj(...)

		local ret = {orig_ConstructionController_CreateCursorObj(self, ...)}
		local last = ChoGGi.Temp.LastPlacedObject
		if self.template_obj and self.template_obj.can_rotate_during_placement and IsValid(last) then
			ret[1]:SetAngle(last:GetAngle() or 0)
		end
		return table_unpack(ret)

	end

end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
