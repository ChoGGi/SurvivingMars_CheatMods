-- See LICENSE for terms

local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits
local IsValid = IsValid

local lines = {}
local lines_c = 0
local OPolyline

-- remove existing lines
local function CleanUp()
	SuspendPassEdits("SelectionRemoved.Show Dust Affected.CleanUp")
	for i = 1, #lines do
		local line = lines[i]
		if IsValid(line) then
			line:delete()
		end
	end
	table.iclear(lines)
	lines_c = 0
	ResumePassEdits("SelectionRemoved.Show Dust Affected.CleanUp")
end

local skips = {"ElectricityGridElement", "LifeSupportGridElement"}

local function ToggleLines(obj)
	-- it's a toggle so
	if lines_c > 0 then
		CleanUp()
		return
	else
		CleanUp()
	end
	SuspendPassEdits("SelectionRemoved.Show Dust Affected.ToggleLines")

	-- safety first
	if not IsValid(obj) then
		return
	end

	local dust_range
	if obj:IsKindOf("ConstructionSite") then
		dust_range = obj.building_class_proto.dust_range
	else
		dust_range = obj.dust_range
	end

	local objs = MapGet(obj, "hex", dust_range, "DustGridElement", "Building", function(o)
		-- skip self, cables, n pipes
		if o == obj or o:IsKindOfClasses(skips)
			or (o:IsKindOf("ConstructionSite") and o.building_class_proto
			and o.building_class_proto:IsKindOfClasses(skips))
		then
			return
		end

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

	ResumePassEdits("SelectionRemoved.Show Dust Affected.ToggleLines")
end

-- clear lines when changing selection
OnMsg.SelectionRemoved = CleanUp

function OnMsg.ClassesPostprocess()

	local building = XTemplates.ipBuilding[1]
	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(building, "ChoGGi_Template_ShowDustAffectedToggle", true)



	building[#building+1] = PlaceObj('XTemplateTemplate', {
		"ChoGGi_Template_ShowDustAffectedToggle", true,
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

end
