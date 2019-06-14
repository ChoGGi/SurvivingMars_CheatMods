-- See LICENSE for terms

local mod_id = "ChoGGi_MarkSelectedBuildingType"
local mod = Mods[mod_id]
local mod_Mark = mod.options and mod.options.Mark or true

local IsValid = IsValid
local DoneObject = DoneObject
local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits
local table_remove = table.remove
local table_iclear = table.iclear

local beams = objlist:new()
local green = green
local InvalidPos = InvalidPos()

-- change beam size in overview mode
local orig_OverviewModeDialog_ScaleSmallObjects = OverviewModeDialog.ScaleSmallObjects
function OverviewModeDialog:ScaleSmallObjects(time, direction, ...)
	orig_OverviewModeDialog_ScaleSmallObjects(self, time, direction, ...)

	if #beams > 0 then
		SuspendPassEdits("ChoGGi_MarkSelectedBuildingType:ScaleSmallObjects")
		local scale = direction == "up" and 250 or 50
		for i = #beams, 1, -1 do
			local beam = beams[i]
			if IsValid(beam) then
				beam:SetScale(scale)
			else
				table_remove(beams, i)
			end
		end
		ResumePassEdits("ChoGGi_MarkSelectedBuildingType:ScaleSmallObjects")
	end

end

local function ClearBeams()
	for i = #beams, 1, -1 do
		local beam = beams[i]
		beams[i] = nil
		if IsValid(beam) then
			DoneObject(beam)
		end
	end
	table_iclear(beams)
end

--~ local skips = {"Shuttle", "Drone", "Colonist", "LifeSupportGridElement", "ElectricityGridElement"}

local function MarkObjects(obj)
	if not (mod_Mark or obj) then
		return
	end

	-- remove previous beams
	ClearBeams()

	-- added in building_class so it doesn't mark all construction sites
	local name = obj.template_name ~= "" and obj.template_name or obj.building_class or obj.class
	local labels = UICity.labels[name] or ""

	-- skip if there's too many
--~ 	if obj:IsKindOfClasses(skips) and #labels > 500 then
	if #labels > 1000 then
		return
	end

	local obj_cls = DefenceLaserBeam
	local c = 0
	SuspendPassEdits("ChoGGi_MarkSelectedBuildingType:MarkObjects")
	for i = 1, #labels do
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
	ResumePassEdits("ChoGGi_MarkSelectedBuildingType:MarkObjects")
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= mod_id then
		return
	end

	mod_Mark = mod.options.Mark
	if mod_Mark then
		MarkObjects(SelectedObj)
	else
		ClearBeams()
	end
end

-- for some reason mod options aren't retrieved before this script is loaded...
local function StartupCode()
	mod_Mark = mod.options.Mark
	if mod_Mark then
		MarkObjects(SelectedObj)
	else
		ClearBeams()
	end
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

-- add beams (also fires when changing selection)
OnMsg.SelectionAdded = MarkObjects
-- remove beams when no selection
OnMsg.SelectionRemoved = ClearBeams
-- make sure to remove beams on save
OnMsg.SaveGame = ClearBeams
