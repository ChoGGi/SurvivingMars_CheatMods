-- See LICENSE for terms

-- local some globals
local mapw, maph
local height_tile = terrain.HeightTileSize()
local function StartupCode()
	mapw, maph = terrain.GetMapSize()
	mapw = mapw - height_tile
	maph = maph - height_tile
end
OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

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

local guim = guim
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

  if #points > circle.max_vertices then
    local new_line = PlaceObject("Polyline", {
      max_vertices = #points
    })
    new_line:SetPos(circle:GetPos())
    DoneObject(circle)
    circle = new_line
  end
  circle:SetMesh(points,white)
end

function OnMsg.ClassesBuilt()
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

		elseif MouseShortcut(button) == "Shift-MouseL" then
			if circle and IsValid(circle) then
				DoneObject(circle)
			end
			orig_pos = GetTerrainCursor()

			-- PlaceTerrainCircle(center, radius, color, step, offset, max_steps)
			radius = orig_pos and orig_pos:Dist2D(GetTerrainCursor()) or 10
			circle = PlaceTerrainCircle(orig_pos,radius)
			circle:SetDepthTest(false)

			return
		end
		return OnMouseButtonDown(self,pt, button,...)
	end

	local OnMouseButtonUp = SelectionModeDialog.OnMouseButtonUp
	function SelectionModeDialog:OnMouseButtonUp(pt, button,...)
		if MouseShortcut(button) == "Shift-MouseL" then
			if circle and IsValid(circle) then
				DoneObject(circle)
			end

			SelectionRemove(Selection)
			local units = MapGet(orig_pos,radius,"attached",false,"Drone","BaseRover"--[[,"Colonist"--]])
			if #units < 1000 then
				SelectionAdd(units)
			end

			circle = false
			orig_pos = false
			radius = 0
			return
		end
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
