-- See LICENSE for terms

local ChoGGi_Funcs = ChoGGi_Funcs
local table = table
local T = T
local Translate = ChoGGi_Funcs.Common.Translate

function ChoGGi_Funcs.Menus.ConsoleRestart()
	if ChoGGi.testing then
		quit("restart")
	end

	local dlgConsole = dlgConsole
	if ChoGGi_Funcs.Common.IsValidXWin(dlgConsole) then
		if not dlgConsole:GetVisible() then
			ShowConsole(true)
		end
		dlgConsole.idEdit:SetFocus()
		dlgConsole.idEdit:SetText("restart")
	end
end

do -- ExamineObjectRadius
	local pt
	local function SortDist(a, b)
		return a:GetDist2D(pt) < b:GetDist2D(pt)
	end
	function ChoGGi_Funcs.Menus.ExamineObjectRadius()
		local radius = ChoGGi.UserSettings.ExamineObjectRadius or 2500
		local objs = ChoGGi_Funcs.Common.SelObjects(radius)
		if objs[1] then
			pt = GetCursorWorldPos()
			-- sort by nearest
			table.sort(objs, SortDist)

			OpenExamine(objs, {
				has_params = true,
				override_title = true,
				title = T(302535920000069--[[Examine]]) .. " "
					.. T(302535920001103--[[Objects]]) .. " "
					.. T(302535920000163--[[Radius]]) .. ": " .. radius,
			})
		end
	end
end -- do
