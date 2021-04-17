-- See LICENSE for terms

local SetBuildingTemplates = ChoGGi.ComFuncs.SetBuildingTemplates
local RemoveBuildingElecConsump = ChoGGi.ComFuncs.RemoveBuildingElecConsump
local AddBuildingElecConsump = ChoGGi.ComFuncs.AddBuildingElecConsump

local mod_MaxSize
local mod_PlantInterval
local mod_RemovePower
local options

local MulDivRound = MulDivRound

-- fired when settings are changed/init
local function ModOptions()
	options = CurrentModOptions
	mod_MaxSize = options:GetProperty("MaxSize")
	mod_PlantInterval = options:GetProperty("PlantInterval")
	mod_RemovePower = options:GetProperty("RemovePower")

	-- bump max range for plants
	local props = ForestationPlant.properties
	local idx = table.find(props, "id", "UIRange")
	if idx then
		props[idx].max = mod_MaxSize
	end

	-- for new plants
	SetBuildingTemplates("ForestationPlant", "vegetation_interval", mod_PlantInterval)

	-- make sure we're in-game
	if not UICity then
		return
	end

	local power_func
	if mod_RemovePower then
		power_func = RemoveBuildingElecConsump
	else
		power_func = AddBuildingElecConsump
	end

	-- existing plants
	local meta = ForestationPlant:GetPropertyMetadata("vegetation_interval")
	local objs = UICity.labels.ForestationPlant or ""
	local HourDuration = const.HourDuration
	for i = 1, #objs do
		local obj = objs[i]
		obj.building_update_time = MulDivRound(mod_PlantInterval, HourDuration, meta.scale)
		power_func(obj)
	end
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

-- remove power from newly planted plants
local orig_ForestationPlant_Init = ForestationPlant.Init
function ForestationPlant:Init(...)
	orig_ForestationPlant_Init(self, ...)

	if mod_RemovePower then
		RemoveBuildingElecConsump(self)
	end
	local meta = self:GetPropertyMetadata("vegetation_interval")
	self.building_update_time = MulDivRound(mod_PlantInterval, HourDuration, meta.scale)
end

function OnMsg.ClassesPostprocess()
	local building = XTemplates.ipBuilding[1]
	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(building, "ChoGGi_Template_WideAreaForestation", true)

	building[#building+1] = PlaceObj('XTemplateTemplate', {
		"ChoGGi_Template_WideAreaForestation", true,
		"Id", "ChoGGi_WideAreaForestation",
		"__context_of_kind", "ForestationPlant",
		"__template", "InfopanelButton",

		"Icon", "UI/Icons/ColonyControlCenter/food_on.tga",
		"RolloverTitle", T(302535920011649, "Update Ranges"),
		"RolloverText", T(302535920011650, "Update range for all forestation plants to match this range."),

		"OnPress", function(self)
			local context = self.context

			local range = context.UIRange
			local objs = UICity.labels.ForestationPlant or ""
			for i = 1, #objs do
				objs[i].UIRange = range
			end

			-- update existing ranges
			SelectionRemove(context)
			SelectObj(context)

		end,
	})

end
