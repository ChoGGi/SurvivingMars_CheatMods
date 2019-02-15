-- See LICENSE for terms

local IsValid = IsValid
local TableSort = table.sort

local function SortCC()
	-- sorts cc list by dist to building
	local objs = UICity.labels.Building or ""
	for i = 1, #objs do
		local obj = objs[i]
		-- no sense in doing it with only one center
		if #obj.command_centers > 1 then
			TableSort(obj.command_centers,function(a,b)
				if IsValid(a) and IsValid(b) then
					return obj:GetDist2D(a) < obj:GetDist2D(b)
				end
			end)
		end
	end
end

OnMsg.NewDay = SortCC
OnMsg.LoadGame = SortCC
