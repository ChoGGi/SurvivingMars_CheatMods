-- See LICENSE for terms

function OnMsg.ClassesGenerate()

	function ChoGGi.MenuFuncs.ConsoleRestart()
		local dlgConsole = dlgConsole
		if dlgConsole then
			if not dlgConsole:GetVisible() then
				ShowConsole(true)
			end
			dlgConsole.idEdit:SetFocus()
			dlgConsole.idEdit:SetText("restart")
		end
	end

	function ChoGGi.MenuFuncs.LastConstructedBuilding()
		local last = UICity.LastConstructedBuilding
		if type(last) == "table" then
			ChoGGi.ComFuncs.ConstructionModeSet(last.template_name ~= "" and last.template_name or last:GetEntity())
		end
	end
	function ChoGGi.MenuFuncs.LastSelectedObject()
		local obj = ChoGGi.ComFuncs.SelObject()
		if type(obj) == "table" then
			ChoGGi.Temp.LastPlacedObject = obj
			ChoGGi.ComFuncs.ConstructionModeNameClean(ValueToLuaCode(obj))
		end
	end

	function ChoGGi.MenuFuncs.ExamineObjectRadius(action)
		local objs = MapGet(GetTerrainCursor(),action.radius_amount or 2500)
		if #objs > 0 then
			ChoGGi.ComFuncs.OpenInExamineDlg(objs)
		end
	end

end
