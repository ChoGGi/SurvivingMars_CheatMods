-- See LICENSE for terms

local mod_EnableMod

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local table = table

-- Always report building as not-a-wonder to the func that checks for wonders
local ChoOrig_UIGetBuildingPrerequisites = UIGetBuildingPrerequisites
function UIGetBuildingPrerequisites(cat_id, template, ...)
	if not mod_EnableMod then
		return ChoOrig_UIGetBuildingPrerequisites(cat_id, template, ...)
	end

	if template.build_once then
		-- false so there's no build limit
		template.build_once = false

		-- store ret values as a table since there's more than one, and an update may change the amount
		local ret = {ChoOrig_UIGetBuildingPrerequisites(cat_id, template, ...)}

		-- we don't want to edit the template for anything else that uses it
		template.build_once = true

		return table.unpack(ret)
	end

	return ChoOrig_UIGetBuildingPrerequisites(cat_id, template, ...)
end

-- Copy n paste of func with added queueing of all elevators
-- lua rev 1011166
local ChoOrig_LaunchCargoRocket = LaunchCargoRocket
function LaunchCargoRocket(obj, func_on_launch, ...)
	if not mod_EnableMod then
		return ChoOrig_LaunchCargoRocket(obj, func_on_launch, ...)
	end

	local city = MainCity
	local mode = city and city.launch_mode or "rocket"
	local label = SetupLaunchLabel(mode)

	Msg("ResupplyRocketLaunched", label, g_CargoCost)

	CreateRealTimeThread(function(cargo, cost, mode, label)
		if mode == "elevator" then
--~ 			assert(city.labels.SpaceElevator and #city.labels.SpaceElevator > 0)
--~ 			city.labels.SpaceElevator[1]:OrderResupply(cargo, cost)
--~ 			local objs = city.labels.SpaceElevator or empty_table
			local objs = UIColony:GetCityLabels("SpaceElevator")
--~ 			-- We know [1] works thanks to XTemplate
--~ 			local viable = objs[1]
			local viable_idx = table.find(objs, "working", true)
			local viable
			if viable_idx then
				viable = objs[viable_idx]
				-- Pick whatever has a smaller queue, not great if you have one in underground, but eh...
				for i = 1, #objs do
					local obj = objs[i]
					if obj.working and #obj.import_queue < #viable.import_queue then
						viable = obj
					end
				end
			end
			if viable then
				viable:OrderResupply(cargo, cost)
			end
			-- ^ changed
		else
			cargo.rocket_name = g_RenameRocketObj.rocket_name
			MarkNameAsUsed("Rocket", g_RenameRocketObj.rocket_name_base)
			city:OrderLanding(cargo, cost, false, label)
		end

		if func_on_launch then
			func_on_launch()
		end
	end, g_RocketCargo, g_CargoCost, mode, label)

	if HintsEnabled then
		HintDisable("HintResupplyUI")
	end
end

-- lua rev 1011166
local ChoOrig_TryCloseAfterPlace = TryCloseAfterPlace
function TryCloseAfterPlace(self, ...)
	if not mod_EnableMod then
		return ChoOrig_TryCloseAfterPlace(self, ...)
	end

--~ 	local is_wonder = self.template and ClassTemplates.Building[self.template].wonder
--~ 	if is_wonder or not IsPlacingMultipleConstructions() then
	if not IsPlacingMultipleConstructions() then
		CloseModeDialog()
	end
end


local ChoOrig_ConstructionModeDialog_TryCloseAfterPlace = ConstructionModeDialog.TryCloseAfterPlace
function ConstructionModeDialog.TryCloseAfterPlace(...)
	if not mod_EnableMod then
		return ChoOrig_ConstructionModeDialog_TryCloseAfterPlace(...)
	end

	return TryCloseAfterPlace(...)
end



-- Show elevator in resupply if first built one isn't working
function OnMsg.ClassesPostprocess()
	-- [1], [3]Id = "idContent", [4]XTemplateWindow, [2]Id = "idList", [3]Id = "idElevator"
	local template = XTemplates.ResupplyCategories[1][3][4][2][3]

	template.__condition = function(parent, context)
		-- I assume this is an in-game check
		if not MainCity then
			return
		end
		return table.find(UIColony:GetCityLabels("SpaceElevator"), "working", true)
	end

end
