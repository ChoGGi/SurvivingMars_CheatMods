-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
local fire_once
function OnMsg.ModsReloaded()
	if fire_once then
		return
	end
	fire_once = true

	-- version to version check with
	local min_version = 37
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")

	-- if we can't find mod or mod is less then min_version (we skip steam since it updates automatically)
	if not idx or idx and not Platform.steam and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error",string.format([[Building Placement Orientation requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
			end
		end)
	end
end

-- generate is late enough that my library is loaded, but early enough to replace anything i need to
function OnMsg.ClassesGenerate()

	local S = ChoGGi.Strings
	local Actions = ChoGGi.Temp.Actions
	local c = #Actions

	-- goes to placement mode with last built object
	c = c + 1
	Actions[c] = {ActionName = S[302535920001349--[[Place Last Constructed Building--]]],
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
	Actions[c] = {ActionName = S[302535920001350--[[Place Last Selected Object--]]],
		ActionId = "BuildingPlacementOrientation.LastSelectedObject",
		OnAction = function()
			local ChoGGi = ChoGGi
			local sel = ChoGGi.ComFuncs.SelObject()
			if type(sel) == "table" then
				ChoGGi.Temp.LastPlacedObject = sel
				ChoGGi.ComFuncs.ConstructionModeNameClean(ValueToLuaCode(sel))
			end
		end,
		ActionShortcut = "Ctrl-Shift-Space",
		replace_matching_id = true,
	}
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


