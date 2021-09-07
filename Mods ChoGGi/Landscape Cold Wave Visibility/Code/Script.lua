-- See LICENSE for terms

local mod_SpaceCount
local EnableMarker

-- fired when settings are changed/init
local function ModOptions()
	mod_SpaceCount = CurrentModOptions:GetProperty("SpaceCount")

	-- no sense in updating unless it's a cold wave
	if g_ColdWave then
		local objs = UICity.labels.LandscapeConstructionSite or ""
		for i = 1, #objs do
			EnableMarker(objs[i])
		end
	end
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

local DoneObject = DoneObject
local type = type

local function DisableMarker(obj)
	if obj.ChoGGi_ColdLines then
		local lines = obj.ChoGGi_ColdLines
		for i = 1, #lines do
			DoneObject(lines[i])
		end
		obj.ChoGGi_ColdLines = nil
		return
	end
end

local cls_obj
EnableMarker = function(obj)
	if type(obj.drone_dests_cache) ~= "table" then
		return
	end
	-- might as well be on the safe side
	if obj.ChoGGi_ColdLines then
		DisableMarker(obj)
	end
	obj.ChoGGi_ColdLines = {}
	local lines = obj.ChoGGi_ColdLines
	local c = 0

	local drone_dests_cache = obj.drone_dests_cache
	if not obj.drone_dests_cache[1]:z() then
		for i = 1, #drone_dests_cache do
			drone_dests_cache[i] = drone_dests_cache[i]:SetTerrainZ()
		end
	end

	if not cls_obj then
		cls_obj = WayPointBig
	end
	for i = 1, #drone_dests_cache do
		if i == 1 or i % mod_SpaceCount == 0 then
			local mark = cls_obj:new()
			mark:SetPos(drone_dests_cache[i])
			c = c + 1
			lines[c] = mark
		end
	end
end

GlobalVar("g_ChoGGi_ColdWaveLandscapeConstructionSite", false)

-- add remove lines depending on coldwaves
local orig_BuildingUpdate = LandscapeConstructionSite.BuildingUpdate
function LandscapeConstructionSite:BuildingUpdate(...)
	local is_coldwave = g_ColdWave
	local flags_enabled = g_ChoGGi_ColdWaveLandscapeConstructionSite
	if is_coldwave and not (flags_enabled and self.ChoGGi_ColdLines) then
		EnableMarker(self)
		g_ChoGGi_ColdWaveLandscapeConstructionSite = true
	elseif not is_coldwave and flags_enabled and self.ChoGGi_ColdLines then
		DisableMarker(self)
		g_ChoGGi_ColdWaveLandscapeConstructionSite = false
	end
	return orig_BuildingUpdate(self, ...)
end

local orig_Done = LandscapeConstructionSite.Done
function LandscapeConstructionSite:Done(...)
	DisableMarker(self)
	return orig_Done(self, ...)
end

-- make sure there's no markers left around
function OnMsg.SaveGame()
	if g_ColdWave then
		return
	end
	local markers = ActiveGameMap.realm:MapGet("map", "WayPointBig")
	for i = 1, #markers do
		DoneObject(markers[i])
	end
end
