-- See LICENSE for terms

local Strings = ChoGGi.Strings

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

function ChoGGi.MenuFuncs.ExamineObjectRadius(action)
	local objs = ChoGGi.ComFuncs.SelObjects(action.radius_amount or 2500)
	if #objs > 0 then
		-- sort by nearest
		local pt = GetTerrainCursor()
		table.sort(objs, function(a, b)
			return a:GetVisualDist(pt) < b:GetVisualDist(pt)
		end)
		ChoGGi.ComFuncs.OpenInExamineDlg(objs, nil, Strings[302535920000069--[[Examine--]]] .. " " .. Strings[302535920001103--[[Objects--]]] .. " " .. action.radius_amount or 2500)
	end
end
