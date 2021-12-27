-- See LICENSE for terms

local ViewAndSelectObject = ViewAndSelectObject
local XDestroyRolloverWindow = XDestroyRolloverWindow
local table = table

local function CycleObjects(context, class)
	local list = (context.city or UICity).labels[class] or empty_table

	if class == "SupplyRocket" then
		list = GetRealm(context):MapFilter(list, function(vehicle)
			return vehicle:IsRocketLanded()
		end)
	end
	local count = #list

	if count > 0 then
		-- dunno why they localed it, instead of making it InfobarObj:CycleObjects()...
		local idx = SelectedObj and table.find(list, SelectedObj) or 0
		idx = (idx % count) + 1
		local next_obj = list[idx]

		ViewAndSelectObject(next_obj)
		XDestroyRolloverWindow()
	end
end

function OnMsg.ClassesPostprocess()

	ChoGGi.ComFuncs.AddXTemplate(XTemplates.ipBuilding[1], "RocketNextButton", nil, {
		__context_of_kind = "RocketBase",
		Title = T(302535920012025, "Next Rocket"),
		RolloverTitle = T(302535920012025, "Next Rocket"),
		RolloverText = T(302535920012026, "Loop between your rockets quickly."),
		Icon = "UI/Icons/Research/plasma_rocket.tga",
		func = function(self, context)
			CycleObjects(context, "SupplyRocket")
		end,
	})
	ChoGGi.ComFuncs.AddXTemplate(XTemplates.ipRover[1], "RoverNextButton", nil, {
		__context_of_kind = "BaseRover",
		Title = T(0000, "Next Rover"),
		RolloverTitle = T(0000, "Next Rover"),
		RolloverText = T(302535920012026, "Loop between your rovers quickly."),
		Icon = "UI/Icons/Research/plasma_rocket.tga",
		func = function(self, context)
			CycleObjects(context, "Rover")
		end,
	})

end
