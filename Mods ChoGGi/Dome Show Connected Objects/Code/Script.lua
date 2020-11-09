-- See LICENSE for terms

local mod_EnableMod
local mod_CleanUpInvalid

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_CleanUpInvalid = CurrentModOptions:GetProperty("CleanUpInvalid")
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
--~ local table_iclear = table.iclear
local table_clear = table.clear

local lines = {}
local lines_c = 0
local OPolyline

-- remove existing lines
local function CleanUp()
	SuspendPassEdits("ChoGGi.SelectionRemoved.Show Dome Connected Objects.CleanUp")
	for i = 1, lines_c do
		local line = lines[i]
		if IsValid(line) then
			line:delete()
		end
	end
--~ 	table_iclear(lines)
	lines_c = 0
	ResumePassEdits("ChoGGi.SelectionRemoved.Show Dome Connected Objects.CleanUp")
end

local bad_objs = {}
local bad_objs_c = 0
local function BuildObjList(list)
	for i = 1, #list do
		local obj = list[i]
		bad_objs_c = bad_objs_c + 1
		bad_objs[bad_objs_c] = obj
		-- for removing invalids
		bad_objs[obj] = list
	end
end

local function ToggleLines(dome)
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

	table_clear(bad_objs)
	bad_objs_c = 0
	BuildObjList(dome.labels.Building or "", dome.labels.Building)
	BuildObjList(dome.labels.Colonist or "", dome.labels.Colonist)
	for obj in pairs(dome.connected_domes or empty_table) do
		bad_objs_c = bad_objs_c + 1
		bad_objs[bad_objs_c] = obj
		-- for removing invalids
		bad_objs[obj] = dome.connected_domes
	end

	-- my lines are removed on savegame
	if not OPolyline then
		OPolyline = ChoGGi_OPolyline
	end

	-- attach lines
	local pos = dome:GetPos()
	for i = #bad_objs, 1, -1 do
		local bad_obj = bad_objs[i]
		if mod_CleanUpInvalid and not IsValid(bad_obj) then
			-- remove the not obj from dome list
			table.remove_entry(bad_objs[bad_obj], "handle", bad_obj.handle)
		else
			local line = OPolyline:new()
			-- FixConstructPos sets z to ground height
			line:SetParabola(pos, bad_obj:GetVisualPos())
			-- store dome for delete toggle
			lines_c = lines_c + 1
			lines[lines_c] = line
		end
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
		-- update button vis if we cleared out invalids
		"OnContextUpdate", function(self, context)
			if context:ShouldShowDemolishButton() then
				self:SetVisible(false)
			else
				self:SetVisible(true)
			end
		end,
		"__template", "InfopanelButton",

		"Icon", "UI/Icons/IPButtons/move.tga",
		"RolloverText", T(302535920011610, "Show objects blocking you from removing this dome."),
		"RolloverTitle", T(302535920011611, "Toggle Connected Objects"),

		"OnPress", function(self)
			ToggleLines(self.context)
			-- make the salvage button show up (I could remove the __condition from salvage, but this works)
			if self.context:ShouldShowDemolishButton() then
				local selected = SelectedObj
				SelectObj()
				SelectObj(selected)
			end
		end,
	})

	-- update salvage button to always be there and toggle hidden instead of not being created and having to re

end
