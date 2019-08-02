-- See LICENSE for terms

local properties = {}
local c = 0

local skip_cats = {
	Hidden = true,
	Wonders = true,
	Domes = true,
	Storages = true,
	Depots = true,
	MechanizedDepots = true,
	Rovers = true,
	Landscape = true,
	LandscapeTextureBuildings = true,
	Decorations = true,
	["Outside Decorations"] = true,
}
local skip_ids = {
	Passage = true,
	PassageRamp = true,
	PowerDecoy = true,
	SelfSufficientDome = true,
	LightTrap = true,
	LevelPrefabBuilding = true,
	LifesupportSwitch = true,
	ElectricitySwitch = true,
	RockFormation = true,
	RockFormationSmall = true,
	SupplyGridSwitchBuilding = true,
	SupplyRocketBuilding = true,
	LandscapeLake = true,
	LandscapeLakeBig = true,
	LandscapeLakeHuge = true,
	LandscapeLakeMid = true,
	LandscapeLakeSmall = true,
	LandscapeRamp = true,
	LandscapeRampBuilding = true,
	LandscapeTerrace = true,
	LandscapeTerraceBuilding = true,
	LayoutConstructionBuilding = true,
	LevelPrefabBuilding = true,
	LifesupportSwitch = true,
	DomeBasic = true,
	DomeDiamond = true,
	DomeHexa = true,
	DomeMedium = true,
	DomeMega = true,
	DomeMegaTrigon = true,
	DomeMicro = true,
	DomeOval = true,
	DomeTrigon = true,
}

local rawget = rawget
local IsKindOf = IsKindOf
local g = _G
local BuildingTemplates = BuildingTemplates
for id, template in pairs(BuildingTemplates) do
	-- if there's no cls obj then we can't check if it's a workplace?
	local cls = rawget(g, template.template_class)
	if not skip_cats[template.build_category] and not skip_ids[id]
		and template.template_class ~= "LayoutConstructionBuilding"
		and cls and not IsKindOf(cls, "Workplace")
	then
		c = c + 1
		properties[c] = {
			default = 0,
			max = 100,
			min = 0,
			editor = "number",
			id = id,
			name = T(template.display_name) .. "<right><image "
				.. template.display_icon .. ">",
		}
	end
end

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(properties, function(a, b)
	return CmpLower(_InternalTranslate(a.name), _InternalTranslate(b.name))
end)

table.insert(properties, 1, {
	default = 100,
	max = 1000,
	min = 0,
	editor = "number",
	id = "DefaultPerformance",
	name = T(1000121, "Default") .. " " .. T(302535920011383, "Performance"),
})

-- max 40 chars
DefineClass("ModOptions_ChoGGi_MostBuildingsWorkers", {
	__parents = {
		"ModOptionsObject",
	},
	properties = properties,
})
