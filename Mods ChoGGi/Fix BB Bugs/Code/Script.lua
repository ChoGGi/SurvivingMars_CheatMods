-- See LICENSE for terms

local mod_EnableMod

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_City_InitBreakThroughAnomalies = City.InitBreakThroughAnomalies
function City:InitBreakThroughAnomalies(...)
	if not mod_EnableMod then
		return ChoOrig_City_InitBreakThroughAnomalies(self, ...)
	end

	-- This func is called for each new city (surface/underground/asteroids)
	-- Calling it more than once removes the BreakthroughOrder list
	-- That list is used to spawn planetary anomalies
	if self.map_id == MainMapID then
		return ChoOrig_City_InitBreakThroughAnomalies(self, ...)
	end

	-- underground or asteroid city
	local orig_BreakthroughOrder = BreakthroughOrder
	ChoOrig_City_InitBreakThroughAnomalies(self, ...)
	BreakthroughOrder = orig_BreakthroughOrder
end
--
function OnMsg.ClassesPostprocess()

	-- dozers and cave-in pathing (the game will freeze if you send dozers to certain cave-ins or certain paths? this is why I should keep save files around...).

	-- all of them use the same func
	local ChoOrig_RubbleBase_DroneApproach = RubbleBase.DroneApproach

	local ChoOrig_RCTerraformer_ClearRubble = RCTerraformer.ClearRubble
	function RCTerraformer:ClearRubble(rubble, ...)
		if not mod_EnableMod then
			return ChoOrig_RCTerraformer_ClearRubble(self, rubble, ...)
		end

		-- replace this func with working one
		rubble.DroneApproach = function()
			return self:GotoBuildingSpot(rubble, self.work_spot_task)
				or self:GotoBuildingSpot(rubble, self.work_spot_task, false, 6 * const.HexHeight)
		end

		ChoOrig_RCTerraformer_ClearRubble(self, rubble, ...)

		-- than restore orig func
		rubble.DroneApproach = ChoOrig_RubbleBase_DroneApproach

	end
	local bt = BuildingTemplates

	if bt.AncientArtifactInterface then
		bt.AncientArtifactInterface.can_refab = false
	end
	if bt.BottomlessPitResearchCenter then
		bt.BottomlessPitResearchCenter.can_refab = false
	end
	if bt.JumboCaveReinforcementStructure then
		bt.JumboCaveReinforcementStructure.can_refab = false
	end

	if not bt.UndergroundElevator then
		PlaceObj("BuildingTemplate", {
			"Group",			"Infrastructure",
			"SaveIn",			"picard",
			"Id",			"UndergroundElevator",
			"template_class",			"Elevator",
			"cargo_capacity",			0,
			"starting_drones",			0,
			"construction_cost_Concrete",			80000,
			"construction_cost_Metals",			20000,
			"construction_cost_MachineParts",			10000,
			"build_points",			20000,
			"dome_forbidden",			true,
			"show_range_class",			"DroneHub",
			"can_refab",			false,
			"maintenance_resource_type",			"MachineParts",
			"consumption_resource_stockpile_spot_name",			"",
			"display_name",			T(330073770544, "Elevator"),
			"display_name_pl",			T(951268120259, "Elevators"),
			"description",			T(365418570073, "Transports vehicles, colonists and resources between the surface and the underground of Mars."),
			"build_category",			"Infrastructure",
			"display_icon",			"UI/Icons/Buildings/elevator.tga",
			"build_pos",			19,
			"entity",			"ElevatorUnderground",
			"show_range",			true,
			"encyclopedia_id",			"Elevator",
			"encyclopedia_text",			T(177334925289, [[
		<em>The Elevator</em> can only be built on top off <em>Underground Passages</em> on the surface of Mars or on top off <em>Surface Passages</em> in the Martian underground. <em>The Elevator</em> can be powered and maintained from either side.

		Resources can be moved from one map to the other by using the <em>Edit Payload</em> action. Once a request for resources has been made it can be changed by using the <em>Edit Payload</em> action again and adjusting the resource amounts.]]),
			"encyclopedia_image",			"UI/Encyclopedia/Elevator.tga",
			"label1",			"OutsideBuildings",
			"palette_color1",			"outside_accent_factory",
			"palette_color2",			"outside_base",
			"palette_color3",			"outside_base",
			"demolish_sinking",			range(1, 5),
			"disabled_in_environment1",			"Asteroid",
			"disabled_in_environment2",			"Surface",
			"snap_target_type",			"SurfacePassage",
			"only_build_on_snapped_locations",			true,
			"snap_error_text",			T(133850725904, "Must be constructed over an Underground Entrance or Surface Tunnel."),
			"snap_error_short",			T(726714269530, "Must be built on an Underground Entrance or Surface Tunnel"),
			"electricity_consumption",			10000,
		})
	end

end
--
do -- I dunno, maybe paradox should push an update?
	if Platform.linux then
		local ChoOrig_UIL_RequestImage = UIL.RequestImage
		local ui_images = {}
		function UIL.RequestImage(image)
			table.insert_unique(ui_images, image)
			ChoOrig_UIL_RequestImage(image)
		end
		function OnMsg.SystemActivate()
			hr.TR_ForceReload = 1
			for _, image in ipairs(ui_images) do
				UIL.ReloadImage(image)
			end
		end
	end
end
--
do -- fix FindWater milestone
	Presets.Milestone.Default.FindWater.Complete = function (self)
--~     if GetRealmByID(MainMapID):MapContains("map", "SubsurfaceDeposit", function(o)
    if GetRealmByID(MainMapID):MapForEach("map", "SubsurfaceDeposit", function(o)
      return o.revealed and o.resource == "Water"
    end) then
      return true
    end
		while true do
			local ok, deposit = WaitMsg("WaterDepositRevealed")
			if deposit:GetMapID() == MainMapID then
				return true
			end
		end
	end
end
--
do -- landscaping
	local function UpdateRenderLandscape()
		local landscape_found = false
		for mark, landscape in pairs(Landscapes) do
			if landscape and landscape.map_id == ActiveMapID then
				landscape_found = true
				break
			end
		end
		hr.RenderLandscape = landscape_found and 1 or 0
	end
	OnMsg.SwitchMap = UpdateRenderLandscape

	local ChoOrig_ResetLandscapeGrid = ResetLandscapeGrid
	function ResetLandscapeGrid(...)
		ChoOrig_ResetLandscapeGrid(...)
		UpdateRenderLandscape()
	end
end
--
do -- fixup map id
	local ChoOrig_AddCustomOnScreenNotification = AddCustomOnScreenNotification
	function AddCustomOnScreenNotification(id, title, text, image, callback, params, map_id, ...)
		if map_id == nil then
			map_id = MainMapID
		elseif map_id == false then
			map_id = ""
		end

		return ChoOrig_AddCustomOnScreenNotification(id, title, text, image, callback, params, map_id, ...)
	end
end
--
function Workforce:ChooseTraining(colonist)
  local training_centers = self.labels.TrainingBuilding or empty_table
  local workplace, shift = ChooseTraining(colonist, training_centers)
  return workplace, shift
end
function Workforce:HasFreeWorkplacesAround(colonist)
  for _, b in ipairs(self.labels.Workplace or empty_table) do
    if not b.destroyed and b.ui_working and b:CanWorkHere(colonist) and b:HasFreeWorkSlots() then
      return true
    end
  end
  return false
end
--
do -- Check if selected before updating hex range on drone hub extenders
	function DroneHub:OnModifiableValueChanged(prop, old_val, new_val)
		if prop == "service_area_max" and IsObjectSelected(self) then
			ChangeHexRanges(self)
		end
	end
	if g_AvailableDlc.picard then
		function DroneHubExtender:OnModifiableValueChanged(prop, old_val, new_val)
			if prop == "work_radius" and IsObjectSelected(self) then
				ChangeHexRanges(self)
			end
		end
	end
end
--
function DoesAnyDroneControlServiceAtPoint(map_id, pt)
  local realm = GetRealmByID(map_id)
--~   return realm:MapContains(pt, "hex", const.CommandCenterMaxRadius, "DroneNode", function(center)
  return realm:MapForEach(pt, "hex", const.CommandCenterMaxRadius, "DroneNode", function(center)
    return (IsKindOfClasses(center, "DroneHub") or center.working) and HexAxialDistance(center, pt) <= center.work_radius
  end)
end

-- B&B fixes
if not g_AvailableDlc.picard then
	return
end
--
function UndergroundPassage:SnappedObjectPlaced(building)
	if IsKindOf(building, "ConstructionSite") then
		self.elevator_construction = building
		self.other.elevator_construction = building.linked_obj
	end
end
--
function SurfacePassage:SnappedObjectPlaced(building)
  if IsKindOf(building, "ConstructionSite") then
    self.elevator_construction = building
    self.other.elevator_construction = building.linked_obj
  end
end
--
function OnMsg.ConstructionSiteRemoved(construction_site)
  if construction_site and IsKindOf(construction_site.building_class_proto, "Elevator") then
    local passage = construction_site.snapped_to
    if passage then
      passage.elevator_construction = false
      passage.other.elevator_construction = false
    end
  end
end
--
function BaseMicroGExtractor:GatherConstructionStatuses(statuses)
  BuildingDepositExploiterComponent.GatherConstructionStatuses(self, statuses)
  if #self.nearby_deposits > 0 then
    local amounts = {}
    local grades = {}
    for _, deposit in ipairs(self.nearby_deposits) do
      if self:CanExploitResource(deposit) then
        amounts[deposit.resource] = (amounts[deposit.resource] or 0) + deposit.amount
        grades[deposit.resource] = Max(grades[deposit.resource] or 1, table.find(DepositGradesTable, deposit.grade) or 1)
      end
    end
    for res, amount in pairs(amounts) do
      local status = table.copy(ConstructionStatus.DepositInfo)
      local grade = grades[res]
      grade = DepositGradesTable[grade]
      grade = DepositGradeToDisplayName[grade]
      status.text = T({
        status.text,
        {
          resource = FormatResource(empty_table, amount, res),
          grade = grade,
          col = ConstructionStatusColors.info.color_tag
        }
      })
      statuses[#statuses + 1] = status
    end
  end
end
--
function Elevator:IsShroudedInRubble()
  return not Shroudable.IsShroudedInRubble(self) and self.other and Shroudable.IsShroudedInRubble(self.other)
end
--
if not SavegameFixups.BottomlessPitSwapResources then
	function SavegameFixups.BottomlessPitSwapResources_ChoGGi()
		local pits = UIColony:GetCityLabels("BottomlessPitResearchCenter")
		for _, pit in ipairs(pits) do
			pit.enabled_resources = {}
			local disabled_resources = pit.disabled_resources
			for _, resource in pairs(pit.accepted_resources) do
				if not table.find(disabled_resources, resource) then
					pit.enabled_resources[#pit.enabled_resources + 1] = resource
				end
			end
			pit.disabled_resources = nil
		end
	end

end
function BottomlessPitResearchCenter:DroneUnloadResource(drone, request, resource, amount)
  drone:PushDestructor(function(drone)
    local target = drone:IsValidPos() and drone or RotateRadius(100 * guim, AsyncRand(21600), self:GetPos())
    local entrance_type = drone.entrance_type or "entrance"
    local entrance = self:GetEntrance(target, entrance_type, nil, drone)
    self:LeadOut(drone, entrance)
  end)
  drone:SetCarriedResource(false)
  if self.demand[resource] and self.demand[resource] == request then
    local idx = table.find(self.stored_resources, "class", resource)
    self.stored_resources[idx].amount = self.stored_resources[idx].amount + amount / const.ResourceScale
  end
  Building.DroneUnloadResource(self, drone, request, resource, amount)
  drone:PopAndCallDestructor()
end
--
if not AncientArtifactInterface.GetEntrance then
	function AncientArtifactInterface:GetEntrance(target, entrance_type, spot_name)
		return {
			self:GetPos(),
			GetRandomPassableAround(self:GetPos(), 2 * const.HexSize, const.HexSize)
		}
	end
end
--
