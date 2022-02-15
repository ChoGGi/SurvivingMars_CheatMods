-- See LICENSE for terms

if not g_AvailableDlc.armstrong then
	print(CurrentModDef.title, ": Green Planet DLC not installed!")
	return
end

local IsValid = IsValid
local DoneObject = DoneObject
local ApplyAllWaterObjects = ApplyAllWaterObjects
local sqrt = sqrt
local MulDivRound = MulDivRound

local mod_EnableLakes
local mod_EnableGridView

-- list of entities we're going to be adding
local entity_list = {
	"water_texture_replacement",
	"water_icy_texture_replacement",
}

-- getting called a bunch, so make them local
local path_loc_str = CurrentModPath .. "Entities/"

-- no sense in making a new one for each entity
local entity_template = {
	category_Decors = true,
	entity = {
		fade_category = "Never",
		material_type = "Metal",
	},
}

for i = 1, #entity_list do
	local name = entity_list[i]
	-- pretty much using what happens when you use ModItemEntity
	EntityData[name] = entity_template
	EntityLoadEntities[#EntityLoadEntities + 1] = {
		CurrentModDef,
		name,
		path_loc_str .. name .. ".ent"
	}
	SetEntityFadeDistances(name, -1, -1)
end

local function UpdateLakeObj(water, lake)
	water:SetOpacity(50)
  if WaterFrozen or lake:IsFrozen() then
		water:ChangeEntity("water_icy_texture_replacement")
	else
		water:ChangeEntity("water_texture_replacement")
	end
	local seven = lake.entity:sub(1, 7)
	if seven == "LakeHug" then
		water:SetScale(1000)
	elseif seven == "LakeBig" or seven == "LakeMid" then
		water:SetScale(750)
	else
		water:SetScale(500)
	end
end

-- update texture on thaw
function OnMsg.WaterPhysicalStateChange(frozen)
	if mod_EnableLakes then
		return
	end

	local lakes = MainCity.labels.LandscapeLake or ""
	for i = 1, #lakes do
		local lake = lakes[i]
		if IsValid(lake.water_obj_fake) then
			if frozen or lake:IsFrozen() then
				lake.water_obj_fake:ChangeEntity("water_icy_texture_replacement")
			else
				lake.water_obj_fake:ChangeEntity("water_texture_replacement")
			end
		end
	end
end

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableLakes = CurrentModOptions:GetProperty("EnableLakes")
	mod_EnableGridView = CurrentModOptions:GetProperty("EnableGridView")

	if not UICity then
		return
	end

	if mod_EnableGridView then
		hr.ShowWaterGrid = 1
	else
		hr.ShowWaterGrid = 0
	end

	local lakes = MainCity.labels.Lakes or ""

	if mod_EnableLakes then
		local WaterFill = WaterFill
		for i = 1, #lakes do
			local lake = lakes[i]
			local pos
			if IsValid(lake.water_obj_fake) then
				pos = lake.water_obj_fake:GetPos()
				DoneObject(lake.water_obj_fake)
			end

			local water = lake.water_obj
			if not IsValid(water) or water:IsKindOf("BuildingEntityClass") then
				water = WaterFill:new()
				water:SetPos(pos)
				lake.water_obj = water
			end
		end
	else
		for i = 1, #lakes do
			local lake = lakes[i]
			local water = lake.water_obj
			if not IsValid(water) or not water:IsKindOf("BuildingEntityClass") then
				local pos = water:GetPos()
				DoneObject(water)
				water = BuildingEntityClass:new()
				water:SetPos(pos)
				UpdateLakeObj(water, lake)
				lake.water_obj_fake = water
			end
		end
	end
	ApplyAllWaterObjects()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

OnMsg.CityStart = ModOptions
OnMsg.LoadGame = ModOptions

-- when new lakes are added
local ChoOrig_PlacePrefab = LandscapeLake.PlacePrefab
function LandscapeLake:PlacePrefab(...)
	ChoOrig_PlacePrefab(self, ...)

	if not mod_EnableLakes then
		local water = self.water_obj
		local pos = water:GetPos()
		DoneObject(water)
		water = BuildingEntityClass:new()
		water:SetPos(pos)
		UpdateLakeObj(water, self)
		self.water_obj_fake = water
	end
end

local offsets = {
	LakeHug = 360,
	LakeBig = 200,
	LakeMid = 120,
	LakeSma = 150,
}

local ChoOrig_UpdateVisuals = LandscapeLake.UpdateVisuals
function LandscapeLake:UpdateVisuals(...)
	if mod_EnableLakes then
		return ChoOrig_UpdateVisuals(self, ...)
	end

  if self.volume_max <= 0 then
    return
  end
  if IsValid(self.water_obj_fake) then
    -- local x, y, z0 = self.water_obj_fake:GetVisualPosXYZ()
    local x, y = self.water_obj_fake:GetVisualPosXYZ()
    -- local dl = self.level_max - self.level_min
    local z = self.level_min + sqrt(MulDivRound(self.dl2, self.volume, self.volume_max))

		-- make sure our fake texture stays below the ground
		z = z - offsets[self.entity:sub(1, 7)] or 100

    self.water_obj_fake:SetPos(x, y, z)
--~     if z0 <= z then
--~       terrain.UpdateWaterGridFromObject(self.water_obj_fake)
--~       return
--~     end
  end
  ApplyAllWaterObjects()
end
