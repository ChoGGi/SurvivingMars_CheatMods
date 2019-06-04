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

local table_sort = table.sort
local SelObjects = ChoGGi.ComFuncs.SelObjects
local GetTerrainCursor = GetTerrainCursor
local OpenInExamineDlg = ChoGGi.ComFuncs.OpenInExamineDlg

function ChoGGi.MenuFuncs.ExamineObjectRadius(action)
	local radius = action.radius_amount or 2500
	local objs = SelObjects(radius)
	if #objs > 0 then
		-- sort by nearest
		local pt = GetTerrainCursor()
		table_sort(objs, function(a, b)
			return a:GetVisualDist(pt) < b:GetVisualDist(pt)
		end)

		OpenInExamineDlg(objs, {
			ex_params = true,
			override_title = true,
			title = Strings[302535920000069--[[Examine]]] .. " "
				.. Strings[302535920001103--[[Objects]]] .. " "
				.. Strings[302535920000163--[[Radius]]] .. ": " .. radius,
		})
	end
end
