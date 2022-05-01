-- See LICENSE for terms

local mod_LockBehindTech

local function ToggleTech()
	if mod_LockBehindTech then
		-- build menu
		if not BuildingTechRequirements.ChoGGi_TriboelectricSensorTower then
			BuildingTechRequirements.ChoGGi_TriboelectricSensorTower = {{ tech = "TriboelectricScrubbing", hide = false, }}
		end
		-- add an entry to unlock it with the tech
		local tech = TechDef.TriboelectricScrubbing
		if not table.find(tech, "Building", "ChoGGi_TriboelectricSensorTower") then
			tech[#tech+1] = PlaceObj('Effect_TechUnlockBuilding', {
				Building = "ChoGGi_TriboelectricSensorTower",
			})
		end
	else
		if BuildingTechRequirements.ChoGGi_TriboelectricSensorTower then
			BuildingTechRequirements.ChoGGi_TriboelectricSensorTower = nil
		end
	end


	-- add cargo entry for saved games
	if not table.find(ResupplyItemDefinitions, "id", "ChoGGi_TriboelectricSensorTower") then
		RocketPayload_Init()
	end
end
OnMsg.CityStart = ToggleTech
OnMsg.LoadGame = ToggleTech

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_LockBehindTech = CurrentModOptions:GetProperty("LockBehindTech")

	-- make sure we're in-game
	if not UICity then
		return
	end

	ToggleTech()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

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
	local sphere = PlaceObjectIn("TriboelectricScrubberSphere", self:GetMapID())
	self.sphere = sphere

	self:Attach(sphere, self:GetSpotBeginIndex("Top"))
	sphere:SetScale(35)
	sphere:SetAttachOffset(point(15, -30, -500))
	sphere:SetColorizationMaterial(1, 16185078, 50, 0)
	sphere:SetColorizationMaterial(2, 16711422, 50, 0)
	sphere:SetColorizationMaterial(3, 5675720, 50, 0)


	TriboelectricScrubber.GameInit(self)

	self:UpdateSphereRotation()

  self.city:AddToLabel("SensorTower", self)
end

function ChoGGi_TriboelectricSensorTower:Done()
  self.city:RemoveFromLabel("SensorTower", self)
	TriboelectricScrubber.Done(self)
	SensorTower.Done(self)
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
--~ -- sensor tower will hide it
ChoGGi_TriboelectricSensorTower.ShowUISectionConsumption = Building.ShowUISectionConsumption
--~ o:OnApplyEffect(UIColony, TechDef.AutonomousSensors)
--~ ChoGGi_TriboelectricSensorTower.ShowUISectionConsumption = SensorTower.ShowUISectionConsumption
-- ambiguously inherited log spam
ChoGGi_TriboelectricSensorTower.GetSelectionRadiusScale = SensorTower.GetSelectionRadiusScale

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

	-- add to build menu
	local bt = BuildingTemplates
	if not bt.ChoGGi_TriboelectricSensorTower then
		local trib = bt.TriboelectricScrubber
		local sens = bt.SensorTower

		PlaceObj("BuildingTemplate", {
			"Id", "ChoGGi_TriboelectricSensorTower",
			"template_class", "ChoGGi_TriboelectricSensorTower",
			"build_category", "ChoGGi",
			"Group", "ChoGGi",
			-- build anywhere
			"disabled_in_environment1", "",
			"disabled_in_environment2", "",
			"disabled_in_environment3", "",
			"disabled_in_environment4", "",

			"construction_cost_Metals", trib.construction_cost_Metals + sens.construction_cost_Metals,
			"construction_cost_Electronics", trib.construction_cost_Electronics + sens.construction_cost_Electronics,
			"electricity_consumption", sens.electricity_consumption,
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

		-- add cargo option
		PlaceObj("Cargo", {
			description = sens.description .. "\n" .. trib.description,
			group = "Locked",
			SaveIn = "",
			icon = trib.display_icon,
			id = "ChoGGi_TriboelectricSensorTower",
			kg = 3500,
			locked = false,
			name = T(302535920011720, "Triboelectric ") .. sens.display_name,
			price = 200000000
		})
	end

	-- Add slider for range
	local xtemplate = XTemplates.ipBuilding[1]

	if not table.find(xtemplate[1], "Id", "ChoGGi_Template_TriboelectricSensorTower") then

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

end

-- override sensor tower counting and add our numbers
local GameTime = GameTime
local Max = Max
local SensorTowerPredictionAddTime = const.SensorTowerPredictionAddTime

local ChoOrig_GetNumberOfSensorTowers = GetNumberOfSensorTowers
function GetNumberOfSensorTowers(...)
	local count = ChoOrig_GetNumberOfSensorTowers(...)

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

-- override the string the user sees
local ChoOrig_GetWorkingSensorTowersCount = SensorTowerBase.GetWorkingSensorTowersCount
function SensorTowerBase.GetWorkingSensorTowersCount(...)
	local text = ChoOrig_GetWorkingSensorTowersCount(...)
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
