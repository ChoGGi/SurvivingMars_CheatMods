-- See LICENSE for terms

local lookup_settings = {
	LightsRadiusModifier = {
		[0] = 0,
		[1] = 10,
		[2] = 25,
		[3] = 50,
		[4] = 75,
		[5] = 100,
		[6] = 150,
		[7] = 200,
		[8] = 400,
		[9] = 600,
		[10] = 1000,
		[11] = 10000,
	},
	TR_MaxChunks = {
		[0] = 0,
		[1] = 10,
		[2] = 25,
		[3] = 50,
		[4] = 75,
		[5] = 100,
		[6] = 150,
		[7] = 200,
		[8] = 400,
		[9] = 600,
		[10] = 800,
		[11] = 1000,
	},
	DTM_VideoMemory = {
		[0] = 0,
		[1] = 8,
		[2] = 16,
		[3] = 32,
		[4] = 64,
		[5] = 128,
		[6] = 256,
		[7] = 512,
		[8] = 1536,
		[9] = 2048,
		[10] = 4096,
		[11] = 8192,
		[12] = 16384,
		[13] = 32768,
	},
	ShadowmapSize = {
		[0] = 0,
		[1] = 8,
		[2] = 16,
		[3] = 32,
		[4] = 64,
		[5] = 128,
		[6] = 256,
		[7] = 512,
		[8] = 1536,
		[9] = 2048,
		[10] = 4096,
		[11] = 8192,
		[12] = 16384,
		[13] = 32768,
	},
	LODDistanceModifier = {
		[0] = 0,
		[1] = 15,
		[2] = 30,
		[3] = 60,
		[4] = 120,
		[5] = 240,
		[6] = 360,
		[7] = 480,
		[8] = 600,
		[9] = 720,
		[10] = 840,
		[11] = 960,
		[12] = 1080,
		[13] = 1200,
		[14] = 1320,
		[15] = 1440,
		[16] = 1560,
	},
	ShadowRangeOverride = {
		[0] = 0,
		[1] = 15625,
		[2] = 31250,
		[3] = 62500,
		[4] = 125000,
		[5] = 250000,
		[6] = 500000,
		[7] = 1000000,
		[8] = 2000000,
		[9] = 5000000,
		[10] = 0,
	},
}

local mod_LightsRadiusModifier
local mod_TR_MaxChunks
local mod_DTM_VideoMemory
local mod_ShadowmapSize
local mod_LODDistanceModifier
local mod_ShadowRangeOverride

local function UpdateHR()
	local hr = hr

	if mod_LightsRadiusModifier > 0 then
		hr.LightsRadiusModifier = lookup_settings.LightsRadiusModifier[mod_LightsRadiusModifier]
	end
	if mod_TR_MaxChunks > 0 then
		hr.TR_MaxChunks = lookup_settings.TR_MaxChunks[mod_TR_MaxChunks]
	end
	if mod_DTM_VideoMemory > 0 then
		hr.DTM_VideoMemory = lookup_settings.DTM_VideoMemory[mod_DTM_VideoMemory]
	end
	if mod_ShadowmapSize > 0 then
		hr.ShadowmapSize = lookup_settings.ShadowmapSize[mod_ShadowmapSize]
	end
	if mod_LODDistanceModifier > 0 then
		hr.LODDistanceModifier = lookup_settings.LODDistanceModifier[mod_LODDistanceModifier]
	end
	if mod_ShadowRangeOverride ~= 0 then
		hr.ShadowRangeOverride = lookup_settings.ShadowRangeOverride[mod_ShadowRangeOverride]
	end
end
OnMsg.CityStart = UpdateHR
OnMsg.LoadGame = UpdateHR

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions

	mod_LightsRadiusModifier = options:GetProperty("LightsRadiusModifier")
	mod_TR_MaxChunks = options:GetProperty("TR_MaxChunks")
	mod_DTM_VideoMemory = options:GetProperty("DTM_VideoMemory")
	mod_ShadowmapSize = options:GetProperty("ShadowmapSize")
	mod_LODDistanceModifier = options:GetProperty("LODDistanceModifier")
	mod_ShadowRangeOverride = options:GetProperty("ShadowRangeOverride")

	UpdateHR()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
