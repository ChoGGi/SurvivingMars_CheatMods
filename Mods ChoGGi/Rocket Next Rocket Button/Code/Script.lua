-- See LICENSE for terms

local MapFilter = MapFilter
local ViewAndSelectObject = ViewAndSelectObject
local XDestroyRolloverWindow = XDestroyRolloverWindow
local table_find = table.find

local function CycleRockets(context)
	local list = (context.city or UICity).labels.SupplyRocket or empty_table
	list = MapFilter(list, function(rocket)
		return rocket:IsRocketLanded()
	end)
	local count = #list

	if count > 0 then
		-- dunno why they localed it, instead of making it InfobarObj:CycleObjects()...
		local idx = SelectedObj and table_find(list, SelectedObj) or 0
		idx = (idx % count) + 1
		local next_obj = list[idx]

		ViewAndSelectObject(next_obj)
		XDestroyRolloverWindow()
	end
end

function OnMsg.ClassesPostprocess()

	ChoGGi.ComFuncs.AddXTemplate(XTemplates.ipBuilding[1], "RocketNextButton", nil, {
		__context_of_kind = "SupplyRocket",
		Title = T(000, "Next Rocket"),
		RolloverTitle = T(000, "Next Rocket"),
		RolloverText = T(000, "Loop between your rockets quickly."),
		Icon = "UI/Icons/Research/plasma_rocket.tga",
		func = function(self, context)
			CycleRockets(context)
		end,
	})

end
