-- See LICENSE for terms

local RemoveXTemplateSections = ChoGGi_Funcs.Common.RemoveXTemplateSections
local PlaceObj = PlaceObj
local T = T

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

local function AddTemplate(xtemplate)
	-- Check for and remove existing template
	RemoveXTemplateSections(xtemplate, "ChoGGi_Template_ModDeleteObject_button", true)

	xtemplate[#xtemplate+1] = PlaceObj("XTemplateTemplate", {
		"Id" , "ChoGGi_Template_ModDeleteObject_button",
		-- No need to add this (I use it for my RemoveXTemplateSections func)
		"ChoGGi_Template_ModDeleteObject_button", true,
		-- Section button (see Source\Lua\XTemplates\Infopanel*.lua for more examples)
		"__template", "InfopanelActiveSection",
		-- Only show button when it meets the req
		"__condition", function()
			return mod_EnableMod
		end,
		--
		"Title", T(0000, "Delete Object"),
		"RolloverTitle", T(0000, "Delete Object"),
		"RolloverText", T(0000, "Forcefully delete selected object!"),
		"Icon", "UI/Icons/Sections/resource_no_accept.tga",
		}, {
		PlaceObj("XTemplateFunc", {
			"name", "OnActivate(self, context)",
			"parent", function(self)
				return self.parent
			end,
			"func", function(_, context)
				ChoGGi_Funcs.Common.DeleteObjectQuestion(context)
			end,
		}),
	})
end

local templates = {
	"ipAlienDigger",
	"ipAnomaly",
	"ipAttackRover",
	"ipBuilding",
	"ipColonist",
	"ipConstruction",
	"ipDrone",
	"ipEffectDeposit",
	"ipFirefly",
	"ipGridConstruction",
	"ipLeak",
	"ipMirrorSphere",
	"ipMirrorSphereBuilding",
	"ipMultiSelect",
	"ipPassage",
	"ipPillaredPipe",
	"ipResourceOverview",
	"ipResourcePile",
	"ipRogue",
	"ipRover",
	"ipShuttle",
	"ipSinkhole",
	"ipSubsurfaceDeposit",
	"ipSurfaceDeposit",
	"ipSwitch",
	"ipTerrainDeposit",
	"ipToxicPool",
	"ipVegetation",
}

function OnMsg.ClassesPostprocess()
	local XTemplates = XTemplates

	for i = 1, #templates do
		AddTemplate(XTemplates[templates[i]][1])
	end
end
