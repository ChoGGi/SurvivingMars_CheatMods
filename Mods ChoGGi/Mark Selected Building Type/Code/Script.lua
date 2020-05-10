-- See LICENSE for terms

local mod_Mark
local mod_MaxObjects

-- func added below
local ClearBeams

-- fired when settings are changed/init
local function ModOptions()
	mod_MaxObjects = CurrentModOptions:GetProperty("MaxObjects")
	mod_Mark = CurrentModOptions:GetProperty("Mark")

	if not mod_Mark then
		ClearBeams()
	end
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

local IsValid = IsValid
local DoneObject = DoneObject
local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits
local table_remove = table.remove
local table_iclear = table.iclear

local beams = {}
local green = green
local InvalidPos = InvalidPos()

-- change beam size in overview mode
local orig_OverviewModeDialog_ScaleSmallObjects = OverviewModeDialog.ScaleSmallObjects
function OverviewModeDialog:ScaleSmallObjects(time, direction, ...)
	orig_OverviewModeDialog_ScaleSmallObjects(self, time, direction, ...)

	local c = #beams
	if c > 0 then
		SuspendPassEdits("ChoGGi.MarkSelectedBuildingType.ScaleSmallObjects")
		local scale = direction == "up" and 250 or 50
		for i = c, 1, -1 do
			local beam = beams[i]
			if IsValid(beam) then
				beam:SetScale(scale)
			else
				table_remove(beams, i)
			end
		end
		ResumePassEdits("ChoGGi.MarkSelectedBuildingType.ScaleSmallObjects")
	end

end

ClearBeams = function()
	for i = #beams, 1, -1 do
		local beam = beams[i]
		if IsValid(beam) then
			DoneObject(beam)
		end
	end
	table_iclear(beams)
end

local function MarkObjects(obj)
	-- remove previous beams
	ClearBeams()

	if not mod_Mark or not obj then
		return
	end

	-- added in building_class so it doesn't mark all construction sites
	local name = obj.template_name ~= "" and obj.template_name
		or obj.building_class or obj.class
	local labels = UICity.labels[name] or ""

	local obj_count = #labels

	-- skip if there's too many
	if obj_count >= mod_MaxObjects then
		return
	end

	-- speed up obj creation
	SuspendPassEdits("ChoGGi.MarkSelectedBuildingType.MarkObjects")

	local obj_cls = DefenceLaserBeam
	local c = 0
	for i = 1, obj_count do
		local obj_pos = labels[i]:GetPos()
		if obj_pos ~= InvalidPos then
			c = c + 1
			local beam = obj_cls:new()
			beam:SetColorModifier(green)
			beam:SetPos(obj_pos)
			beam:SetScale(50)
			beams[c] = beam
		end
	end

	ResumePassEdits("ChoGGi.MarkSelectedBuildingType.MarkObjects")
end

-- add beams (also fires when changing selection)
OnMsg.SelectionAdded = MarkObjects
-- remove beams when no selection
OnMsg.SelectionRemoved = ClearBeams
-- make sure to remove beams on save
OnMsg.SaveGame = ClearBeams
