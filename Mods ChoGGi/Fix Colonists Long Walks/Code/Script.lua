-- See LICENSE for terms

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
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

local dome_walk_dist = const.ColonistMaxDomeWalkDist

local orig_AreDomesConnectedWithPassage = AreDomesConnectedWithPassage
function AreDomesConnectedWithPassage(d1, d2, ...)
	if not mod_EnableMod then
		return orig_AreDomesConnectedWithPassage(d1, d2, ...)
	end

	return orig_AreDomesConnectedWithPassage(d1, d2, ...)
		-- If orig func returns true then check if domes are within walking dist
		-- "d1 == d2" is from orig func (no need to check dist if both domes are the same)
		and (d1 == d2 or d1:GetDist2D(d2) <= dome_walk_dist)
end
