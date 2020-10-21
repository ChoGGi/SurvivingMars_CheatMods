-- See LICENSE for terms

local table_concat = table.concat
local T = T

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
	-- If there's no cls obj then we can't check if it's a workplace
	local cls = rawget(g, template.template_class)

	if cls and not skip_cats[template.build_category] and not skip_ids[id]
		and template.template_class ~= "LayoutConstructionBuilding"
		and IsKindOf(cls, "Workplace")
	then
		c = c + 1
		properties[c] = PlaceObj("ModItemOptionNumber", {
			"name", id,
			"DisplayName", T(template.display_name),
			"Help", table_concat(T(302535920011756, "Set to 0 for no workers required.") .. T("<newline><newline><newline><image " .. template.display_icon
				.. "><newline><newline><newline><image " .. template.encyclopedia_image .. ">")),
			"DefaultValue", 0,
			"MinValue", 0,
			"MaxValue", 100,
		})
	end
end

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(properties, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

table.insert(properties, 1, PlaceObj("ModItemOptionNumber", {
	"name", "DefaultPerformance",
	"DisplayName", table_concat(T(1000121, "Default") .. " " .. T(302535920011383, "Performance")),
	"Help", T(302535920011757, "How much performance the building has without workers."),
	"DefaultValue", 100,
	"MinValue", 0,
	"MaxValue", 1000,
	"StepSize", 10,
}))

table.insert(properties, 1, PlaceObj("ModItemOptionToggle", {
	"name", "EnableMod",
	"DisplayName", T(302535920011303, "Enable Mod"),
	"DefaultValue", true,
}))

return properties
