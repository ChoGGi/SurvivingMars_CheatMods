-- See LICENSE for terms

local AttachToNearestDome = ChoGGi.ComFuncs.AttachToNearestDome

DefineClass.ChoGGi_OutsideResidence = {
	__parents = {
		"LivingBase", "WaypointsObj",
	},
}

function ChoGGi_OutsideResidence:GameInit()
	-- speed up adding/removing/scaling objs
	SuspendPassEdits("ChoGGi.OutsideResidence.GameInit")

	-- -128 to 127
	-- object, 1-4 , Color, Roughness, Metallic
	self:SetColorizationMaterial(1, -8629977, 127, -128)
	self:SetColorizationMaterial(2, -6000831, 127, -128)
	self:SetColorizationMaterial(3, 0, 127, -128)

	self:DestroyAttaches("DecSecurityCenterBase")

	-- add a cap to hide the vats
	local top = EntityClass:new()
	self:Attach(top)
	-- diff entity for diff dlc
	if IsValidEntity("MagneticFieldGenerator") then
		top:ChangeEntity("MagneticFieldGenerator")
		top:SetScale(20)
		top:SetAttachOffset(point(0, 0, 3010))
	elseif IsValidEntity("ResearchLabCP3") then
		top:ChangeEntity("ResearchLabCP3")
		top:SetAttachOffset(0, -570, 1830)
	else
		top:ChangeEntity("SupplyPod")
		top:SetScale(60)
		top:SetAttachOffset(point(0, 0, 2300))
	end
	top:SetColorizationMaterial(1, -8629977, 127, -128)
	top:SetColorizationMaterial(2, -8629977, 127, -128)
	top:SetColorizationMaterial(3, -8629977, 127, -128)

	-- only actually needed for MagneticFieldGenerator, but it looks decent enough
	local bottom = EntityClass:new()
	self:Attach(bottom)
	bottom:SetScale(53)
	bottom:ChangeEntity("RegolithExtractorRing")
	bottom:SetAttachOffset(point(0, 0, -47))
	bottom:SetColorizationMaterial(2, -8629977, 127, -128)

	ResumePassEdits("ChoGGi.OutsideResidence.GameInit")

	-- piggy back off nearest dome
	AttachToNearestDome(self, "force")
end

function ChoGGi_OutsideResidence:BuildingUpdate()
	AttachToNearestDome(self, "force")
end

-- AttachToNearestDome adds it to this label (Residence gets removed when it's demo'd)
function ChoGGi_OutsideResidence:Done()
	local dome = self.parent_dome
	if IsValid(dome) then
		dome:RemoveFromLabel("InsideBuildings", self)
	end
end

function OnMsg.ClassesPostprocess()
	if BuildingTemplates.ChoGGi_OutsideResidence then
		return
	end

	PlaceObj("BuildingTemplate", {

		-- added, not uploaded
		"disabled_in_environment1", "",
		"disabled_in_environment2", "",
		"disabled_in_environment3", "",
		"disabled_in_environment4", "",

		"Id", "ChoGGi_OutsideResidence",
		"template_class", "ChoGGi_OutsideResidence",
		"palette_color1", "outside_base",
		"palette_color2", "inside_base",
		"palette_color3", "rover_base",

		"maintenance_resource_type", "Concrete",
		"maintenance_resource_amount", 5000,
		"construction_cost_Concrete", 30000,
		"construction_cost_Polymers", 5000,
		"build_points", 20000,

		"electricity_consumption", 16000,
		"service_comfort", 20000,
		"comfort_increase", 2500,
		"capacity", 18,

		"is_tall", true,
		"dome_forbidden", true,
		"dome_required", false,

		"display_name", T(302535920011338, [[MARSHA]]),
		"display_name_pl", T(302535920011339, [[MARSHAs]]),
		"description", T(302535920011340, [[Just an overall crappy place to live.]]),
		"display_icon", CurrentModPath .. "UI/outside_residence.png",
		"entity", "CloningVats",
		"build_category", "ChoGGi",
		"Group", "ChoGGi",
		"encyclopedia_exclude", true,

		"label1", "Residence",
	})

end
