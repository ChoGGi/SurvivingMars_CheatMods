-- See LICENSE for terms

local table = table
local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits
local IsValid = IsValid
local InvalidPos = ChoGGi.Consts.InvalidPos
local RetName = ChoGGi_Funcs.Common.RetName

local mod_EnableMod
local mod_CleanUpInvalid
local mod_MoveInvalidPosition

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_CleanUpInvalid = CurrentModOptions:GetProperty("CleanUpInvalid")
	mod_MoveInvalidPosition = CurrentModOptions:GetProperty("MoveInvalidPosition")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local lines = {}
local lines_c = 0

-- remove existing lines
local function CleanUp()
	SuspendPassEdits("ChoGGi.SelectionRemoved.Show Dome Connected Objects.CleanUp")
	for i = 1, lines_c do
		local line = lines[i]
		if IsValid(line) then
			line:delete()
		end
	end
--~ 	table.iclear(lines)
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

	table.clear(bad_objs)
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
	local ChoGGi_OPolyline = ChoGGi_OPolyline

	-- attach lines
	local dome_name = RetName(dome)
	local dome_pos = dome:GetPos()
	for i = #bad_objs, 1, -1 do
		local bad_obj = bad_objs[i]
		if mod_CleanUpInvalid and not IsValid(bad_obj) then
			-- remove invalid obj from dome list
			table.remove_entry(bad_objs[bad_obj], "handle", bad_obj.handle)
			print("Dome Show Connected Objects: Removed invalid object", RetName(bad_obj), "from dome!", dome_name)
		-- obj stuck outside the map area ("holding area" for off planet rockets and so on)
		elseif mod_MoveInvalidPosition and (bad_obj:GetVisualPos() or point20) == InvalidPos and not (bad_obj:IsKindOf("Colonist") and IsValid(bad_obj.holder)) then
			-- stick in dome for user to remove
			print("Dome Show Connected Objects: Moved object", RetName(bad_obj), "from invalid position to in-dome position!", dome_name)
			bad_obj:SetPos(table.rand(dome.walkable_points or dome:GetPos()))
		else
			local line = ChoGGi_OPolyline:new()
			-- FixConstructPos sets z to ground height
			line:SetParabola(dome_pos, bad_obj:GetVisualPos())
			-- store line for delete toggle
			lines_c = lines_c + 1
			lines[lines_c] = line
		end
	end

	-- dome stuck in the table and the above doesn't clear it out
	if mod_CleanUpInvalid then
		table.clear(dome.connected_domes)
	end


--~ 	if ChoGGi.testing then
--~ 		local line = ChoGGi_OPolyline:new()
--~ 		line:SetParabola(dome_pos, ChoGGi.Consts.InvalidPos)
--~ 		lines_c = lines_c + 1
--~ 		lines[lines_c] = line
--~ 	end

	ResumePassEdits("ChoGGi.SelectionRemoved.Show Dome Connected Objects.ToggleLines")
end

-- clear lines when changing selection
OnMsg.SelectionRemoved = CleanUp

function OnMsg.ClassesPostprocess()

	local building = XTemplates.ipBuilding[1]
	-- check for and remove existing template
	ChoGGi_Funcs.Common.RemoveXTemplateSections(building, "ChoGGi_Template_ShowDomeConnectedObjects", true)

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
