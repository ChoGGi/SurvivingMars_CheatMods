-- See LICENSE for terms


local Strings = ChoGGi.Strings
local Actions = ChoGGi.Temp.Actions
local c = #Actions

-- goes to placement mode with last built object
c = c + 1
Actions[c] = {ActionName = Strings[302535920001349--[[Place Last Constructed Building--]]],
	ActionId = "BuildingPlacementOrientation.LastConstructedBuilding",
	OnAction = function()
		local last = UICity.LastConstructedBuilding
		if type(last) == "table" then
			ChoGGi.ComFuncs.ConstructionModeSet(last.template_name ~= "" and last.template_name or last:GetEntity())
		end
	end,
	ActionShortcut = "Ctrl-Space",
	replace_matching_id = true,
}

-- goes to placement mode with SelectedObj
c = c + 1
Actions[c] = {ActionName = Strings[302535920001350--[[Place Last Selected Object--]]],
	ActionId = "BuildingPlacementOrientation.LastSelectedObject",
	OnAction = function()
		local ChoGGi = ChoGGi
		local obj = ChoGGi.ComFuncs.SelObject()
		if type(obj) == "table" then
			ChoGGi.Temp.LastPlacedObject = obj
			ChoGGi.ComFuncs.ConstructionModeNameClean(ValueToLuaCode(obj))
		end
	end,
	ActionShortcut = "Ctrl-Shift-Space",
	replace_matching_id = true,
}

function OnMsg.BuildingPlaced(obj)
	if obj:IsKindOf("Building") then
		ChoGGi.Temp.LastPlacedObject = obj
	end
end --OnMsg
function OnMsg.ConstructionSitePlaced(obj)
	if obj:IsKindOf("Building") then
		ChoGGi.Temp.LastPlacedObject = obj
	end
end --OnMsg
function OnMsg.SelectionAdded(obj)
	-- update last placed (or selected)
	if obj:IsKindOf("Building") then
		ChoGGi.Temp.LastPlacedObject = obj
	end
end

local function StartupCode()
	ChoGGi.ComFuncs.SaveOrigFunc("ConstructionController","CreateCursorObj")
	local ConstructionController_CreateCursorObj = ChoGGi.OrigFuncs.ConstructionController_CreateCursorObj

	local IsValid = IsValid
	local SetRollPitchYaw = SetRollPitchYaw
	local table_unpack = table.unpack
	-- set orientation to same as last object
	function ConstructionController:CreateCursorObj(...)

		local ret = {ConstructionController_CreateCursorObj(self, ...)}
		local last = ChoGGi.Temp.LastPlacedObject
		if self.template_obj and self.template_obj.can_rotate_during_placement and IsValid(last) then
			SetRollPitchYaw(ret[1],0,0,(last:GetAngle() or 0) + -1*60*60)
		end
		return table_unpack(ret)

	end

end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
