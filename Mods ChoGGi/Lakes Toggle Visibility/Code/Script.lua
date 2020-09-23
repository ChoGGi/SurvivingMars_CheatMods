-- See LICENSE for terms

if not g_AvailableDlc.armstrong then
	print("Lakes Toggle Visibility needs DLC Installed: Green Planet!")
	return
end

local IsValid = IsValid
local DoneObject = DoneObject
local ApplyAllWaterObjects = ApplyAllWaterObjects
local sqrt = sqrt
local MulDivRound = MulDivRound

local mod_EnableLakes
local mod_EnableGridView

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

	local lakes = UICity.labels.LandscapeLake or ""
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

-- fired when settings are changed/init
local function ModOptions()
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

	local lakes = UICity.labels.Lakes or ""

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

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

OnMsg.CityStart = ModOptions
OnMsg.LoadGame = ModOptions

-- when new lakes are added
local orig_PlacePrefab = LandscapeLake.PlacePrefab
function LandscapeLake:PlacePrefab(...)
	orig_PlacePrefab(self, ...)
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

local orig_UpdateVisuals = LandscapeLake.UpdateVisuals
function LandscapeLake:UpdateVisuals(...)
	if mod_EnableLakes then
		return orig_UpdateVisuals(self, ...)
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
