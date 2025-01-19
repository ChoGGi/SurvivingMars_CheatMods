-- See LICENSE for terms

if not g_AvailableDlc.contentpack1 then
	print(CurrentModDef.title, ": Mysteries Resupply Pack DLC (it's free) not installed!")
	return
end

local mod_EnableMod

-- last checked 1011166
-- Source\Dlc\contentpack1\Code\Crystals.lua
local max_idx = 6
local ChoOrig_GetShardClass
local function ChoCust_GetShardClass(size, idx, ...)
	if not mod_EnableMod then
		return ChoOrig_GetShardClass(size, idx, ...)
	end

  if idx > max_idx then
--~     return
		-- Cycle numbers for models
		idx = idx % 6
		-- 12, 24, etc
		if idx == 0 then
			idx = 1
		end
  end
  local class = string.format("CrystalShard%s%d", size, idx)
  local entity = string.format("Crystals%s_%02d", size, idx)
  return class, entity
end

-- Replace local func
function OnMsg.ChoGGi_UpdateBlacklistFuncs(env)
	-- You can use examine from my lib mod to find upvalue to use
	-- OpenExamine(CrystalsBuildingBase.Init) will show GetShardClass as (2)
	local parent_func = CrystalsBuildingBase.Init
	local _, GetShardClass = env.debug.getupvalue(parent_func, 2)
	-- save orig func
	ChoOrig_GetShardClass = GetShardClass
	-- then replace with ours
	env.debug.setupvalue(parent_func, 2, ChoCust_GetShardClass)
end

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

	local UIColony = UIColony

	-- needed to capture spheres/show them in build menu
	UIColony.tech_status["Purpose of the Spheres"] = {field = "Mysteries", points = 0}
	UIColony.tech_status["Xeno-Terraforming"] = {field = "Mysteries", points = 0}
	UIColony:SetTechResearched("Purpose of the Spheres")
	UIColony:SetTechResearched("Xeno-Terraforming")

	local objs = ChoGGi_Funcs.Common.GetCityLabels("Crystals")
	if #objs > 0 then
    local mystery = UIColony.mystery
    if mystery then
      mystery.salvaged_crystallines = 0
    end

		-- check for any that user tried to salvage and demo them
		for i = #objs, 1, -1 do
			local obj = objs[i]
			if obj.demolishing_countdown and obj.demolishing_countdown < 0 then
				obj:delete()
			end
		end

	end

	-- fix older saves with crystals that need to be disabled
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

function OnMsg.BuildingInit(obj)
	if not mod_EnableMod then
		return
	end

	if obj:IsKindOf("CrystalsBuilding") then
		-- revealed is needed for it to show up on certain saves (no idea why, save had LightsMystery)
		obj.revealed = true
		obj.can_demolish = true
		obj:CheatAllowExploration()

		-- needed for salvage, and it shouldn't cause any issues with other mysteries
    local mystery = obj.city.colony.mystery
    if mystery then
      mystery.salvaged_crystallines = 0
    end
	elseif obj:IsKindOf("Sinkhole") then
		obj.can_demolish = true
		obj.max_firefly_number = 999
	end

end

function OnMsg.ClassesPostprocess()
	local xtemplate = XTemplates.ipBuilding[1]

	-- Okay got a little lazy with my template names...

	-- check for and remove existing template
	ChoGGi_Funcs.Common.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_BuildPhilosopherStones_Liftoff", true)

	-- Crystals

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
			context.city.colony:SetTechResearched("CrystallineFrequencyJamming")
			-- Yamato Hasshin!
			context:CheatStartLiftoff()

			ObjModified(context)
		end,
	})

	-- Mirror Spheres

	xtemplate = XTemplates.ipMirrorSphereBuilding[1]

	ChoGGi_Funcs.Common.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_BuildPhilosopherStones_SphereEscavate", true)
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

	ChoGGi_Funcs.Common.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_BuildPhilosopherStones_DeleteSite", true)
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
				ChoGGi_Funcs.Common.DeleteObject(context.sphere)
			end
			ChoGGi_Funcs.Common.DeleteObject(context)
			ObjModified(context)
		end,
	})

	--
	xtemplate = XTemplates.ipSinkhole[1]


	-- Sinkholes

	ChoGGi_Funcs.Common.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_BuildPhilosopherStonesSinkhole_Spawn", true)
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

	ChoGGi_Funcs.Common.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_BuildPhilosopherStonesSinkhole_Remove", true)
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

	ChoGGi_Funcs.Common.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_BuildPhilosopherStonesSinkhole_Demolish", true)
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
