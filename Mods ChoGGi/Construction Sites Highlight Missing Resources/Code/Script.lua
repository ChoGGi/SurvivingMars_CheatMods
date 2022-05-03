-- See LICENSE for terms

local mod_EnableMod

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions


local ChoOrig_ConstructionSite_GetResourceProgress = ConstructionSite.GetResourceProgress
function ConstructionSite:GetResourceProgress(...)
	if not mod_EnableMod then
		return ChoOrig_ConstructionSite_GetResourceProgress(self, ...)
	end

	local ret = ChoOrig_ConstructionSite_GetResourceProgress(self, ...)
--~ 	ex(ret)
	if ret then
		for i = 1, ret[1].j do
			local res = ret[1].table[i]

			if res.remaining ~= res.total then
				res[2] = "<yellow>" .. res[2] .. "</color>"
				-- needed to override text
				res[1] = 0
			end
		end
	end

	return ret
end
