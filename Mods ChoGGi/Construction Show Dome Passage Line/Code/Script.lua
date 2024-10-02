-- See LICENSE for terms

-- local some globals
local pairs = pairs
local GetEntityBuildShape = GetEntityBuildShape
local HexAngleToDirection = HexAngleToDirection
local IsValid = IsValid
local HexRotate = HexRotate
local HexToWorld = HexToWorld
local WorldToHex = WorldToHex
local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits
local point = point
local AveragePoint2D = AveragePoint2D
local GetCursorWorldPos = GetCursorWorldPos

local point20 = point20
local green = green
-- keep my hexes above dome ones (30 is from UpdateShapeHexes(obj))
local point31z = point(0, 0, 31)
-- no sense in checking domes too far away
local too_far_away = 5000000
-- stores list of domes, markers, and dome points
local dome_list = {}
-- skip green squares if true
local dome_over_count = false

local mod_Enable
local mod_AdjustLineLength
local mod_LotsOfDomes
local max_line_len
local options

local OPolyline
local OHexSpot
function OnMsg.ClassesPostprocess()
	OPolyline = ChoGGi_OPolyline
	OHexSpot = ChoGGi_OHexSpot
	if not OPolyline.SetLine then
		local line_points = {}
		OPolyline.SetLine = function(a, b)
			line_points[1] = a
			line_points[2] = b
		--~ 	self.vertices = line_points
			self.max_vertices = #line_points
			self:SetMesh(line_points)
			self:SetPos(AveragePoint2D(line_points))
		end
	end
end

-- Fired when settings are changed/init
local function ModOptions()
	options = CurrentModOptions
	mod_Enable = options:GetProperty("Enable")
	mod_AdjustLineLength = options:GetProperty("AdjustLineLength")
	mod_LotsOfDomes = options:GetProperty("LotsOfDomes")

	-- How long passages can be
	local max_hex = GridConstructionController.max_hex_distance_to_allow_build - mod_AdjustLineLength
	-- hex to hex
	max_line_len = max_hex * 10 * guim

	-- Make sure we're in-game
	if not UIColony then
		return
	end

	if mod_LotsOfDomes == 0 then
		dome_over_count = false
	elseif #UIColony:GetCityLabels("Domes") > mod_LotsOfDomes then
		dome_over_count = true
	else
		dome_over_count = false
	end
end

-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- Return if not one of these ids
local lookup_ids = {
	-- Mine
	ChoGGi_ConstructionExtendLength = true,
	-- Longer Passages Tech
	SydEojd = true,
	-- This mod
	[CurrentModId] = true,
}

-- Fired when option is changed
function OnMsg.ApplyModOptions(id)
	if not lookup_ids[id] then
		return
	end

	-- Remove limit if mod(s) enabled
	if table.find(ModsLoaded, "id", "ChoGGi_ConstructionExtendLength")
		or table.find(ModsLoaded, "id", "SydEojd")
	then
		too_far_away = HexMapWidth * 1000
	else
		too_far_away = 50000
	end

	ModOptions()
end

function OnMsg.SaveGame()
	dome_list = {}
end

-- Add dome spots to dome_list
local function BuildDomeSpots(dome)
	local spots = {}
	local c = 0

	-- No shapes stored for constructions
	local entity_name = dome.alternative_entity or dome:GetEntity()
	entity_name = string.gsub(entity_name, "Construction", "")

	-- Interior shape of dome without roads (con sites need to use alternative_entity or it's the wrong entity)
	local shape = GetEntityBuildShape(entity_name)

	-- Needed if dome isn't placed in default angle
	local rotation = HexAngleToDirection(dome:GetAngle())
	-- Applies the offset of dome shape to the world hex location
	for i = 1, #shape do
		local q1, r1 = WorldToHex(dome)
		local q2, r2 = HexRotate(shape[i]:x(), shape[i]:y(), rotation)
		c = c + 1
		spots[c] = point(HexToWorld(q1 + q2, r1 + r2)):SetTerrainZ()
	end

	-- We only want to add placed domes to the stored domes list
	if dome.name then
		dome_list[dome].spots = spots
	end

	return spots
end

local function BuildMarkers(dome)
	-- No need to re-add domes to the list
	if not dome_list[dome] then
		dome_list[dome] = {
			line = OPolyline:new(),
			hex1 = OHexSpot:new(),
			hex2 = OHexSpot:new(),
		}
		local item = dome_list[dome]

		item.hex1:SetColorModifier(green)
		item.hex2:SetColorModifier(green)
		item.hex1:SetVisible(false)
		item.hex2:SetVisible(false)
		-- Not my magic numbers
--~ 		item.line:SetCustomDataString(1, 11, white_str)

		BuildDomeSpots(dome)
	end
end

-- Add any existing domes to dome_list
local function StartupCode()
	ModOptions()

	-- Add markers for existing domes
	local domes = UIColony:GetCityLabels("Domes")
	for i = 1, #domes do
		BuildMarkers(domes[i])
	end
end
OnMsg.LoadGame = StartupCode
OnMsg.CityStart = StartupCode

-- Return the dome hex nearest to the cursor pos
local function RetNearestSpot(dome, pos)
	local pos_spots

	-- If it's in the table then it's a placed dome
	if dome_list[dome] then
		pos_spots = dome_list[dome].spots
	else
		-- Else it's the cursor building (need to build spot pos each time since it's on the move)
		pos_spots = BuildDomeSpots(dome)
	end

	-- Get nearest
	local length = max_int
	local nearest = pos_spots[1]
	local new_length, spot
	for i = 1, #pos_spots do
		spot = pos_spots[i]
		new_length = spot:Dist2D(pos)
		if new_length < length then
			length = new_length
			nearest = spot
		end
	end

	-- And done
	return nearest
end

local function UpdateVisibleHide(item)
	if not IsValid(item.line) then
		return
	end
	if item.line:GetVisible() then
		item.line:SetVisible(false)
		if not dome_over_count then
			item.hex1:SetVisible(false)
			item.hex2:SetVisible(false)
		end
	end
end
local function UpdateVisibleShow(item)
	if not IsValid(item.line) then
		return
	end
	if not item.line:GetVisible() then
		item.line:SetVisible(true)
		if not dome_over_count then
			item.hex1:SetVisible(true)
			item.hex2:SetVisible(true)
		end
	end
end

-- Remove removed domes from dome_list
local function ListCleanup(dome, item)
	item.line:delete()
	item.hex1:delete()
	item.hex2:delete()
	dome_list[dome] = nil
end

local HexSize = const.HexSize
--~ local cursor_length = max_int
local cursor_pos = point20
local function UpdateMarkers(self, current_pos)
	if not current_pos then
		current_pos = GetCursorWorldPos()
	end

	-- Abort if mouse hasn't moved far enough
	local current_length = current_pos:Dist2D(cursor_pos)
	if current_length > HexSize then
		cursor_pos = current_pos
--~ 		cursor_length = current_length
	else
		return
	end

	SuspendPassEdits("ChoGGi.CursorBuilding.UpdateCursor.UpdateMarkers")
	-- Loop through domes and show any lines that are close enough
	for dome, item in pairs(dome_list) do
		if IsValid(dome) then
			local dome_pos = dome:GetPos()
			-- Any domes too far away, just hide markers instead of checking for hex closeness
			if current_pos:Dist2D(dome_pos) > too_far_away then
				UpdateVisibleHide(item)
			else
				-- Get nearest hex from placed dome to cursor
				local placed_dome_spot = (RetNearestSpot(dome, current_pos) or point20) + point31z
				-- Get nearest hex from cursor dome to placed dome
				local cursor_dome_spot = (RetNearestSpot(self.cursor_obj, dome_pos) or point20) + point31z
				-- Show line if it's close enough
				if placed_dome_spot:Dist2D(cursor_dome_spot) > max_line_len then
					-- Hide it, or we'll have a line pointing at where the dome used to be (till it's too far away)
					UpdateVisibleHide(item)
				else
					-- Update hex/line pos and show
					if not dome_over_count then
						item.line:SetParabola(cursor_dome_spot, placed_dome_spot)
						item.hex1:SetPos(cursor_dome_spot)
						item.hex2:SetPos(placed_dome_spot)
					else
						item.line:SetLine(cursor_dome_spot, placed_dome_spot)
					end
					UpdateVisibleShow(item)
				end
			end
		else
			ListCleanup(dome, item)
		end
	end
	ResumePassEdits("ChoGGi.CursorBuilding.UpdateCursor.UpdateMarkers")
end

local ChoOrig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding:GameInit(...)
	if mod_Enable then
		if self.template and self.template:IsKindOf("Dome") then
			-- Loop through all domes and attach a line
			local domes = UIColony:GetCityLabels("Domes")
			for i = 1, #domes do
				BuildMarkers(domes[i])
			end
		end
	end

	return ChoOrig_CursorBuilding_GameInit(self, ...)
end

local ChoOrig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding:Done(...)
	-- We're done construction hide all the markers
	SuspendPassEdits("ChoGGi.CursorBuilding.Done.CleanupOldMarkers")
	for dome, item in pairs(dome_list) do
		if IsValid(dome) then
			UpdateVisibleHide(item)
		else
			ListCleanup(dome, item)
		end
	end
	ResumePassEdits("ChoGGi.CursorBuilding.Done.CleanupOldMarkers")
	return ChoOrig_CursorBuilding_Done(self, ...)
end

local ChoOrig_ConstructionController_Rotate = ConstructionController.Rotate
function ConstructionController:Rotate(...)
	if mod_Enable then
		-- It needs to fire first so we can get updated angle
		local ret = ChoOrig_ConstructionController_Rotate(self, ...)
		UpdateMarkers(self)
		return ret
	end

	return ChoOrig_ConstructionController_Rotate(self, ...)
end

local ChoOrig_ConstructionController_UpdateCursor = ConstructionController.UpdateCursor
function ConstructionController:UpdateCursor(pos, ...)
	if mod_Enable then
		UpdateMarkers(self, pos)
	end
	return ChoOrig_ConstructionController_UpdateCursor(self, pos, ...)
end

-- They should get removed when the cursor building is removed, but just in case
function OnMsg.Demolished(dome)
	-- remove demo'ed domes from the list
	if dome_list[dome] then
		ListCleanup(dome, dome_list[dome])
	end
end
