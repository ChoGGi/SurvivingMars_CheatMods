-- See LICENSE for terms

local orig_ConstructionSite_GetResourceProgress = ConstructionSite.GetResourceProgress
function ConstructionSite:GetResourceProgress(...)
	local ret = orig_ConstructionSite_GetResourceProgress(self, ...)
--~ 	ex(ret)
	for i = 1, ret[1].j do
		local res = ret[1].table[i]

		if res.remaining ~= res.total then
			res[2] = "<yellow>" .. res[2] .. "</color>"
			-- needed to override text
			res[1] = 0
		end
	end

	return ret
end
