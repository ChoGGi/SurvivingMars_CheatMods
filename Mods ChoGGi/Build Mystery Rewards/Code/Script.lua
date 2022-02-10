-- See LICENSE for terms

if not g_AvailableDlc.contentpack1 then
	print(CurrentModDef.title , ": Mysteries Resupply Pack DLC (it's free) not installed!")
	return
end

local mod_EnableMod

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

local function SetTemplate(id, skip)
	local bt = BuildingTemplates[id]
	bt.Group = "ChoGGi"
	bt.build_category = "ChoGGi"
	if not skip then
		bt.display_icon = "UI/Icons/Buildings/placeholder.tga"
	end
end

local function StartupCode()
	if not mod_EnableMod then
		return
	end

	SetTemplate("CrystalsBig")
	SetTemplate("CrystalsSmall")
	SetTemplate("Sinkhole")
	SetTemplate("MirrorSphere", true)
	SetTemplate("PowerDecoy", true)

	-- needed to capture spheres/show them in build menu
	UIColony.tech_status["Purpose of the Spheres"] = {field = "Mysteries", points = 0}
	UIColony.tech_status["Xeno-Terraforming"] = {field = "Mysteries", points = 0}
	UIColony:SetTechResearched("Purpose of the Spheres")
	UIColony:SetTechResearched("Xeno-Terraforming")
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

function OnMsg.BuildingInit(obj)
	if not mod_EnableMod then
		return
	end

	if obj:IsKindOf("CrystalsBuilding") then
		obj.can_demolish = true
		obj:CheatAllowExploration()
	elseif obj:IsKindOf("Sinkhole") then
		obj.can_demolish = true
		obj.max_firefly_number = 999
	end

end

function OnMsg.ClassesPostprocess()
	local xtemplate = XTemplates.ipBuilding[1]

	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_BuildPhilosopherStones_Liftoff", true)

	xtemplate[#xtemplate+1] = PlaceObj("XTemplateTemplate", {
		"Id" , "ChoGGi_Template_BuildPhilosopherStones_Liftoff",
		"ChoGGi_Template_BuildPhilosopherStones_Liftoff", true,
		"__context_of_kind", "CrystalsBuilding",
		"__template", "InfopanelButton",
		"__condition", function()
			return mod_EnableMod
		end,

		"RolloverTitle", T(4253, "LAUNCH"),
		"RolloverText", T(302535920011946, "Starts takeoff animation, planting more stones and doing this again will spam the log. Doesn't seem to hurt anything though."),
		"Icon", "UI/Icons/IPButtons/drill.tga",

		"OnPress", function(self)
			local context = self.context

			-- might help log spam
			context.city:SetTechResearched("CrystallineFrequencyJamming")
			-- Yamato Hasshin!
			context:CheatStartLiftoff()

			ObjModified(context)
		end,
	})

	--
	xtemplate = XTemplates.ipMirrorSphereBuilding[1]

	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_BuildPhilosopherStones_SphereEscavate", true)
	xtemplate[#xtemplate+1] = PlaceObj("XTemplateTemplate", {
		"Id" , "ChoGGi_Template_BuildPhilosopherStones_SphereEscavate",
		"ChoGGi_Template_BuildPhilosopherStones_SphereEscavate", true,
		"__context_of_kind", "MirrorSphereBuilding",
		"__template", "InfopanelButton",
		"__condition", function()
			return mod_EnableMod
		end,

		"RolloverTitle", T(302535920011970, "Escavate"),
		"RolloverText", T(302535920011971, "Detach Sphere from excavation site."),
		"Icon", "UI/Icons/IPButtons/force_launch.tga",

		"OnPress", function(self)
			self.context:SetProgressPct(100)
			ObjModified(self.context)
		end,
	})

	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_BuildPhilosopherStones_DeleteSite", true)
	xtemplate[#xtemplate+1] = PlaceObj("XTemplateTemplate", {
		"Id" , "ChoGGi_Template_BuildPhilosopherStones_DeleteSite",
		"ChoGGi_Template_BuildPhilosopherStones_DeleteSite", true,
		"__context_of_kind", "MirrorSphereBuilding",
		"__template", "InfopanelButton",
		"__condition", function()
			return mod_EnableMod
		end,

		"RolloverTitle", T(302535920011972, "Delete Excavation Site"),
		"RolloverText", T(302535920011973, "You'll need to flatten the ground afterwards."),
		"Icon", "UI/Icons/IPButtons/stop.tga",

		"OnPress", function(self)
			local context = self.context
			if IsValid(context.sphere) then
				ChoGGi.ComFuncs.DeleteObject(context.sphere)
			end
			ChoGGi.ComFuncs.DeleteObject(context)
			ObjModified(context)
		end,
	})

	--
	xtemplate = XTemplates.ipSinkhole[1]

	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_BuildPhilosopherStonesSinkhole_Spawn", true)
	xtemplate[#xtemplate+1] = PlaceObj("XTemplateTemplate", {
		"Id" , "ChoGGi_Template_BuildPhilosopherStonesSinkhole_Spawn",
		"ChoGGi_Template_BuildPhilosopherStonesSinkhole_Spawn", true,
		"__context_of_kind", "Sinkhole",
		"__template", "InfopanelButton",
		"__condition", function()
			return mod_EnableMod
		end,

		"RolloverTitle", T(302535920012056, "Spawn"),
		"RolloverText", T(302535920012057, "Spawn a Wisp."),
		"Icon", "UI/Icons/ColonyControlCenter/wasterock_on.tga",

		"OnPress", function(self)
			self.context:TestSpawnFireflyAndGo()
		end,
	})

	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_BuildPhilosopherStonesSinkhole_Remove", true)
	xtemplate[#xtemplate+1] = PlaceObj("XTemplateTemplate", {
		"Id" , "ChoGGi_Template_BuildPhilosopherStonesSinkhole_Remove",
		"ChoGGi_Template_BuildPhilosopherStonesSinkhole_Remove", true,
		"__context_of_kind", "Sinkhole",
		"__template", "InfopanelButton",
		"__condition", function()
			return mod_EnableMod
		end,

		"RolloverTitle", T(8940, "Wisp"),
		"RolloverText", T(302535920011948, "Remove all wisps."),
		"Icon", "UI/Icons/IPButtons/stop.tga",

		"OnPress", function(self)
			local context = self.context

			GetRealm(context):MapDelete("map", "Firefly")

			ObjModified(context)
		end,
	})

	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_BuildPhilosopherStonesSinkhole_Demolish", true)
	xtemplate[#xtemplate+1] = PlaceObj("XTemplateTemplate", {
		"Id" , "ChoGGi_Template_BuildPhilosopherStonesSinkhole_Demolish",
		"ChoGGi_Template_BuildPhilosopherStonesSinkhole_Demolish", true,
		"__context_of_kind", "Sinkhole",
		"__template", "InfopanelButton",
		"__condition", function()
			return mod_EnableMod
		end,

		"RolloverTitle", T(3973, "Salvage"),
		"RolloverText", T(7822, "Destroy this building."),
		"Icon", "UI/Icons/IPButtons/salvage_1.tga",

		"OnPress", function(self)
			self.context:ToggleDemolish()
			ObjModified(self.context)
		end,
	})

end
