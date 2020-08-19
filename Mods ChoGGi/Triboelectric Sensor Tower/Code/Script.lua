-- See LICENSE for terms

DefineClass.ChoGGi_TriboelectricSensorTower = {
	__parents = {
		"RangeElConsumer",
		"OutsideBuildingWithShifts",
		"SensorTower",
		"TriboelectricScrubberBase",
	},

	properties =
	{
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
	-- pp is too early for mod_Example, call ModOptions() if needed
	if BuildingTemplates.ChoGGi_TriboelectricSensorTower then
		return
	end

	PlaceObj("BuildingTemplate", {
		"Id", "ChoGGi_TriboelectricSensorTower",
		"template_class", "ChoGGi_TriboelectricSensorTower",
		"construction_cost_Metals", 20000,
		"construction_cost_Electronics", 8000,

		"build_points", 2000,
		"is_tall", true,
		"dome_forbidden", true,
		"maintenance_resource_type", "Electronics",
		"maintenance_threshold_base", 50000,
		"entity", "SensorTower",
		"show_range_all", true,
		"electricity_consumption", 1800,
		"dust_clean", 8000,

		"palette_color1", "outside_base",
		"palette_color2", "inside_base",
		"palette_color3", "rover_base",

	"display_name", T(302535920011720, "Triboelectric Sensor Tower"),
	"display_name_pl", T(302535920011721, "Triboelectric Sensor Towers"),
	"description", T(302535920011722, [[Boosts scanning speed, especially for nearby sectors. Extends the advance warning for disasters.
Emits pulses which reduce the Dust accumulated on buildings in its range.]]),
		"encyclopedia_id", "TriboelectricScrubber",
		"encyclopedia_image", "UI/Encyclopedia/TriboelectricScrubber.tga",
		"label1", "OutsideBuildings",
		"label2", "OutsideBuildingsTargets",
		"display_icon", "UI/Icons/Buildings/triboelectric_schrubbe.tga",

		"build_category", "ChoGGi",
		"Group", "ChoGGi",
		"demolish_sinking", range(5, 10),
		"demolish_debris", 85,
	})

	local xtemplate = XTemplates.ipBuilding[1]

	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_TriboelectricSensorTower", true)

	table.insert(xtemplate[1], 23,
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
