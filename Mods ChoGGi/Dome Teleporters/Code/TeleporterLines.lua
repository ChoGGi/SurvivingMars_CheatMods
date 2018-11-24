-- See LICENSE for terms

local IsKindOf = IsKindOf
local IsValid = IsValid
local PlacePolyline = PlacePolyline
local AveragePoint2D = AveragePoint2D
local pairs = pairs
local TableClear = table.clear

local teleporter_lines = {}

function OnMsg.SaveGame()
	for _,table_item in pairs(teleporter_lines) do
		if IsValid(table_item.line) then
			table_item.line:delete()
		end
	end
	TableClear(teleporter_lines)
end

-- adds a new line to the tunnel table
local function AddLine(teleporter_lines,t1,t2)
	local points = {t1:GetVisualPos(),t2:GetVisualPos()}
	teleporter_lines[t1] = {
		t1 = t1,
		t2 = t2,
		line = PlacePolyline(points),
	}
	teleporter_lines[t1].line:SetPos(AveragePoint2D(points))
end

function OnMsg.SelectedObjChange(obj, prev)
	if not IsKindOf(obj,"DomeTeleporter") then
		return
	end

	-- if type tunnel then build/update list and show lines
	local tunnels = UICity.labels.DomeTeleporter or ""
	for i = 1, #tunnels do
		-- get tunnel n linked one so we only have one of each in table
		local t1,t2 = tunnels[i],tunnels[i].linked_obj
		-- see if we already added a table for paired tunnel
		local table_item = teleporter_lines[t1] or teleporter_lines[t2]
		if table_item then
			-- just in case it gets deleted
			if not IsValid(table_item.line) then
				AddLine(teleporter_lines,t1,t2)
			end
			table_item.line:SetVisible(true)
		else
			AddLine(teleporter_lines,t1,t2)
		end
	end
end

-- when selection is removed (or changed) hide all the lines
function OnMsg.SelectionRemoved()
	for _,table_item in pairs(teleporter_lines) do
		if IsValid(table_item.line) then
			table_item.line:SetVisible(false)
		end
	end
end
