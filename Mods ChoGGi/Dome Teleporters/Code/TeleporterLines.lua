-- See LICENSE for terms

local IsValid = IsValid
local PlacePolyline = PlacePolyline
local AveragePoint2D = AveragePoint2D
local pairs = pairs
local table_clear = table.clear

local teleporter_lines = {}
local two_pointer = {}

local cls = "DomeTeleporter"

function OnMsg.SelectedObjChange(obj, prev)
	if not IsKindOf(obj,cls) then
		return
	end

	-- if type tunnel then build/update list and show lines
	local tunnels = UICity.labels[cls] or ""
	for i = 1, #tunnels do
		-- get tunnel n linked one so we only have one of each in table
		local t1,t2 = tunnels[i],tunnels[i].linked_obj
		-- see if we already added a table for paired tunnel
		local table_item = teleporter_lines[t1] or teleporter_lines[t2]
		if not table_item then
			-- no need to clear the table, we just replace the old points
			two_pointer[1] = t1:GetVisualPos()
			two_pointer[2] = t2:GetVisualPos()
			teleporter_lines[t1] = {
				t1 = t1,
				t2 = t2,
				line = PlacePolyline(two_pointer),
			}
			teleporter_lines[t1].line:SetPos(AveragePoint2D(two_pointer))
		end
	end

end

-- when selection is removed (or changed) hide all the lines
function OnMsg.SelectionRemoved()
	for _,table_item in pairs(teleporter_lines) do
		if IsValid(table_item.line) then
			table_item.line:delete()
		end
	end
	table_clear(teleporter_lines)
end
