-- See LICENSE for terms

local mod_EnableMod
--~ local mod_CleanLeftovers

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
--~ 	mod_CleanLeftovers = CurrentModOptions:GetProperty("CleanLeftovers")

--~ 	-- Remove leftovers
--~ 	if UIColony and mod_CleanLeftovers then
--~ 	end
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local IsValid = IsValid
local FixConstructPos = FixConstructPos
local UnbuildableZ = buildUnbuildableZ()

-- last checked 1010999
local ChoOrig_ConstructionController_UpdateCursor = ConstructionController.UpdateCursor
function ConstructionController:UpdateCursor(pos, force, ...)
	if not mod_EnableMod or not self.is_template then
		return ChoOrig_ConstructionController_UpdateCursor(self, pos, force, ...)
	end

	if self.template_obj.dome_spot ~= "Spire" then
		return ChoOrig_ConstructionController_UpdateCursor(self, pos, force, ...)
	end

  if IsValid(self.cursor_obj) then
    self.spireless_dome = false
    local hex_world_pos = HexGetNearestCenter(pos)
    local game_map = ActiveGameMap
    local build_z = game_map.buildable:GetZ(WorldToHex(hex_world_pos)) or UnbuildableZ
    local terrain = game_map.terrain
    if build_z == UnbuildableZ then
--~       build_z = pos:z() or terrain:GetHeight(pos)
      build_z = pos:z() or game_map.realm:SnapToTerrain(pos)
    end
    hex_world_pos = hex_world_pos:SetZ(build_z)

--~     local placed_on_spot = false
--~     if self.is_template and not self.template_obj.dome_forbidden and self.template_obj.dome_spot ~= "none" then
--~       local object_hex_grid = game_map.object_hex_grid
--~       local dome = GetDomeAtPoint(object_hex_grid, hex_world_pos)
--~       if dome and IsValid(dome) and IsKindOf(dome, "Dome") then
--~         if dome:HasSpot(self.template_obj.dome_spot) then
--~           local idx = dome:GetNearestSpot(self.template_obj.dome_spot, hex_world_pos)
--~           hex_world_pos = HexGetNearestCenter(dome:GetSpotPos(idx))
--~           placed_on_spot = true
--~           if self.template_obj.dome_spot == "Spire" and self.template_obj:IsKindOf("SpireBase") then
--~             local frame = self.cursor_obj:GetAttach("SpireFrame")
--~             if frame then
--~               local spot = dome:GetNearestSpot("idle", "Spireframe", self.cursor_obj)
--~               local pos = dome:GetSpotPos(spot)
--~               frame:SetAttachOffset(pos - hex_world_pos)
--~             end
--~           end
--~         elseif self.template_obj.dome_spot == "Spire" then
--~           self.spireless_dome = true
--~         end
--~       end
--~     end
--~     local new_pos = self.snap_to_grid and hex_world_pos or pos
--~     if not placed_on_spot then
--~       new_pos = FixConstructPos(terrain, new_pos)
--~     end

		-- Added by me
		local new_pos = FixConstructPos(terrain, self.snap_to_grid and hex_world_pos or pos)
		-- Added by me


    if force or FixConstructPos(terrain, self.cursor_obj:GetPos()) ~= new_pos and hex_world_pos:InBox2D(ConstructableArea) then
      ShowNearbyHexGrid(hex_world_pos)
      self.cursor_obj:SetPos(new_pos)
      self:UpdateConstructionObstructors()
      self:UpdateConstructionStatuses()
      self:UpdateShortConstructionStatus()
      ObjModified(self)
    end
  end
end

-- Fix "frame" added to dome
local ChoOrig_SpireBase_UpdateFrame = SpireBase.UpdateFrame
function SpireBase:UpdateFrame(...)
	if not mod_EnableMod then
		return ChoOrig_SpireBase_UpdateFrame(self, ...)
	end

	-- There's no return, but a mod might add one (need it to update offset before we change it)
	local ret = ChoOrig_SpireBase_UpdateFrame(self, ...)

	local attaches = self:GetAttaches("SpireFrame")
	if not attaches then
		return
	end

	local frame = attaches[1]
	if frame.entity == "TempleSpireFrame" and IsValid(self.parent_dome) then
		local dome_height = ObjectHierarchyBBox(self.parent_dome, const.efCollision):size():z()
		frame:SetAttachOffset(point(0, 0, dome_height))
	else
		-- Remove x/y offset, but keep height
		-- Arcology band?
		frame:SetAttachOffset(point(0, 0, frame:GetAttachOffset():z()))
	end

	return ret
end
