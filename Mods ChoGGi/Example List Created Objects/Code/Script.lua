-- See LICENSE for terms

local obj_list = {}
local c = 0
local function ClearList()
	table.iclear(obj_list)
	c = 0

	-- add clear button
	obj_list[max_int] = {
		ChoGGi_AddHyperLink = true,
		name = "Clear List",
		hint = "Clears list when you click the @",
		func = function()
			ClearList()
		end,
	}
end

local function StartupCode()
	ClearList()

	ChoGGi.ComFuncs.OpenInExamineDlg(obj_list, {
		has_params = true,
		auto_refresh = true,
		toggle_sort = true,
	})
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode


local ChoOrig_CObject_new = CObject.new
--~ function CObject.new(class, luaobj, components)
function CObject.new(...)
	local new_obj = ChoOrig_CObject_new(...)

	c = c + 1
	obj_list[c] = new_obj

	return new_obj
end
