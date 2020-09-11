-- See LICENSE for terms

local disasters = {
	"ColdWaves",
	"DustStorms",
	"DustDevils",
	"MeteorStorms",
	"Marsquakes",
	"Rains",
}
local disasters_c = #disasters

local options
local mod = {}
-- load up blanks
for i = 1, disasters_c do
	local disaster = disasters[i]
	mod["Constant_" .. disaster] = false
	mod["Delay_" .. disaster] = 0
end

-- see below
local hours_passed = {}

-- fired when settings are changed/init
local function ModOptions()
	for i = 1, disasters_c do
		local disaster = disasters[i]
		local enable = "Constant_" .. disaster
		local hours = "Delay_" .. disaster
		mod[enable] = options:GetProperty(enable)
		mod[hours] = options:GetProperty(hours)
		-- make sure disabled disaster is 0
		if not mod[enable] then
			hours_passed[disaster] = 0
		end
	end
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

local disaster_lookup = {
	ColdWaves = {
		var = "g_ColdWave",
		func = "CheatColdWave",
		data = "MapSettings_ColdWave",
	},
	DustDevils = {
		var = "g_DustDevils",
		func = "GenerateDustDevil",
		data = "MapSettings_DustDevils",
	},
	DustStorms = {
		var = "g_DustStorm",
		func = "StartDustStorm",
		data = "MapSettings_DustStorm",
		types = {"normal", "great", "electrostatic"},
	},
	MeteorStorms = {
		var = "g_MeteorStorm",
		func = "MeteorsDisaster",
		data = "MapSettings_Meteor",
	},
	Marsquakes = {
		var = "g_MarsquakeActive",
		func = "CheatTriggerMarsquake",
		data = "MapSettings_Marsquake",
	},
	Rains = {
		var = "g_RainDisaster",
		func = "CheatRainsDisaster",
		data = "MapSettings_RainsDisaster",
	},
}

-- only activate if disaster isn't already active
local function ActivateDisaster(name)
--~ 	print("Activate Disaster", name)

	local disaster = disaster_lookup[name]

	-- disaster happening already
	local gvar = _G[disaster.var]
	if gvar then
		-- DustDevils needs a count (the rest are false normally, and dd stays a table?)
		if name ~= "DustDevils" or name == "DustDevils" and #gvar > 0 then
--~ 			print("Abort Disaster", name)
			return
		end
	end

	-- pick random disaster setting
	local data = table.rand(DataInstances[disaster.data])
--~ 	print("disaster type", data.name)

	-- start new disaster
	if name == "ColdWaves" or name == "Marsquakes" or name == "Rains" then
		_G[disaster.func](data.name)
	elseif name == "DustStorms" then
		CreateGameTimeThread(function()
			_G[disaster.func](table.rand(disaster.types), data)
		end)
--~ 	elseif name == "Rains" then
--~ 		-- split into each type
	elseif name == "MeteorStorms" then
		_G[disaster.func](data, "storm")
	elseif name == "DustDevils" then
		_G[disaster.func](nil, data):Start()
	end
end

-- add all options as 0 hours (maybe make it GlobalVar...)
for i = 1, disasters_c do
	hours_passed[disasters[i]] = 0
end

-- count the hours
function OnMsg.NewHour()
	-- loop through and bump the count of any enabled disasters
	for i = 1, disasters_c do
		local disaster = disasters[i]
		-- skip not enabled
		if mod["Constant_" .. disaster] then
			local c = hours_passed[disaster]
			c = c + 1
			-- If we hit the mark than activate, and reset count
			if c >= mod["Delay_" .. disaster] then
				ActivateDisaster(disaster)
				c = 0
			end
			-- update "saved" count
			hours_passed[disaster] = c
		end
	end

end
