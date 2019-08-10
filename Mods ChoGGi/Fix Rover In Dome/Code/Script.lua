-- See LICENSE for terms

local CObject_IsValidPos = CObject.IsValidPos
local WorldToHex = WorldToHex
local GetDomeAtHex = GetDomeAtHex
local GetRandomPassableAround = GetRandomPassableAround

-- end to end for the diamond dome (plus some extra)
local largest = 30000

local function WaitItOut(idle_func, rover, ...)
	-- no point in checking if domes have been opened and skip rovers not on mars
	if not OpenAirBuildings and CObject_IsValidPos(rover) then
		local dome = GetDomeAtHex(WorldToHex(rover))
		if dome then
			local x, y = (dome:GetObjectBBox() or box(0, 0, largest, largest)):sizexyz()
			-- whichever is larger (the radius starts from the centre, so we only need half-size)
			local radius = (x >= y and x or y) / 2
			rover:SetPos(GetRandomPassableAround(dome, radius+650, radius+150))
		end
	end
	return idle_func(rover, ...)
end

function OnMsg.ClassesPostprocess()
	-- replace some idles
	local classes = {
		"ExplorerRover",
		"RCTransport",
		"RCHarvester",
		"RCTerraformer",

		"RCConstructor",
		"RCDriller",
		"RCTerraformer",
		"RCSolar",
		"RCSensor",
		"RCRover",
	}

	local g = _G
	for i = 1, #classes do
		local cls_obj = g[classes[i]]
		local idle_func = cls_obj.Idle
		function cls_obj:Idle(...)
			return WaitItOut(idle_func, self, ...)
		end
	end
end
