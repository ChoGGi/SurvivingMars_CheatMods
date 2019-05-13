-- See LICENSE for terms

local table_sort = table.sort

local obj_pos
local function SortDist2D(a, b)
	return a:GetVisualDist(obj_pos) < b:GetVisualDist(obj_pos)
end

local function SortCC()
	-- sorts cc list by dist to building
	local objs = UICity.labels.Building or ""
	for i = 1, #objs do
		local obj = objs[i]
		-- no sense in doing it with only one center
		if #obj.command_centers > 1 then
			obj_pos = obj:GetPos()
			table_sort(obj.command_centers, SortDist2D)
		end
	end
end
--~ ChoGGi.ComFuncs.TickStart("TickStart")
--~ SortCC()
--~ ChoGGi.ComFuncs.TickEnd("TickStart")

OnMsg.NewDay = SortCC
OnMsg.LoadGame = SortCC
