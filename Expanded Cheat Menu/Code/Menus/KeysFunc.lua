-- See LICENSE for terms

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
		ChoGGi.ComFuncs.ConstructionModeSet(
			last.id ~= "" and last.id
			or last.template_name ~= "" and last.template_name
			or last.class
		)
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
	local objs = ChoGGi.ComFuncs.SelObjects(action.radius_amount or 2500)
	if #objs > 0 then
		-- sort by nearest
		table.sort(objs, function(a, b)
			return a:GetVisualDist(pt) < b:GetVisualDist(pt)
		end)
		ChoGGi.ComFuncs.OpenInExamineDlg(objs, nil, "ExamineObjectRadius")
	end
end
