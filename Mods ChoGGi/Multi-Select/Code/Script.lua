-- See LICENSE for terms

local mapw, maph
local height_tile = terrain.HeightTileSize()
local function StartupCode()
	mapw, maph = terrain.GetMapSize()
	mapw = mapw - height_tile
	maph = maph - height_tile
end
OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

-- local some globals
local MapGet = MapGet
local SelectionAdd = SelectionAdd
local SelectionRemove = SelectionRemove
local GetTerrainCursor = GetTerrainCursor
local RotateRadius = RotateRadius
local MulDivRound = MulDivRound
local Max = Max
local Min = Min
local Clamp = Clamp
local point = point
local PlaceTerrainCircle = PlaceTerrainCircle

local guim7 = 7 * guim
local white = white

-- store where initial mdown is
orig_pos = false
radius = 0
-- our circle object
circle = false

function OnMsg.SaveGame()
	if circle and IsValid(circle) then
		DoneObject(circle)
	end
	circle = false
end

local points = objlist:new()
local function UpdateCircle()
	points:Clear()

	radius = orig_pos:Dist2D(GetTerrainCursor()) or 100
  local steps = Min(Max(12, 44 * radius / (guim7)), 360)

  for i = 1, steps do
    local x, y = RotateRadius(radius, MulDivRound(21600, i, steps), orig_pos, true)
    points[i] = point(
			x,y
		):SetTerrainZ(30)
  end
	-- connect the dots
	points[steps+1] = points[1]

	-- if more/less points we need to delete old polyline and spawn a new one
  if #points > circle.max_vertices then
    local new_line = PlaceObject("Polyline", {
      max_vertices = #points
    })
    new_line:SetPos(circle:GetPos())
    DoneObject(circle)
    circle = new_line
		-- add radius text to circle for when people set radius in hud button
		local text_obj = PlaceObject("Text")
		text_obj:SetText(radius)
		circle:Attach(text_obj)
  end
  circle:SetMesh(points,white)
end

function OnMsg.ClassesBuilt()
	local circle_enabled = false
	local dbl_clicked = false
	local selection_changed = false
	local saved_radius = 1000

	local GoToPos = UnitController.GoToPos
	local OnMouseButtonDown = SelectionModeDialog.OnMouseButtonDown
	function SelectionModeDialog:OnMouseButtonDown(pt, button,...)
		if button == "R" and #Selection > 1 then
			local Selection = Selection
			for i = 1, #Selection do

				if self.interaction_obj then
					Selection[i]:InteractWithObject(self.interaction_obj)
				else
					local u = Selection[i]
					if u:HasMember("GoToPos") then
						u:GoToPos(self.interaction_pos)
					else
						u:SetCommandUserInteraction("GotoFromUser", self.interaction_pos)
					end
					CreateGameTimeThread(RebuildInfopanel, u)
				end

			end
			return "break"

		elseif button == "L" and MouseShortcut(button) == "Shift-MouseL" then
			-- if obj under mouse then add/remove it from selection
			-- otherwise start a new circle
			local obj = GetPreciseCursorObj()
			if obj and obj:IsKindOf("DroneBase") then
				local Selection = Selection
				local idx = table.find(Selection,"handle",obj.handle)
				if idx then
					SelectionRemove(obj)
				else
					SelectionAdd(obj)
				end
				-- so onmouseup doesn't change selection
				selection_changed = true
			else
				if circle and IsValid(circle) then
					DoneObject(circle)
				end
				orig_pos = GetTerrainCursor()

				-- PlaceTerrainCircle(center, radius, color, step, offset, max_steps)
				radius = orig_pos and orig_pos:Dist2D(GetTerrainCursor()) or 10
				circle = PlaceTerrainCircle(orig_pos,radius)
				circle:SetDepthTest(false)

				circle_enabled = true
			end

			return "break"
		end
		return OnMouseButtonDown(self,pt, button,...)
	end

	local OnMouseButtonDoubleClick = SelectionModeDialog.OnMouseButtonDoubleClick
	function SelectionModeDialog:OnMouseButtonDoubleClick(pt, button,...)
		if button == "L" and MouseShortcut(button) == "Shift-MouseL" then
			local selected = GetPreciseCursorObj()
			if selected and selected:IsKindOf("DroneBase") then
				local temp_radius = saved_radius
				local mouse_pt = GetTerrainCursor()
				local cls = selected.class

				local objs = MapGet("map", "attached", false, selected.class,function(o)
					return o.class == cls and mouse_pt:Dist2D(o:GetVisualPos()) <= temp_radius
				end)

				SelectionRemove(Selection)
				if #objs < 1000 then
					SelectionAdd(objs)
				end

				-- stop onmouseup from removing selection
				dbl_clicked = true

				return "break"
			end
		end

		return OnMouseButtonDoubleClick(self,pt, button,...)
	end

	local OnMouseButtonUp = SelectionModeDialog.OnMouseButtonUp
	function SelectionModeDialog:OnMouseButtonUp(pt, button,...)
		if not (dbl_clicked and selection_changed) and button == "L" and circle_enabled and MouseShortcut(button) == "Shift-MouseL" then

			if circle and IsValid(circle) then
				DoneObject(circle)
			end

			SelectionRemove(Selection)
			local units = MapGet(orig_pos,radius,"attached",false,"DroneBase"--[[,"Colonist"--]])
			if #units < 1000 then
				SelectionAdd(units)
			end

			circle_enabled = false
			circle = false
			orig_pos = false
			if radius > 100 then
				saved_radius = radius
			end
			return
		end

		dbl_clicked = false
		selection_changed = false

		return OnMouseButtonUp(self,pt, button,...)
	end

	local OnMousePos = SelectionModeDialog.OnMousePos
	function SelectionModeDialog.OnMousePos(...)
		if circle and IsValid(circle) then
			CreateRealTimeThread(UpdateCircle)
		end
		return OnMousePos(...)
	end

end
