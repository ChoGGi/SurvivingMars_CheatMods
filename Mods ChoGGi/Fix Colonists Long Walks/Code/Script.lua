-- See LICENSE for terms

local dome_walk_dist = const.ColonistMaxDomeWalkDist

local IsPoint = IsPoint
local IsValid = IsValid
local IsUnitInDome = IsUnitInDome
local GetPassablePointNearby = GetPassablePointNearby
local AreDomesConnectedWithPassage = AreDomesConnectedWithPassage
local PathLenCached = PathLenCached

-- local func copy pasta
local function ResolvePos(bld1, bld2)
	local pos
	if IsPoint(bld1) then
		pos = bld1
	else
		if IsKindOf(bld1, "Unit") then
			bld1 = IsUnitInDome(bld1) or bld1.holder or bld1
		end
		if IsValid(bld1) then
			if IsKindOf(bld1, "Building") then
				bld1 = bld1.parent_dome or bld1
				local entrance
				entrance, pos = bld1:GetEntrance(bld2)
				pos = pos or bld2 and bld1:GetSpotPos(bld1:GetNearestSpot("idle", "Workdrone", bld2))
			end
			pos = pos or bld1:GetPos()
		end
	end
	return pos and invalid_pos ~= pos and GetPassablePointNearby(pos)
end

local function CheckDist(bld1, bld2)
	local p1, p2 = ResolvePos(bld1, bld2), ResolvePos(bld2, bld1)
	if not p1 or not p2 then
		return false, max_int
	end
	if p1 == p2 then
		return true, 0
	end
	local has_path
	local len_sl = p1:Dist2D(p2)
	if len_sl > dome_walk_dist then
		return false, len_sl, true
	end

	local has_path, len = PathLenCached(p1, Colonist.pfclass, p2)

	if has_path and len > dome_walk_dist then
		has_path = false
	end
	return has_path or false, len
end


function IsInWalkingDistDome(bld1, bld2)
	if bld1 == bld2 then
		return true, 0
	end
	local dist_map = g_DomeToDomeDist[bld1]
	local dist = dist_map and dist_map[bld2]
	if dist then
		-- check the actual dist instead of just saying sure go for it
		local p = AreDomesConnectedWithPassage(bld1, bld2)
			and bld1:GetDist2D(bld2) <= dome_walk_dist and true
		return dist[1] or p, dist[2]
--~ 		return dist[1] or AreDomesConnectedWithPassage(bld1, bld2), dist[2]
	end
	return CheckDist(bld1, bld2)
end
