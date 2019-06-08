-- See LICENSE for terms

if not g_AvailableDlc.armstrong then
	return
end
local IsValid = IsValid
local DoneObject = DoneObject
local ApplyAllWaterObjects = ApplyAllWaterObjects
local sqrt = sqrt
local MulDivRound = MulDivRound
local GameState = GameState

local options
local mod_EnableLakes
local mod_EnableGridView

-- fired when settings are changed and new/load
local function ModOptions()
	mod_EnableLakes = options.EnableLakes
	mod_EnableGridView = options.EnableGridView

	if not GameState.gameplay then
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
				water:ChangeEntity("GridTileWater")
				water:SetScale(500)
				lake.water_obj_fake = water
			end
		end
	end
	ApplyAllWaterObjects()
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_LakesToggleVisibility" then
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
		water:ChangeEntity("GridTileWater")
		water:SetScale(500)
		self.water_obj_fake = water
	end
end

local orig_UpdateVisuals = LandscapeLake.UpdateVisuals
function LandscapeLake:UpdateVisuals(...)
	if mod_EnableLakes then
		return orig_UpdateVisuals(self, ...)
	end

  if self.volume_max <= 0 then
    return
  end
  if IsValid(self.water_obj_fake) then
    local x, y, z0 = self.water_obj_fake:GetVisualPosXYZ()
    local dl = self.level_max - self.level_min
    local z = self.level_min + sqrt(MulDivRound(self.dl2, self.volume, self.volume_max))
    self.water_obj_fake:SetPos(x, y, z)
--~     if z0 <= z then
--~       terrain.UpdateWaterGridFromObject(self.water_obj_fake)
--~       return
--~     end
  end
  ApplyAllWaterObjects()
end
