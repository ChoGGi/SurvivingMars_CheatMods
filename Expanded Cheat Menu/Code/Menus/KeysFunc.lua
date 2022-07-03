-- See LICENSE for terms

local table = table
local TranslationTable = TranslationTable

function ChoGGi.MenuFuncs.ConsoleRestart()
	if ChoGGi.testing then
		quit("restart")
	end

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
			table.sort(objs, SortDist)

			OpenInExamineDlg(objs, {
				has_params = true,
				override_title = true,
				title = TranslationTable[302535920000069--[[Examine]]] .. " "
					.. TranslationTable[302535920001103--[[Objects]]] .. " "
					.. TranslationTable[302535920000163--[[Radius]]] .. ": " .. radius,
			})
		end
	end
end -- do
