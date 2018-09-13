-- See LICENSE for terms

function OnMsg.ModsLoaded()
	if not table.find(ModsLoaded,"id","ChoGGi_Library") then
		CreateRealTimeThread(function()
			local Sleep = Sleep
			while not UICity do
				Sleep(1000)
			end
			if WaitMarsQuestion(nil,nil,[[Error: This mod requires ChoGGi's Library.
Press Ok to download it or check Mod Manager to make sure it's enabled.]]) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
			end
		end)
	end
end

function OnMsg.ClassesGenerate()
	local Actions = {
		-- goes to placement mode with last built object
		{
			ActionId = "BuildingPlacementOrientation.LastPlacedBuildingObj1",
			OnAction = function()
				local last = UICity.LastConstructedBuilding
				if type(last) == "table" then
					ChoGGi.CodeFuncs.ConstructionModeSet(last.encyclopedia_id ~= "" and last.encyclopedia_id or last.entity)
				end
			end,
			ActionShortcut = "Ctrl-Space",
			replace_matching_id = true,
		},
		-- goes to placement mode with SelectedObj
		{
			ActionId = "BuildingPlacementOrientation.LastPlacedBuildingObj2",
			OnAction = function()
				local ChoGGi = ChoGGi
				local sel = ChoGGi.ComFuncs.SelObject()
				if type(sel) == "table" then
					ChoGGi.Temp.LastPlacedObject = sel
					ChoGGi.CodeFuncs.ConstructionModeNameClean(ValueToLuaCode(sel))
				end
			end,
			ActionShortcut = "Ctrl-Shift-Space",
			replace_matching_id = true,
		},
	}

	function OnMsg.ShortcutsReloaded()
		ChoGGi.ComFuncs.Rebuildshortcuts(Actions)
	end
end

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
	--update last placed (or selected)
	if obj:IsKindOf("Building") then
		ChoGGi.Temp.LastPlacedObject = obj
	end
end

local function SomeCode()
	local ChoGGi_OrigFuncs = ChoGGi.OrigFuncs
	ChoGGi.ComFuncs.SaveOrigFunc("ConstructionController","CreateCursorObj")

  -- for setting the orientation
	do -- ConstructionController:CreateCursorObj
		local IsValid = IsValid
		-- set orientation to same as last object
		function ConstructionController:CreateCursorObj(...)
			local ret = {ChoGGi_OrigFuncs.ConstructionController_CreateCursorObj(self, ...)}

			local last = ChoGGi.Temp.LastPlacedObject
			if IsValid(last) then
				if ret[1].SetAngle then
					ret[1]:SetAngle(last:GetAngle() or 0)
				end
			end

			return table.unpack(ret)
		end
	end -- do

end

function OnMsg.CityStart()
  SomeCode()
end

function OnMsg.LoadGame()
  SomeCode()
end


