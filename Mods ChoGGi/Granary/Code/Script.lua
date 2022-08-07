-- See LICENSE for terms

if not g_AvailableDlc.armstrong then
	print(CurrentModDef.title, ": Green Planet DLC not installed!")
	return
end

local table = table
local IsValid = IsValid
local IsKindOf = IsKindOf

local mod_SeedRatio
local mod_HourlyDelay
local mod_HelpVeganHit

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_SeedRatio = CurrentModOptions:GetProperty("SeedRatio") * const.ResourceScale
	mod_HourlyDelay = CurrentModOptions:GetProperty("HourlyDelay") * const.HourDuration
	mod_HelpVeganHit = CurrentModOptions:GetProperty("HelpVeganHit")

	-- Make sure we're in-game
	if not UIColony then
		return
	end

	-- update new seed ratio desired amount
	local objs = UIColony:GetCityLabels("ChoGGi_Granary")
	for i = 1, #objs do
		-- buffer stored seeds for delivery delays
		objs[i].depot:SetDesiredAmount(mod_SeedRatio * 3)
	end

end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

DefineClass.ChoGGi_Granary = {
	__parents = {
		"Building",
		"ElectricityConsumer",
		"OutsideBuildingWithShifts",
		"UniversalStorageDepot",
	},

	spinner_lower = false,
	spinner_upper = false,
	depot = false,
}

function ChoGGi_Granary:GameInit()
	self:SetColorModifier(4074774)

	-- stick it in ground
	self:SetPos(self:GetVisualPos():AddZ(-190))
	-- add spinner
	local obj = PlaceObjectIn("EntityClass", self:GetMapID())
	obj:ChangeEntity("SensorTower")
	self:Attach(obj)
	-- stick it below glass
	obj:SetAttachOffset(point(0, 0, -3800))
	-- turn off shadow from "blades"
	obj:ClearEnumFlags(65536--[[efShadow]])
	--
	self.spinner_lower = obj

	-- add pole to middle
	obj = PlaceObjectIn("EntityClass", self:GetMapID())
	obj:ChangeEntity("WindTurbine")
	self:Attach(obj)

	-- mind the gap
	obj:SetScale(150)
	-- centre turbine (offset from the three point hex?)
	obj:SetAttachOffset(point(0, -865, -500))
	-- match speed with chaffer
	obj:SetAnimSpeedModifier(250)
	-- change default state to not moving
	obj:SetAnim(1, "idle")
	-- reddish hue
	obj:SetColorModifier(3352359)
	--
	self.spinner_upper = obj

	-- add hidden depot, should move this maybe?

	-- start off with all resource demands blocked
	for i = #self.storable_resources, 1, -1 do
		local res = self.storable_resources[i]
		if res == "Food" then
			self:ToggleAcceptResource(res)
		elseif res ~= "Seeds" then
			self:ToggleAcceptResource(res)
			table.remove(self.storable_resources, i)
		end
	end

	-- turn off shuttles
	StorageDepot.SetLRTService(self, false)

	-- buffer
	self:SetDesiredAmount(mod_SeedRatio * 3)

	-- y is needed for an offset (defaults to point20)
	local point30 = point30
	for id in pairs(self.placement_offset) do
		self.placement_offset[id] = point30
	end

	self:CreateGrainThread()

end

function ChoGGi_Granary:SetStorableResources(...)
	self.template_name = "UniversalStorageDepot"
	UniversalStorageDepot.SetStorableResources(self, ...)
	self.template_name = "ChoGGi_Granary"
end

function ChoGGi_Granary:CreateGrainThread()
	if IsValidThread(self.grain_thread) then
		DeleteThread(self.grain_thread)
	end

	self.grain_thread = CreateGameTimeThread(function()
		while IsValid(self) and not self.destroyed do
			if self.working then
				local stored_Seeds = self:GetStored_Seeds()
				local max_Seeds = self:GetMaxAmount_Seeds()
				local stored_Food = self:GetStored_Food()
				local max_Food = self:GetMaxAmount_Food()
				-- we need at least mod_SeedRatio
				if stored_Seeds >= mod_SeedRatio and max_Food - stored_Food > 1000 then
					local new_amount = (stored_Seeds - mod_SeedRatio)

					self.supply.Seeds:SetAmount(new_amount)
					self.demand.Seeds:SetAmount(max_Seeds - new_amount)
					self.stockpiled_amount.Seeds = new_amount
					self:SetCount(new_amount, "Seeds")

					self:AddResource(1000, "Food")

					RebuildInfopanel(self)
				else
					self.supply.Seeds:SetAmount(stored_Seeds)
					self.demand.Seeds:SetAmount(max_Seeds - stored_Seeds)
					self.stockpiled_amount.Seeds = stored_Seeds
					self:SetCount(stored_Seeds, "Seeds")
					self.stockpiled_amount.Food = stored_Food
					self:SetCount(stored_Food, "Food")
				end
			end -- if self.working then
			Sleep(mod_HourlyDelay)
--~ 			Sleep(5000)
		end
	end)
end

function ChoGGi_Granary:Done()
	if IsValidThread(self.grain_thread) then
		DeleteThread(self.grain_thread)
	end
end

function OnMsg.ClassesPostprocess()
	if not BuildingTemplates.ChoGGi_Granary then
		PlaceObj("BuildingTemplate", {
			"Id", "ChoGGi_Granary",
			-- class name from DefineClass
			"template_class", "ChoGGi_Granary",

			"palette_color1", "outside_accent_1",
			"palette_color2", "outside_base",
			"palette_color3", "electro_accent_2",

--~ 			"Asteroid","Underground","Surface",
			"disabled_in_environment1", "",
			"disabled_in_environment2", "",
			"disabled_in_environment3", "",
			"disabled_in_environment4", "",

			"dome_forbidden", true,
			"display_name", T(0000, "Granary"),
			"display_name_pl", T(0000, "Granaries"),
			"description", T(0000, "Produces food from seed. If placed near dome with Ranch then vegans will have less to complain about."),
			"display_icon", CurrentModPath .. "UI/granary.png",
--~ 			"display_icon", "UI/Icons/Buildings/placeholder.tga",
			"entity", "SpaceElevatorCabin",
--~ 			"construction_entity", "RocketLandingPlatform",
			"build_category", "ChoGGi",
			"Group", "ChoGGi",
			"encyclopedia_exclude", true,
			"on_off_button", true,
			"prio_button", true,
			"electricity_consumption", 2500,
			"construction_cost_Concrete", 14000,
			"construction_cost_Metals", 3000,
			"maintenance_resource_type", "Metals",
			"maintenance_resource_amount", 1000,
			"build_points", 1000,
			"demolish_sinking", range(1, 5),
		})
	end

end

function ChoGGi_Granary:OnSetWorking(working)
	OutsideBuildingWithShifts.OnSetWorking(self, working)
	ElectricityConsumer.OnSetWorking(self, working)
	if working then
		self.spinner_lower:SetAnim(1, "working")
		self.spinner_upper:SetAnim(1, "working")
	else
		self.spinner_lower:SetAnim(1, "idle")
		self.spinner_upper:SetAnim(1, "idle")
	end
end

-- Add bigger selection shape
local function StartupCode()
	-- cabin defaults to one hex, since you normally don't select it
	HexOutlineShapes.SpaceElevatorCabin = HexOutlineShapes.FusionReactor
	SelectionShapes.SpaceElevatorCabin = SelectionShapes.FusionReactor
end
-- New games
OnMsg.CityStart = StartupCode
-- Saved ones
OnMsg.LoadGame = StartupCode


-- Override for vegan ranches

-- copy pasta from Animals.lua prunariu lua rev 1011140
local CheckForGranary = function(dome)
  for _, wp in ipairs(dome.labels.ResourceStockpile or empty_table) do
    if wp.working and IsKindOf(wp, "ChoGGi_Granary") then
      return true
    end
  end
end
local CheckForGranaryNearby = function(dome)
  if CheckForGranary(dome) then
    return true
  end
--~   for d in pairs(dome:GetConnectedDomes()) do
--~     if CheckForGranary(d) then
--~       return true
--~     end
--~   end
end

local ChoOrig_UpdatePastureImpactOnVegans = UpdatePastureImpactOnVegans
function UpdatePastureImpactOnVegans(dome, ...)
	if not mod_HelpVeganHit then
		return ChoOrig_UpdatePastureImpactOnVegans(dome, ...)
	end

--~ 	if CheckForGranaryNearby(dome) then
	if CheckForGranary(dome) then
		const.PastureVeganMoraleImpact = 1
	end
	ChoOrig_UpdatePastureImpactOnVegans(dome, ...)
	const.PastureVeganMoraleImpact = 2
end
