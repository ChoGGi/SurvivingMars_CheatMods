-- See LICENSE for terms

DefineClass.ChoGGi_TriboelectricSensorTower = {
	__parents = {
		"RangeElConsumer",
		"OutsideBuildingWithShifts",
		"SensorTower",
		"TriboelectricScrubberBase",
	},

	properties = {
		{ template = true, category = "Triboelectric Scrubber", name = T(826, "Charge time"),	id = "charge_time",	editor = "number", default = 2 * const.HourDuration, scale = const.HourDuration, help = "In hours",},
		{ template = true, category = "Triboelectric Scrubber", name = T(827, "Dust to clean"),	id = "dust_clean",	editor = "number", default = 5000, help = "How much dust to clean from buildings in range.",},
		{ template = true, category = "Triboelectric Scrubber", name = T(828, "Sphere Speed"),	id = "sphere_speed",editor = "number", default = 5 * guim, scale = guim, help = "Speed of the sphere movement in m/s",},
	},

	charge_thread = false,
	sphere = false,
	move_thread = false,
	cleaning = false,
	UIRange = 5,

	fx_actor_class = "SensorTower",
}

function ChoGGi_TriboelectricSensorTower:GameInit()
	-- -128 to 127
	-- object, 1-4 , Color, Roughness, Metallic
	self:SetColorizationMaterial(1, 16185078, 50, 0)
	self:SetColorizationMaterial(2, 16711422, 50, 0)
	self:SetColorizationMaterial(3, 5675720, 50, 0)

	-- add sphere to "scrubber"
	local sphere = PlaceObject("TriboelectricScrubberSphere")
	self.sphere = sphere

	self:Attach(sphere, self:GetSpotBeginIndex("Top"))
	sphere:SetScale(35)
	sphere:SetAttachOffset(point(15, -30, -500))
	sphere:SetColorizationMaterial(1, 16185078, 50, 0)
	sphere:SetColorizationMaterial(2, 16711422, 50, 0)
	sphere:SetColorizationMaterial(3, 5675720, 50, 0)


	TriboelectricScrubber.GameInit(self)

	self:UpdateSphereRotation()
end

function ChoGGi_TriboelectricSensorTower:OnSetWorking(working, ...)
	SensorTowerBase.OnSetWorking(self, working, ...)
	TriboelectricScrubberBase.OnSetWorking(self, working, ...)

	-- sensor tower anims
	if working then
		self:SetState("working")
		PlayFX("Working", "start", self)
	else
		self:SetState("idle")
		PlayFX("Working", "end", self)
	end

end

-- we don"t want it moved
ChoGGi_TriboelectricSensorTower.MoveSphere = empty_func

ChoGGi_TriboelectricSensorTower.ChargedClean = TriboelectricScrubber.ChargedClean
ChoGGi_TriboelectricSensorTower.UpdateSphereRotation = TriboelectricScrubber.UpdateSphereRotation
ChoGGi_TriboelectricSensorTower.CleanBuildings = TriboelectricScrubber.CleanBuildings
ChoGGi_TriboelectricSensorTower.OnPostChangeRange = TriboelectricScrubber.OnPostChangeRange
ChoGGi_TriboelectricSensorTower.ForEachDirtyInRange = TriboelectricScrubber.ForEachDirtyInRange
ChoGGi_TriboelectricSensorTower.StopCharging = TriboelectricScrubber.StopCharging
ChoGGi_TriboelectricSensorTower.ResetCharging = TriboelectricScrubber.ResetCharging
ChoGGi_TriboelectricSensorTower.SetDust = TriboelectricScrubber.SetDust
ChoGGi_TriboelectricSensorTower.GetChargeTime = TriboelectricScrubber.GetChargeTime

function OnMsg.ClassesPostprocess()
	local bt = BuildingTemplates

	if bt.ChoGGi_TriboelectricSensorTower then
		return
	end

	local trib = bt.TriboelectricScrubber
	local sens = bt.SensorTower

	PlaceObj("BuildingTemplate", {
		"Id", "ChoGGi_TriboelectricSensorTower",
		"template_class", "ChoGGi_TriboelectricSensorTower",
		"build_category", "ChoGGi",
		"Group", "ChoGGi",

		"construction_cost_Metals", trib.construction_cost_Metals + sens.construction_cost_Metals,
		"construction_cost_Electronics", trib.construction_cost_Electronics + sens.construction_cost_Electronics,
		"electricity_consumption", trib.electricity_consumption + sens.electricity_consumption,
		"build_points", trib.build_points + sens.build_points,
		"maintenance_resource_type", trib.maintenance_resource_type,
		"maintenance_threshold_base", trib.maintenance_threshold_base,
		"maintenance_build_up_per_hr", const.DefaultMaintenanceBuildUpPerHour + 50, -- DefaultMaintenanceBuildUpPerHour is 600
		"dust_clean", trib.dust_clean,

		"display_name", T(302535920011720, "Triboelectric ") .. sens.display_name,
		"display_name_pl", T(302535920011720, "Triboelectric ") .. sens.display_name,
		"description", sens.description .. "\n" .. trib.description,
		"encyclopedia_id", trib.encyclopedia_id,
		"encyclopedia_image", trib.encyclopedia_image,
		"label1", trib.label1,
		"label2", trib.label2,
		"display_icon", trib.display_icon,
		"show_range_all", trib.show_range_all,
		"is_tall", trib.is_tall,
		"dome_forbidden", trib.dome_forbidden,
		"entity", sens.entity,
		"demolish_sinking", sens.demolish_sinking,
		"demolish_debris", sens.demolish_debris,

		"palette_color1", "outside_base",
		"palette_color2", "inside_base",
		"palette_color3", "rover_base",
	})

	local xtemplate = XTemplates.ipBuilding[1]

	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_TriboelectricSensorTower", true)

	-- Insert after workshifts if we can or at the end
	local idx = table.find(xtemplate[1], "__template", "sectionWorkshifts")
	if not idx then
		idx = #xtemplate[1]
	end

	table.insert(xtemplate[1], idx+1,
		PlaceObj("XTemplateTemplate", {
			"Id" , "ChoGGi_Template_TriboelectricSensorTower",
			"ChoGGi_Template_TriboelectricSensorTower", true,
			"__context_of_kind", "ChoGGi_TriboelectricSensorTower",
			"__template", "InfopanelSection",

			"RolloverText", T(488709956734, --[[XTemplate customTriboelectricScrubber RolloverText]] "Increasing the area of effect will greatly increase the power consumption of the building.<newline><newline>Charging time<right><em><ChargeTime> h<em><newline><left>Service range<right><SelectionRadiusScale> hexes"),
			"RolloverHintGamepad", T(253409130526, --[[XTemplate customTriboelectricScrubber RolloverHintGamepad]] "<LB> / <RB>    change service radius"),
			"Title", T(994862568830, --[[XTemplate customTriboelectricScrubber Title]] "Service area"),
			"Icon", "UI/Icons/Sections/facility.tga",
		}, {
			PlaceObj("XTemplateTemplate", {
				"__template", "InfopanelSlider",
				"BindTo", "UIRange",
			}),
		})
	)

end

-- override sensor tower counting and add our numbers
local GameTime = GameTime
local Max = Max
local SensorTowerPredictionAddTime = const.SensorTowerPredictionAddTime

local orig_GetNumberOfSensorTowers = GetNumberOfSensorTowers
function GetNumberOfSensorTowers(...)
	local count = orig_GetNumberOfSensorTowers(...)

	local prediction_add_time_ago = Max(GameTime() - SensorTowerPredictionAddTime, 0)
	local objs = UICity.labels.ChoGGi_TriboelectricSensorTower or ""
	for i = 1, #objs do
		local obj = objs[i]
		if obj.working or (obj.turn_off_time and obj.turn_off_time - prediction_add_time_ago > 0) then
			count = count + 1
		end
	end

	return count
end

local orig_GetWorkingSensorTowersCount = SensorTowerBase.GetWorkingSensorTowersCount
function SensorTowerBase.GetWorkingSensorTowersCount(...)
	local text = orig_GetWorkingSensorTowersCount(...)
	local count = text.count

	local objs = UICity.labels.ChoGGi_TriboelectricSensorTower or ""
	for i = 1, #objs do
		if objs[i].working then
			count = count + 1
		end
	end
	text.count = count

	return text
end
