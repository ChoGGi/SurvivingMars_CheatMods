-- See LICENSE for terms

local table = table
local IsValid = IsValid
local DoneObject = DoneObject
local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits
local CreateRealTimeThread = CreateRealTimeThread
local WaitMsg = WaitMsg

local mod_Mark
local mod_MaxObjects
local mod_HideSigns

-- func added below
local ClearObjects

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_Mark = CurrentModOptions:GetProperty("Mark")
	mod_MaxObjects = CurrentModOptions:GetProperty("MaxObjects")
	mod_HideSigns = CurrentModOptions:GetProperty("HideSigns")

	if not mod_Mark then
		ClearObjects()
	end
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local beams = {}
local green = green
local InvalidPos = InvalidPos()

-- change beam size in overview mode
local ChoOrig_OverviewModeDialog_ScaleSmallObjects = OverviewModeDialog.ScaleSmallObjects
function OverviewModeDialog:ScaleSmallObjects(time, direction, ...)
	ChoOrig_OverviewModeDialog_ScaleSmallObjects(self, time, direction, ...)

	local c = #beams
	if c > 0 then
		SuspendPassEdits("ChoGGi.MarkSelectedBuildingType.ScaleSmallObjects")
		local scale = direction == "up" and 250 or 50
		for i = c, 1, -1 do
			local beam = beams[i]
			if IsValid(beam) then
				beam:SetScale(scale)
			else
				table.remove(beams, i)
			end
		end
		ResumePassEdits("ChoGGi.MarkSelectedBuildingType.ScaleSmallObjects")
	end

end

ClearObjects = function()
	for i = #beams, 1, -1 do
		local beam = beams[i]
		if IsValid(beam) then
			DoneObject(beam)
		end
	end
	table.iclear(beams)

	-- show signs
	local objs = UIColony.city_labels.labels.Building or ""
	for i = 1, #objs do
		objs[i]:UpdateSignsVisibility()
	end
end

local objs_lookup = {}
local function MarkObjects(obj)
	-- remove previous beams
	ClearObjects()

	if not mod_Mark or not obj then
		return
	end

	local UICity = obj.city or UICity

	-- added in building_class so it doesn't mark all construction sites
	local name = obj.template_name ~= "" and obj.template_name
		or obj.building_class or obj.class
	local objs = UICity.labels[name] or ""
	local objs_c = #objs
	table.clear(objs_lookup)

	-- skip if there's too many
	if objs_c >= mod_MaxObjects then
		return
	end

	-- speed up obj creation/deletion
	SuspendPassEdits("ChoGGi.MarkSelectedBuildingType.MarkObjects")

	local obj_cls = DefenceLaserBeam
	local c = 0
	for i = 1, objs_c do
		local obj = objs[i]
		objs_lookup[obj] = true
		local obj_pos = obj:GetPos()
		if obj_pos ~= InvalidPos then
			c = c + 1
			local beam = obj_cls:new()
			beam:SetColorModifier(green)
			beam:SetPos(obj_pos)
			beam:SetScale(50)
			beams[c] = beam
		end
	end

	-- needs a delay as I use a temp method of hiding signs
	CreateRealTimeThread(function()
		WaitMsg("OnRender")
		-- remove signs
		if mod_HideSigns then
			objs = UICity.labels.Building or ""
			for i = 1, #objs do
				local obj = objs[i]
				-- skip marked objs
				if not objs_lookup[obj] then
					obj:DestroyAttaches("BuildingSign")
				end
			end
		end
	end)

	ResumePassEdits("ChoGGi.MarkSelectedBuildingType.MarkObjects")
end

-- add beams (also fires when changing selection)
OnMsg.SelectionAdded = MarkObjects
-- remove beams when no selection
OnMsg.SelectionRemoved = ClearObjects
-- make sure to remove beams on save
OnMsg.SaveGame = ClearObjects
