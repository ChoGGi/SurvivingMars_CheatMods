-- See LICENSE for terms

local WaitMsg = WaitMsg
local IsPointNearBuilding = IsPointNearBuilding
local Random = ChoGGi.ComFuncs.Random
local CopyTable = ChoGGi.ComFuncs.CopyTable

-- from SubsurfaceDeposit.lua, but never used anywhere (we'll use it as limits for new deposits)
local r = const.ResourceScale
local ranges = {
  ["Very Low"] = range(100 * r, 1000 * r),
  ["Low"] = range(1001 * r, 2000 * r),
  ["Average"] = range(2001 * r, 3000 * r),
  ["High"] = range(3001 * r, 4000 * r),
  ["Very High"] = range(4001 * r, 8000 * r),
}

local function DisasterTriggerMeteor(pos, spawn_type)
	if not pos then
		return
	end

	local descr = CopyTable(DataInstances.MapSettings_Meteor.Meteor_High)

	-- defaults to 50000 (no good for aiming).
	descr.storm_radius = 2500
	--
	descr.multispawn_chance = 0
	-- always large
	descr.large_chance = 100

	CreateGameTimeThread(function()
		MeteorsDisaster(descr, "single", pos)
 		WaitMsg("OnRender")

		-- find the meteor we just spawned (or at least a random one)
		local meteor
		local g_MeteorsPredicted = g_MeteorsPredicted
		local break_count = 0
		while break_count < 10 do
			local temp_meteor = table.rand(g_MeteorsPredicted)
			if temp_meteor and not temp_meteor.ChoGGi_MeteoroidDeposits then
				temp_meteor.ChoGGi_MeteoroidDeposits = true
				meteor = temp_meteor
				break
			end
			break_count = break_count + 1
		end

		if meteor then
			meteor:SetScale(500)
--~ 			ex(meteor)

			-- wait for it to land
			while IsValid(meteor) do
				Sleep(100)
			end

			local marker
			if spawn_type == "Concrete" then
				marker = PlaceObjectIn("TerrainDepositMarker", ActiveMapID)
			else
				marker = PlaceObjectIn("SubsurfaceDepositMarker", ActiveMapID)
			end

			marker.resource = spawn_type
			marker:SetPos(meteor.dest)
			marker.grade = table.rand(DepositGradesTable)
--~ 			marker.max_amount = 15000 * const.ResourceScale
			local counts = ranges[marker.grade]
			marker.max_amount = Random(counts.from, counts.to)

			marker.depth_layer = 1
			marker.revealed = true
			local deposit = marker:PlaceDeposit()
			if deposit and deposit.PickVisibilityState then
				deposit:PickVisibilityState()
			end
		end

	end)
end

local mod_EnableMod
local mod_SurfaceOnly
local mod_SafeLanding
local mod_MetalsThreshold
local mod_RareMetalsThreshold
local mod_WaterThreshold
local mod_ConcreteThreshold
local mod_ExoticMinerals
local mod_ExoticMineralsThreshold


local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_SurfaceOnly = CurrentModOptions:GetProperty("SurfaceOnly")
	mod_SafeLanding = CurrentModOptions:GetProperty("SafeLanding")
	mod_MetalsThreshold = CurrentModOptions:GetProperty("MetalsThreshold")
	mod_RareMetalsThreshold = CurrentModOptions:GetProperty("RareMetalsThreshold")
	mod_WaterThreshold = CurrentModOptions:GetProperty("WaterThreshold")
	mod_ConcreteThreshold = CurrentModOptions:GetProperty("ConcreteThreshold")
	mod_ExoticMinerals = CurrentModOptions:GetProperty("ExoticMinerals")
	mod_ExoticMineralsThreshold = CurrentModOptions:GetProperty("ExoticMineralsThreshold")
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions


function OnMsg.NewHour()
	if not mod_EnableMod then
		return
	end

	local city = UICity
	if mod_SurfaceOnly and city ~= MainCity then
		return
	end

	local buildable_grid = GetBuildableGrid(city)
	local object_hex_grid = GetObjectHexGrid(city)
	local realm = GetRealm(city)
	local pfClass = 0

	local deposits = {
		TerrainDepositConcrete = mod_ConcreteThreshold,
		SubsurfaceDepositWater = mod_WaterThreshold,
		SubsurfaceDepositMetals = mod_MetalsThreshold,
		SubsurfaceDepositPreciousMetals = mod_RareMetalsThreshold,
	}
	if mod_ExoticMinerals then
		deposits.SubsurfaceDepositPreciousMinerals = mod_ExoticMineralsThreshold
	end

	local spawn_type = "Concrete"
	for cls, option in pairs(deposits) do

		local count
		if cls == "TerrainDepositConcrete" then
			spawn_type = "Concrete"
			count = realm:MapCount("map", cls) + realm:MapCount("map", "TerrainDepositMarker", function(o)
				return not o.is_placed and o.resource == spawn_type
			end)

		else
			spawn_type = cls == "SubsurfaceDepositWater" and "Water"
				or cls == "SubsurfaceDepositMetals" and "Metals"
				or cls == "SubsurfaceDepositPreciousMetals" and "PreciousMetals"
				or cls == "SubsurfaceDepositPreciousMinerals" and "PreciousMinerals"

			count = realm:MapCount("map", cls) + realm:MapCount("map", "SubsurfaceDepositMarker", function(o)
				return not o.is_placed and o.resource == spawn_type
			end)
		end

		if option > count then
			local pos
			if mod_SafeLanding then
				pos = realm:GetRandomPassablePoint(Random(), pfClass, function(x, y)
					return buildable_grid:IsBuildableZone(x, y) and not IsPointNearBuilding(object_hex_grid, x, y)
				end)
			else
				pos = realm:GetRandomPassablePoint(Random(), pfClass, function(x, y)
					return buildable_grid:IsBuildableZone(x, y)
				end)
			end

			DisasterTriggerMeteor(pos, spawn_type)
		end
	end

end

