-- See LICENSE for terms

local mod_UndergroundDeposits
local mod_MaxGrade

local MaxFillAll

-- fired when settings are changed/init
local function ModOptions()
	mod_UndergroundDeposits = CurrentModOptions:GetProperty("UndergroundDeposits")
	mod_MaxGrade = CurrentModOptions:GetProperty("MaxGrade")

	MaxFillAll()
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


-- depth_layer: 2 = core, 1 = underground

local max = 500000 * const.ResourceScale

local function MaxDeposits(objs)
	for i = 1, #objs do
		local obj = objs[i]
		if obj.depth_layer == 1 and mod_UndergroundDeposits then
			obj.max_amount = max
			if mod_MaxGrade then
				obj.grade = "Very High"
			end

		elseif obj.depth_layer == 2 then
			obj.max_amount = max
			if mod_MaxGrade then
				obj.grade = "Very High"
			end
		end
	end
end

local function RefillAllDeposits(objs)
	for i = 1, #objs do
		local obj = objs[i]

		if obj.depth_layer == 1 and mod_UndergroundDeposits then
			obj:CheatRefill()

		elseif obj.depth_layer == 2 then
			obj:CheatRefill()
		end

	end
end

-- needed
if not TerrainDeposit.CheatRefill then
	function TerrainDeposit:CheatRefill()
		self.amount = self.max_amount
	end
end

MaxFillAll = function()
	local UICity = UICity
	if UICity then
		MaxDeposits(UICity.labels.SubsurfaceDeposit or "")
		RefillAllDeposits(UICity.labels.SubsurfaceDeposit or "")
		MaxDeposits(UICity.labels.TerrainDeposit or "")
		RefillAllDeposits(UICity.labels.TerrainDeposit or "")
	end
end

-- saved games
OnMsg.LoadGame = MaxFillAll
-- new sol
function OnMsg.NewDay()
	RefillAllDeposits(UICity.labels.SubsurfaceDeposit or "")
	RefillAllDeposits(UICity.labels.TerrainDeposit or "")
end

--
local function DepositRevealed(obj)
	if obj.depth_layer == 1 and mod_UndergroundDeposits then
		obj.max_amount = max
		if mod_MaxGrade then
			obj.grade = "Very High"
		end
		obj:CheatRefill()

	elseif obj.depth_layer == 2 then
		obj.max_amount = max
		if mod_MaxGrade then
			obj.grade = "Very High"
		end
		obj:CheatRefill()
	end
end

OnMsg.WaterDepositRevealed = DepositRevealed
OnMsg.SubsurfaceDepositRevealed = DepositRevealed

-- needed till they add a Msg like above
local orig_SpawnDeposit = TerrainDepositMarker.SpawnDeposit
function TerrainDepositMarker.SpawnDeposit(...)
	local deposit = orig_SpawnDeposit(...)
	DepositRevealed(deposit)
	return deposit
end
