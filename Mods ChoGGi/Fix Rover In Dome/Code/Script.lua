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
	if id == CurrentModId then
		ModOptions()
	end
end

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
	-- pp is too early for OnMsg.ModsReloaded
	ModOptions()

	if not mod_EnableMod then
		return
	end

	-- replace some idles
	ChoGGi.ComFuncs.ReplaceClassFunc("BaseRover", "Idle", WaitItOut)

end
