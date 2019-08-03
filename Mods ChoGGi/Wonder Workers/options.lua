-- See LICENSE for terms

local properties = {}

local wonders = {
--~ 	"ArtificialSun",
	"MoholeMine",
	"OmegaTelescope",
	"ProjectMorpheus",
	"SpaceElevator",
	"TheExcavator",
}
-- add workplace as parent cls obj
local bt = BuildingTemplates
for i = 1, #wonders do
	local wonder = wonders[i]
	properties[i] = {
		default = 10,
		max = 100,
		min = 0,
		editor = "number",
		id = wonder,
		name = T(bt[wonder].display_name),
	}
end

-- max 40 chars
DefineClass("ModOptions_ChoGGi_WonderWorkers", {
	__parents = {
		"ModOptionsObject",
	},
	properties = properties,
})
