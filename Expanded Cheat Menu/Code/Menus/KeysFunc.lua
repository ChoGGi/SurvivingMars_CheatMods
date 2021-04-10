-- See LICENSE for terms

local Strings = ChoGGi.Strings

function ChoGGi.MenuFuncs.ConsoleRestart()
	local dlgConsole = dlgConsole
	if ChoGGi.ComFuncs.IsValidXWin(dlgConsole) then
		if not dlgConsole:GetVisible() then
			ShowConsole(true)
		end
		dlgConsole.idEdit:SetFocus()
		dlgConsole.idEdit:SetText("restart")
	end
end

do -- ExamineObjectRadius
	local table_sort = table.sort
	local SelObjects = ChoGGi.ComFuncs.SelObjects
	local GetCursorWorldPos = GetCursorWorldPos
	local OpenInExamineDlg = ChoGGi.ComFuncs.OpenInExamineDlg

	local pt
	local function SortDist(a, b)
		return a:GetDist2D(pt) < b:GetDist2D(pt)
	end
	function ChoGGi.MenuFuncs.ExamineObjectRadius()
		local radius = ChoGGi.UserSettings.ExamineObjectRadius or 2500
		local objs = SelObjects(radius)
		if objs[1] then
			pt = GetCursorWorldPos()
			-- sort by nearest
			table_sort(objs, SortDist)

			OpenInExamineDlg(objs, {
				has_params = true,
				override_title = true,
				title = Strings[302535920000069--[[Examine]]] .. " "
					.. Strings[302535920001103--[[Objects]]] .. " "
					.. Strings[302535920000163--[[Radius]]] .. ": " .. radius,
			})
		end
	end
end -- do
