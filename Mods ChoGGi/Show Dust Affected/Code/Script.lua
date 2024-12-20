-- See LICENSE for terms

local mod_ShowTribbyButton

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_ShowTribbyButton = CurrentModOptions:GetProperty("ShowTribbyButton")

--~ 	-- Make sure we're in-game
--~ 	if not UIColony then
--~ 		return
--~ 	end

--~ 	StartupCode()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits
local IsValid = IsValid

local lines = {}
local lines_c = 0
local OPolyline

-- remove existing lines
local function CleanUp()
	SuspendPassEdits("ChoGGi.SelectionRemoved.ShowDustAffected.CleanUp")
	for i = 1, #lines do
		local line = lines[i]
		if IsValid(line) then
			line:delete()
		end
	end
	table.iclear(lines)
	lines_c = 0
	ResumePassEdits("ChoGGi.SelectionRemoved.ShowDustAffected.CleanUp")
end

local skips = {"ElectricityGridElement", "LifeSupportGridElement"}

local function ToggleLines(obj, tribby)
	-- It's a toggle so
	if lines_c > 0 then
		CleanUp()
		return
	else
		CleanUp()
	end
	SuspendPassEdits("ChoGGi.SelectionRemoved.ShowDustAffected.ToggleLines")

	-- safety first
	if not IsValid(obj) then
		return
	end

	local affected_range
	if tribby then
		if obj:IsKindOf("ConstructionSite") then
			affected_range = obj.building_class_proto.UIRange
		else
			affected_range = obj.UIRange
		end
	else
		if obj:IsKindOf("ConstructionSite") then
			affected_range = obj.building_class_proto.dust_range
		else
			affected_range = obj.dust_range
		end
	end

	local objs = GetRealm(obj):MapGet(obj, "hex", affected_range, "DustGridElement", "Building", function(o)
		-- skip self, cables, n pipes
		if o == obj or o:IsKindOfClasses(skips)
			or (o:IsKindOf("ConstructionSite") and o.building_class_proto
			and o.building_class_proto:IsKindOfClasses(skips))
		then
			return
		end
--~ 	realm:MapForEach(self, "hex", self.UIRange, "Building", "DustGridElement", "DroneBase", exec, ...)

		-- from dustgen.lua (or somewhere)
		if (o:IsKindOf("Building") and o.accumulate_dust)
			or o:IsKindOf("DustGridElement")
			or (o:IsKindOf("ConstructionSite") and o.building_class_proto
			and o.building_class_proto.accumulate_dust)
		then
			return true
		end
	end)

	-- my lines are removed on savegame
	if not OPolyline then
		OPolyline = ChoGGi_OPolyline
	end

	-- attach lines
	local pos = obj:GetPos()
	for i = 1, #objs do
		local line = OPolyline:new()
		-- FixConstructPos sets z to ground height
		line:SetParabola(pos, objs[i]:GetPos())
		-- store obj for delete toggle
		lines_c = lines_c + 1
		lines[lines_c] = line
	end

	ResumePassEdits("ChoGGi.SelectionRemoved.ShowDustAffected.ToggleLines")
end

-- clear lines when changing selection
OnMsg.SelectionRemoved = CleanUp

function OnMsg.ClassesPostprocess()

	local building = XTemplates.ipBuilding[1]
	-- check for and remove existing template
	ChoGGi_Funcs.Common.RemoveXTemplateSections(building, "ChoGGi_Template_ShowDustAffectedToggle", true)

	building[#building+1] = PlaceObj('XTemplateTemplate', {
		"ChoGGi_Template_ShowDustAffectedToggle", true,
		"Id", "ChoGGi_ShowDustAffectedToggle",
		"__context_of_kind", "Building",
		"__condition", function (_, context)
			return context:IsKindOf("DustGenerator")
				or context:IsKindOf("ConstructionSite") and context.building_class_proto
				and context.building_class_proto:IsKindOf("DustGenerator")
		end,
		"__template", "InfopanelButton",

		"Icon", "UI/Icons/IPButtons/drill.tga",
		"RolloverText", T(302535920011547, "Show nearby buildings being affected by this dust generator."),
		"RolloverTitle", T(302535920011546, "Toggle Dust Affected"),

		"OnPress", function (self)
			ToggleLines(self.context)
		end,
	})

	-- check for and remove existing template
	ChoGGi_Funcs.Common.RemoveXTemplateSections(building, "ChoGGi_Template_ShowTribbyAffectedToggle", true)

	building[#building+1] = PlaceObj('XTemplateTemplate', {
		"ChoGGi_Template_ShowTribbyAffectedToggle", true,
		"Id", "ChoGGi_Template_ShowTribbyAffectedToggle",
		"__context_of_kind", "Building",
		"__condition", function (_, context)
			return mod_ShowTribbyButton
				and (context:IsKindOf("TriboelectricScrubber")
				or context:IsKindOf("ConstructionSite") and context.building_class_proto
				and context.building_class_proto:IsKindOf("TriboelectricScrubber"))
		end,
		"__template", "InfopanelButton",

		"Icon", "UI/Icons/IPButtons/drill.tga",
		"RolloverText", T(0000, "Show nearby buildings being affected by this Tribby."),
		"RolloverTitle", T(0000, "Toggle Tribby Affected"),

		"OnPress", function (self)
			ToggleLines(self.context, "is_tribby")
		end,
	})

end
