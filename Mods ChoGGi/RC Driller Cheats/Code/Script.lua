-- See LICENSE for terms

if not g_AvailableDlc.gagarin then
	print(CurrentModDef.title, ": Space Race DLC not installed! Abort!")
	return
end

local has_picard = g_AvailableDlc.picard

local MapsForEach = MapsForEach
local IsKindOf = IsKindOf
local GetRealm = GetRealm
local GetRandomPassableAround = GetRandomPassableAround
local pcall = pcall

ChoGGi_Funcs.Common.AddParentToClass(RCDriller, "AutoMode")

local mod_EnableMod
local mod_AllowDeep
local mod_LossAmount
local mod_ProductionPerDay
local mod_RemoveSponsorLock
local mod_NoWasteRock

local function UpdateRovers()
	if not UIColony then
		return
	end

	if mod_RemoveSponsorLock then
		BuildingTemplates.RCDrillerBuilding.sponsor_status1 = false

		local reqs = BuildingTechRequirements.RCDrillerBuilding
		local idx = table.find(reqs, "check_supply", "RCDriller")
		if idx then
			table.remove(reqs, idx)
		end
	else
		BuildingTemplates.RCDrillerBuilding.sponsor_status1 = "required"
		BuildingTechRequirements.RCDrillerBuilding[1] = {
			hide = true,
			tech = "RoverPrinting",
			check_supply = "RCDriller",
		}
	end

	RCDriller.deposit_lost_pct = mod_LossAmount
	RCDriller.production_per_day = mod_ProductionPerDay

	local objs = UIColony:GetCityLabels("RCDriller")
	for i = 1, #objs do
		local obj = objs[i]
		obj.deposit_lost_pct = mod_LossAmount
		obj.production_per_day = mod_ProductionPerDay
	end
end

OnMsg.CityStart = UpdateRovers
OnMsg.LoadGame = UpdateRovers
-- switch between different maps (happens before UICity)
OnMsg.ChangeMapDone = UpdateRovers

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_AllowDeep = CurrentModOptions:GetProperty("AllowDeep")
	mod_LossAmount = CurrentModOptions:GetProperty("LossAmount")
	mod_ProductionPerDay = CurrentModOptions:GetProperty("ProductionPerDay") * const.ResourceScale
	mod_RemoveSponsorLock = CurrentModOptions:GetProperty("RemoveSponsorLock")
	mod_NoWasteRock = CurrentModOptions:GetProperty("NoWasteRock")

	UpdateRovers()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- bit of copy pasta from transport code
function RCDriller:GetAutoGatherDeposits()
	if has_picard then
		return {
			"SubsurfaceDepositPreciousMinerals",
			"SubsurfaceDepositPreciousMetals",
			"SubsurfaceDepositMetals",
		}
	else
		return {
			"SubsurfaceDepositPreciousMetals",
			"SubsurfaceDepositMetals",
		}
	end
end

function RCDriller:Automation_Gather()
  local unreachable_objects = self:GetUnreachableObjectsTable()
  local realm = GetRealm(self)
  local deposit = realm:MapFindNearest(self, "map", self:GetAutoGatherDeposits(), function(d)
		if not self:CanExploit(d) then
      return
    end
    return not unreachable_objects[d]
  end)

  if deposit then
		local pos = deposit:GetPos()
    if self:HasPath(deposit, pos) then
			-- probably not needed?
			if self:GetDist2D(pos) > 15000 then
				self:ReleaseStockpile()
			end
      self:SetCommand("Drill", deposit, GetRandomPassableAround(pos, 500, 500, self.city or MainCity))
    else
      unreachable_objects[deposit] = true
    end
  end
end

function RCDriller:ProcAutomation()
	if g_RoverAIResearched and self:IsAutoModeEnabled() then
    self:Automation_Gather()
	end
  Sleep(2500)
end

local ChoOrig_RCDriller_Idle = RCDriller.Idle
function RCDriller:Idle(...)
	if not mod_EnableMod then
		return ChoOrig_RCDriller_Idle(self, ...)
	end

  self:Gossip("Idle")
  self:SetState("idle")
  if self:IsAutoModeEnabled() then
    self:ProcAutomation()
	else
		Halt()
	end
end

local allowed_res = {
	Metals = true,
	PreciousMetals = true,
	PreciousMinerals = true,
}
local ChoOrig_RCDriller_CanExploit = RCDriller.CanExploit
function RCDriller:CanExploit(deposit, ...)
	if mod_AllowDeep then
		return allowed_res[deposit and deposit.resource]
	end

	return ChoOrig_RCDriller_CanExploit(self, deposit, ...)
end

RCDriller.ToggleAutoMode_Update = RCTransport.ToggleAutoMode_Update

function OnMsg.ClassesPostprocess()
	ChoGGi_Funcs.Common.RemoveXTemplateSections(XTemplates.ipRover[1], "ChoGGi_Template_RCDrillerCheats_ToggleAuto", true)
end

-- update driller when rubble cleared underground (I could check if it already happens, but it won't hurt much to fire twice)
local ChoOrig_RubbleBase_OnClear = RubbleBase.OnClear
function RubbleBase.OnClear(...)
	if mod_EnableMod then
		-- Lua\Units\BaseRover.lua > local InvalidateAllRoverUnreachables = function()
		MapsForEach("map", "BaseRover", function(r)
			if IsKindOf(r, "AutoMode") then
				r:Notify("UnreachableObjectsInvalidated")
			end
		end)
	end

	return ChoOrig_RubbleBase_OnClear(...)
end


local ChoOrig_CalcWasteRockAmount = CalcWasteRockAmount
local function ChoFake_CalcWasteRockAmount()
	return 0
end

local ChoOrig_RCDriller_DrillProc = RCDriller.DrillProc
function RCDriller.DrillProc(...)
	if not mod_EnableMod then
		return ChoOrig_RCDriller_DrillProc(...)
	end

	if mod_NoWasteRock then
		-- always return 0 waste rock
		CalcWasteRockAmount = ChoFake_CalcWasteRockAmount

		local result, ret = pcall(ChoOrig_RCDriller_DrillProc, ...)
		-- restore func
		CalcWasteRockAmount = ChoOrig_CalcWasteRockAmount
		-- and done
		if result then
			return ret
		else
			print("RCDriller.DrillProc failed!", ret)
		end
	end

	return ChoOrig_RCDriller_DrillProc(...)
end
