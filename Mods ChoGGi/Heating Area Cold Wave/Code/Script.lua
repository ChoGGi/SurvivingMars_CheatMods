-- See LICENSE for terms

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

local function UpdateBuildings()
	-- update all BaseHeater buildings
	local s_Heaters = s_Heaters
	for obj in pairs(s_Heaters) do
		-- skip ColdArea objs
		if obj.working and obj.heat > 0 and not obj:IsKindOf("ColdArea") then
			obj:ApplyHeat(false)
			obj:ApplyHeat(true)
		end
	end
end

local function UpdateWaveStatus()
	CreateGameTimeThread(function()
		Sleep(5000)
		UpdateBuildings()
	end)
end

OnMsg.ColdWaveEnded = UpdateWaveStatus
OnMsg.ColdWaveCancel = UpdateWaveStatus

OnMsg.CityStart = UpdateBuildings
OnMsg.LoadGame = UpdateBuildings
OnMsg.ColdWave = UpdateBuildings

local classes = {
	"BaseHeater",
	"SubsurfaceHeater",
	"MoholeMine",
	"MirrorSphere",
	"ArtificialSun",
	"CoreHeatConvector",
	"AdvancedStirlingGenerator",
}

local const_HexHeight = const.HexHeight
local g = _G
for i = 1, #classes do
	local class = classes[i]
	local class_obj = g[class]
	-- skip dlc needed ones
	if class_obj then
		local ChoOrig_func = class_obj.GetHeatRange
		function class_obj.GetHeatRange(...)
			if not mod_EnableMod then
				return ChoOrig_func(...)
			end

			local range = ChoOrig_func(...)
			if g_ColdWave then
				return range + const_HexHeight
			end
			return range
		end

	end
end
