-- See LICENSE for terms

local properties = {}

local wonders = {
	-- buggy, might fix someday
--~ 	"ArtificialSun",
	"MoholeMine",
	"OmegaTelescope",
	"ProjectMorpheus",
	"SpaceElevator",
	"TheExcavator",
}

local bt = BuildingTemplates
for i = 1, #wonders do
	local wonder = wonders[i]
	local template = bt[wonder]

	properties[i] = PlaceObj("ModItemOptionNumber", {
		"name", wonder,
		"DisplayName", T(template.display_name),
		"Help", T("<image " .. template.encyclopedia_image .. ">"),
		"DefaultValue", 10,
		"MinValue", 0,
		"MaxValue", 100,
	})
end

return properties
