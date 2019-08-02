-- See LICENSE for terms

local dome_walk_dist = const.ColonistMaxDomeWalkDist

local orig_AreDomesConnectedWithPassage = AreDomesConnectedWithPassage
function AreDomesConnectedWithPassage(d1, d2, ...)
	return orig_AreDomesConnectedWithPassage(d1, d2, ...)
		and (d1 == d2 or d1:GetDist2D(d2) <= dome_walk_dist)
end
