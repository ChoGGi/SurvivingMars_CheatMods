-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 56
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error","Building Placement Orientation requires ChoGGi's Library (at least v" .. min_version .. [[).
Press OK to download it or check the Mod Manager to make sure it's enabled.]]) == "ok" then
				if p.steam then
					OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
				elseif p.pops then
					OpenUrl("https://mods.paradoxplaza.com/mods/505/Any")
				else
					OpenUrl("https://www.nexusmods.com/survivingmars/mods/89?tab=files")
				end
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
	-- update last placed (or selected)
	if obj:IsKindOf("Building") then
		ChoGGi.Temp.LastPlacedObject = obj
	end
end

local function SomeCode()
	ChoGGi.ComFuncs.SaveOrigFunc("ConstructionController","CreateCursorObj")
	local ConstructionController_CreateCursorObj = ChoGGi.OrigFuncs.ConstructionController_CreateCursorObj

	local IsValid = IsValid
	local SetRollPitchYaw = SetRollPitchYaw
	local TableUnpack = table.unpack
	-- set orientation to same as last object
	function ConstructionController:CreateCursorObj(...)

		local ret = {ConstructionController_CreateCursorObj(self, ...)}
		local last = ChoGGi.Temp.LastPlacedObject
		if self.template_obj and self.template_obj.can_rotate_during_placement and ChoGGi.UserSettings.UseLastOrientation and IsValid(last) then
			SetRollPitchYaw(ret[1],0,0,(last:GetAngle() or 0) + -1*60*60)
		end
		return TableUnpack(ret)

	end

end

OnMsg.CityStart = SomeCode
OnMsg.LoadGame = SomeCode
