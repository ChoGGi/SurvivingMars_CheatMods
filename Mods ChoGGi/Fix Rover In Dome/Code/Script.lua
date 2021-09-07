-- See LICENSE for terms

local mod_EnableMod

local GetRandomPassableAround = GetRandomPassableAround
local IsUnitInDome = IsUnitInDome
local box = box

-- end to end for the diamond dome (plus some extra)
local largest = 30000


local function MoveRovers()
	-- no point in checking if domes have been opened
	if not mod_EnableMod or GetOpenAirBuildings(ActiveMapID) then
		return
	end

	local rovers = ActiveGameMap.realm:MapGet("map", "BaseRover")
	for i = 1, #rovers do
		local rover = rovers[i]
		local dome = IsUnitInDome(rover)
		if dome and not dome.open_air then
			local x, y = (dome:GetObjectBBox() or box(0, 0, largest, largest)):sizexyz()
			-- whichever is larger (the radius starts from the centre, so we only need half-size)
			local radius = (x >= y and x or y) / 2
			rover:SetPos(GetRandomPassableAround(dome, radius + 650, radius + 150))
		end
	end

end

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	if not UICity then
		return
	end

	MoveRovers()
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

OnMsg.CityStart = MoveRovers
OnMsg.LoadGame = MoveRovers
