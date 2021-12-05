-- See LICENSE for terms

local entity = "Ice_Cliff_06"

local IsMassUIModifierPressed = IsMassUIModifierPressed
local ApplyAllWaterObjects = ApplyAllWaterObjects
local table = table

DefineClass.InstantLake = {
	__parents = {
		"Building",
	},

	water_obj = false,
	water_level = false,
	water_steps = 100,
}

function InstantLake:GameInit()
	self:SetColorModifier(-12374251)

	-- Init water level
	self.water_obj = WaterFill:new()
	local pos = self:GetPos():AddZ(500)
	self.water_level = 500
	self.water_obj:SetPos(pos)
	ApplyAllWaterObjects()
end

function InstantLake:Done()
	if IsValid(self.water_obj) then
		DoneObject(self.water_obj)
		ApplyAllWaterObjects()
	end
end

function InstantLake:UpdateLevel(level)
	level = level or 0
	self.water_level = self.water_level + level

	-- not much point going far below the ground
	if self.water_level < 0 then
		self.water_level = -(self.water_steps - 1)
	end

	self.water_obj:SetPos(self:GetPos():AddZ(self.water_level))
	ApplyAllWaterObjects()
end

function InstantLake:AdjustLevel(dir, smaller)
	local level = self.water_steps
	if smaller then
		level = level / 2
	end

	if dir == "down" then
		level = -level
	end
	self:UpdateLevel(level)
end

function OnMsg.ClassesPostprocess()
	local building = XTemplates.ipBuilding[1]

	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(building, "ChoGGi_Template_InstantLake_Adjust", true)

	table.insert(
		building,
		#building+1,
		PlaceObj('XTemplateTemplate', {
			"ChoGGi_Template_InstantLake_Adjust", true,
			"Id", "ChoGGi_InstantLake_Adjust",
			"__context_of_kind", "InstantLake",
			"__template", "InfopanelButton",
			"Icon", "UI/Icons/IPButtons/drill.tga",
			"RolloverText", T(302535920011158, [[Adjust lake level
<left_click> Raise <right_click> Lower]]),
			"RolloverTitle", T(302535920011159, [[Adjust Level]]),
			"RolloverHint", T(302535920011160, [[Ctrl + <left_click> Halve level adjust]]),
			"RolloverHintGamepad", T(7518, "ButtonA") .. " " .. T(7618, "ButtonX"),
			"OnPress", function (self, gamepad)
				self.context:AdjustLevel("up", not gamepad and IsMassUIModifierPressed())
				ObjModified(self.context)
			end,
			"AltPress", true,
			"OnAltPress", function (self, gamepad)
				if gamepad then
					self.context:AdjustLevel("down", true)
				else
					self.context:AdjustLevel("down", IsMassUIModifierPressed())
				end
				ObjModified(self.context)
			end,
		})
	)

	if BuildingTemplates.InstantLake then
		return
	end
	PlaceObj("BuildingTemplate", {

		-- added, not uploaded
		"disabled_in_environment1", "",
		"disabled_in_environment2", "",
		"disabled_in_environment3", "",
		"disabled_in_environment4", "",

		"Id", "InstantLake",
		"template_class", "InstantLake",
		"construction_cost_Concrete", 1000,
		"palette_color1", "outside_base",

		"dome_forbidden", true,
		"display_name", T(302535920011155, [[Place-a-lake]]),
		"display_name_pl", T(302535920011156, [[Place-a-lakes]]),
		"description", T(302535920011157, [[lake thingy... ?]]),
		"display_icon", "UI/Icons/Buildings/terraforming_big_lake.tga",
		"entity", entity,
		"build_category", "ChoGGi",
		"Group", "ChoGGi",
		"encyclopedia_exclude", true,
		"on_off_button", false,
		"prio_button", false,
		"use_demolished_state", false,
		"force_extend_bb_during_placement_checks", 30000,
		"demolish_sinking", range(0, 0),
		"demolish_debris", 0,
		"auto_clear", true,
	})
end

-- remove UnevenTerrain error
local ChoOrig_UpdateConstructionStatuses = ConstructionController.UpdateConstructionStatuses
function ConstructionController:UpdateConstructionStatuses(...)
	local ret = ChoOrig_UpdateConstructionStatuses(self, ...)

	if self.template_obj:IsKindOf("InstantLake") then
		local statuses = self.construction_statuses or ""
		local cs_UnevenTerrain = ConstructionStatus.UnevenTerrain
		for i = 1, #statuses do
			local status = statuses[i]
			if status == cs_UnevenTerrain then
				table.remove(statuses, i)
				self.cursor_obj:SetColorModifier(-256)
				break
			end
		end
	end

	return ret
end -- ConstructionController:UpdateConstructionStatuses
