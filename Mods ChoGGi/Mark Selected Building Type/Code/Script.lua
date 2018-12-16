-- See LICENSE for terms

MarkSelectedBuildingType = {
	Mark = true,
}
local MarkSelectedBuildingType = MarkSelectedBuildingType

local IsValid = IsValid
local TableIClear = table.iclear

local beams = {}
local green = green
local InvalidPos = InvalidPos()

-- change beam size in overview mode
local orig_OverviewModeDialog_ScaleSmallObjects = OverviewModeDialog.ScaleSmallObjects
function OverviewModeDialog:ScaleSmallObjects(time, direction, ...)
	orig_OverviewModeDialog_ScaleSmallObjects(self, time, direction, ...)

	if #beams > 0 then
		local scale = direction == "up" and 250 or 50
		for i = 1, #beams do
			local beam = beams[i]
			if IsValid(beam) then
				beam:SetScale(scale)
			end
		end
	end

end

function MarkSelectedBuildingType.ClearBeams()
	for i = 1, #beams do
		local beam = beams[i]
		if IsValid(beam) then
			beam:delete()
		end
	end
	TableIClear(beams)
end

local skips = {"Shuttle","Drone","Colonist","LifeSupportGridElement","ElectricityGridElement"}

function MarkSelectedBuildingType.MarkObjects(obj)
	if not MarkSelectedBuildingType.Mark then
		return
	end

	-- remove previous beams
	MarkSelectedBuildingType.ClearBeams()

	if obj:IsKindOfClasses(skips) then
		return
	end

	-- added in building_class so it doesn't mark all construction sites
	local name = obj.template_name ~= "" and obj.template_name or obj.building_class or obj.class

	local c = 0
	local label = UICity.labels[name] or ""
	for i = 1, #label do
		local obj_pos = label[i]:GetPos()
		if obj_pos ~= InvalidPos then
			c = c + 1
			local beam = PlaceObj("DefenceLaserBeam")
			beam:SetColorModifier(green)
			beam:SetPos(obj_pos)
			beam:SetScale(50)
			beams[c] = beam
		end
	end
end

-- add beams (also fires when changing selection)
function OnMsg.SelectionAdded(obj)
	MarkSelectedBuildingType.MarkObjects(obj)
end

-- remove beams when no selection
function OnMsg.SelectionRemoved()
	MarkSelectedBuildingType.ClearBeams()
end

-- make sure to remove beams on save
function OnMsg.SaveGame()
	MarkSelectedBuildingType.ClearBeams()
end
