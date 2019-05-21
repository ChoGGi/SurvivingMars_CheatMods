-- See LICENSE for terms

local entity = "Ice_Cliff_06"

local ApplyAllWaterObjects = ApplyAllWaterObjects
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

	-- init water level
	self.water_obj = WaterFill:new()
	local pos = self:GetPos()+point(0,0,500)
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
		self.water_level = (self.water_steps - 1) * -1
	end

	self.water_obj:SetPos(self:GetPos()+point(0,0,self.water_level))
	ApplyAllWaterObjects()
end

function InstantLake:AdjustLevel(dir,smaller)
	local level = self.water_steps
	if smaller then
		level = level / 2
	end

	if dir == "down" then
		level = level * -1
	end
	self:UpdateLevel(level)
end

function OnMsg.ClassesPostprocess()
	if not BuildingTemplates.InstantLake then
		PlaceObj("BuildingTemplate",{
			"Id","InstantLake",
			"template_class","InstantLake",
			"construction_cost_Concrete",1000,
			"palette_color1", "outside_base",

			"dome_forbidden",true,
			"display_name",[[Place-a-lake]],
			"display_name_pl",[[Place-a-lakes]],
			"description",[[lake thingy... ?]],
			"display_icon", "UI/Icons/Buildings/terraforming_big_lake.tga",
			"entity", entity,
			"build_category","ChoGGi",
			"Group", "ChoGGi",
			"encyclopedia_exclude",true,
			"on_off_button",false,
			"prio_button",false,
			"use_demolished_state",false,
			"force_extend_bb_during_placement_checks",30000,
			"demolish_sinking",range(0, 0),
			"demolish_debris",0,
			"auto_clear",true,
		})
	end
end

function OnMsg.ClassesBuilt()
	local building = XTemplates.ipBuilding[1]

	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(building,"ChoGGi_Template_InstantLake_Adjust",true)

	table.insert(
		building,
		#building+1,
		PlaceObj('XTemplateTemplate', {
			"ChoGGi_Template_InstantLake_Adjust", true,
			"comment", "fill/drain toggle",
			"__context_of_kind", "InstantLake",
			"__template", "InfopanelButton",
			"RolloverText", T(0,[[Adjust lake level
<left_click> Raise <right_click> Lower]]),
			"RolloverTitle", [[Adjust Level]],
			"RolloverHint", T(0,[[Ctrl + <left_click> Halve level adjust]]),
			"Icon", "UI/Icons/IPButtons/drill.tga",
			"OnPress", function (self, gamepad)
				self.context:AdjustLevel("up",not gamepad and IsMassUIModifierPressed())
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

end
