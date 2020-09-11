-- See LICENSE for terms

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
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

local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits
local IsValid = IsValid
local table_iclear = table.iclear

local lines = {}
local lines_c = 0
local OPolyline

-- remove existing lines
local function CleanUp()
	SuspendPassEdits("ChoGGi.SelectionRemoved.Show Dome Connected Objects.CleanUp")
	for i = 1, #lines do
		local line = lines[i]
		if IsValid(line) then
			line:delete()
		end
	end
	table_iclear(lines)
	lines_c = 0
	ResumePassEdits("ChoGGi.SelectionRemoved.Show Dome Connected Objects.CleanUp")
end

local bad_objs = {}
local bad_objs_c = 0
local function BuildObjList(list)
	for i = 1, #list do
		bad_objs_c = bad_objs_c + 1
		bad_objs[bad_objs_c] = list[i]
	end
end

local function ToggleLines(obj)
	-- It's a toggle so
	if lines_c > 0 then
		CleanUp()
		return
	else
		CleanUp()
	end

	if not mod_EnableMod then
		return
	end

	SuspendPassEdits("ChoGGi.SelectionRemoved.Show Dome Connected Objects.ToggleLines")

	table_iclear(bad_objs)
	bad_objs_c = 0
	BuildObjList(obj.labels.Building or "")
	BuildObjList(obj.labels.Colonist or "")
	for dome in pairs(obj.connected_domes or empty_table) do
		bad_objs_c = bad_objs_c + 1
		bad_objs[bad_objs_c] = dome
	end

	-- my lines are removed on savegame
	if not OPolyline then
		OPolyline = ChoGGi_OPolyline
	end

	-- attach lines
	local pos = obj:GetPos()
	for i = 1, #bad_objs do
		local line = OPolyline:new()
		-- FixConstructPos sets z to ground height
		line:SetParabola(pos, bad_objs[i]:GetVisualPos())
		-- store obj for delete toggle
		lines_c = lines_c + 1
		lines[lines_c] = line
	end
	ResumePassEdits("ChoGGi.SelectionRemoved.Show Dome Connected Objects.ToggleLines")
end

-- clear lines when changing selection
OnMsg.SelectionRemoved = CleanUp

function OnMsg.ClassesPostprocess()

	local building = XTemplates.ipBuilding[1]
	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(building, "ChoGGi_Template_ShowDomeConnectedObjects", true)

	building[#building+1] = PlaceObj('XTemplateTemplate', {
		"ChoGGi_Template_ShowDomeConnectedObjects", true,
		"Id", "ChoGGi_ShowDomeConnectedObjects",
		"__context_of_kind", "Dome",
		-- only show button when demo button isn't visible
		"__condition", function (_, context)
			return not context:ShouldShowDemolishButton()
		end,
		"__template", "InfopanelButton",

		"Icon", "UI/Icons/IPButtons/move.tga",
		"RolloverText", T(302535920011610, "Show objects blocking you from removing this dome."),
		"RolloverTitle", T(302535920011611, "Toggle Connected Objects"),

		"OnPress", function (self)
			ToggleLines(self.context)
		end,
	})

end
