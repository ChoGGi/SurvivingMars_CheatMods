-- See LICENSE for terms

-- the below is needed for inside buildings to work outside
local AttachToNearestDome
if Mods.ChoGGi_Library.version > 70 then
	AttachToNearestDome = ChoGGi.ComFuncs.AttachToNearestDome
else
	-- remove this once 7.1 is out
	local MapFilter = MapFilter
	local FindNearestObject = FindNearestObject
	local IsValid = IsValid
	local function CanWork(obj)
		return obj:CanWork()
	end

	-- if building requires a dome and that dome is borked then assign it to nearest dome
	AttachToNearestDome = function(obj, force)
		if force ~= "force" and not obj:GetDefaultPropertyValue("dome_required") then
			return
		end

		-- find the nearest working dome
		local working_domes = MapFilter(UICity.labels.Dome, CanWork)
		local dome = FindNearestObject(working_domes, obj)

		local current_dome_valid = IsValid(obj.parent_dome)
		-- remove from old dome (assuming it's a different dome), or the dome is invalid
		if obj.parent_dome and not current_dome_valid
				or (current_dome_valid and dome and dome.handle ~= obj.parent_dome.handle) then
			local current_dome = obj.parent_dome
			-- add to dome labels
			current_dome:RemoveFromLabel("InsideBuildings", obj)
			if obj:IsKindOf("Residence") then
				current_dome:RemoveFromLabel("Residence", obj)
			end

			if obj:IsKindOf("NetworkNode") then
				current_dome:SetLabelModifier("BaseResearchLab", "NetworkNode")
			end
			obj.parent_dome = false
		end

		-- no need to fire if there's no dome, or the above didn't remove it
		if dome and not IsValid(obj.parent_dome) then
			obj:SetDome(dome)

			-- add to dome labels
			dome:AddToLabel("InsideBuildings", obj)
			if obj:IsKindOf("Residence") then
				dome:AddToLabel("Residence", obj)
			end
		end
	end

end

DefineClass.ChoGGi_OutsideResidence = {
	__parents = {
		"LivingBase",
		"WaypointsObj",
	},
}

function ChoGGi_OutsideResidence:GameInit()
	-- speed up adding/removing objs
	SuspendPassEdits("ChoGGi_OutsideResidence.GameInit")

	-- -128 to 127
	-- object, 1-4 , Color, Roughness, Metallic
	self:SetColorizationMaterial(1, -8629977, 127, -128)
	self:SetColorizationMaterial(2, -6000831, 127, -128)
	self:SetColorizationMaterial(3, 0, 127, -128)

	self:DestroyAttaches("DecSecurityCenterBase")

	-- add a cap to hide the vats
	local top = EntityClass:new()
	self:Attach(top)
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

	ResumePassEdits("ChoGGi_OutsideResidence.GameInit")

	-- piggy back off nearest dome
	AttachToNearestDome(self, "force")
end

function ChoGGi_OutsideResidence:BuildingUpdate()
	AttachToNearestDome(self, "force")
end

function OnMsg.ClassesPostprocess()
	if BuildingTemplates.ChoGGi_OutsideResidence then
		return
	end

	PlaceObj("BuildingTemplate", {
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
		"service_comfort", 15000,
		"comfort_increase", 1500,
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
