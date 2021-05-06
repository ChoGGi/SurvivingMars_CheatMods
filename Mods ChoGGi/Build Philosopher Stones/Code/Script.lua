-- See LICENSE for terms

if not g_AvailableDlc.contentpack1 then
	print("Build Philosopher Stones needs Mysteries DLC installed.")
	return
end

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

local function SetTemplate(id)
	local bt = BuildingTemplates[id]
	bt.Group = "ChoGGi"
	bt.build_category = "ChoGGi"
	bt.display_icon = "UI/Icons/Buildings/placeholder.tga"
end

local function StartupCode()
	if not mod_EnableMod then
		return
	end

	SetTemplate("CrystalsBig")
	SetTemplate("CrystalsSmall")
	SetTemplate("Sinkhole")
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
	end

end

function OnMsg.ClassesPostprocess()
	local xtemplate = XTemplates.ipBuilding[1]

	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_BuildPhilosopherStones_Liftoff", true)

	table.insert(xtemplate, 1,
		PlaceObj("XTemplateTemplate", {
			"Id" , "ChoGGi_Template_BuildPhilosopherStones_Liftoff",
			"ChoGGi_Template_BuildPhilosopherStones_Liftoff", true,
			"__context_of_kind", "CrystalsBuilding",
			"__template", "InfopanelButton",
			"__condition", function()
				return mod_EnableMod
			end,

			"RolloverTitle", T(4253,"LAUNCH"),
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
	)

	xtemplate = XTemplates.ipSinkhole[1]

	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_BuildPhilosopherStonesSinkhole_Spawn", true)
	table.insert(xtemplate, 1,
		PlaceObj("XTemplateTemplate", {
			"Id" , "ChoGGi_Template_BuildPhilosopherStonesSinkhole_Spawn",
			"ChoGGi_Template_BuildPhilosopherStonesSinkhole_Spawn", true,
			"__context_of_kind", "Sinkhole",
			"__template", "InfopanelButton",
			"__condition", function()
				return mod_EnableMod
			end,

			"RolloverTitle", T(8940, "Wisp"),
			"RolloverText", T(302535920011947, "Spawn a wisp."),
			"Icon", "UI/Icons/IPButtons/drill.tga",

			"OnPress", function(self)
				-- Yamato Hasshin!
				self.context.max_firefly_number = 999
				self.context:TestSpawnFireflyAndGo()
				ObjModified(self.context)
			end,
		})
	)

	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_BuildPhilosopherStonesSinkhole_Remove", true)
	table.insert(xtemplate, 2,
		PlaceObj("XTemplateTemplate", {
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

				MapDelete("map", "Firefly")

				ObjModified(context)
			end,
		})
	)

	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_BuildPhilosopherStonesSinkhole_Demolish", true)
	table.insert(xtemplate, 3,
		PlaceObj("XTemplateTemplate", {
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
	)

end
