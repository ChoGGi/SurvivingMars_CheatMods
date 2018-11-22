-- See LICENSE for terms

-- clickable map image

local ViewObjectMars = ViewObjectMars
local Clamp = Clamp
local point = point
local box = box
local sizebox = sizebox
--~ local ScreenToGame = ScreenToGame
local HexGetNearestCenter = HexGetNearestCenter
local ScaleXY = ScaleXY
local ClampPoint = terrain.ClampPoint
local DrawImageFit = UIL.DrawImageFit
local GetSurfaceHeight = terrain.GetSurfaceHeight


DefineClass.ChoGGi_MinimapDlg = {
	__parents = {"ChoGGi_Window"},
	dialog_width = 500.0,
	dialog_height = 500.0,

	objects = false,
}

function ChoGGi_MinimapDlg:Init(parent, context)
	local g_Classes = g_Classes
	-- so it updates the hud button when we use the X to close
	self.close_func = HUD.idMinimapOnPress

	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	self.idDialog:SetTransparency(100)

	self.idMapImage = g_Classes.XFrame:new({
		Id = "idMapImage",
	}, self.idDialog)

	self.idMapControl = g_Classes.ChoGGi_MapControl:new({
		Id = "idMapControl",
	}, self.idMapImage)

	-- default dialog position if we can't find the ui stuff (new version or whatnot)
	local x,y = 150,75
	local HUD = Dialogs.HUD

	if HUD then
		-- wrapped in a pcall, so if we fail then it doesn't matter (other than an error in the log)
		pcall(function()
			x,y = HUD.idRight.box:minxyz()
--~ 			x = x - 25
			y = y - self.dialog_height
		end)
	end

	if context.x then
		x = context.x
	end
	if context.y then
		y = context.y
	end
	self:SetInitPos(nil,point(x,y))

	-- store any dome images, and whatnot here
	self.objects = {}

	self:AddObjects()
end

-- clickable icons....
function ChoGGi_MinimapDlg:AddObjects()
end

function ChoGGi_MinimapDlg:UpdateObjects()
end

DefineClass.ChoGGi_MapControl = {
  __parents = {"XControl"},

  slider_color = red,
  slider_size = point(20, 20),
  slider_image = "CommonAssets/UI/circle-20.tga",
	-- update circle?
	mouse_pt = false,
	-- move camera?
	mouse_down = false,
	sphere = false,
	sphere_size = 500 * guic,
	sphere_colour = green,
}

local map_limit
function ChoGGi_MapControl:OnMouseButtonDown(pt, button)
  if button == "L" then

		if not map_limit then
			map_limit = terrain.GetMapWidth() - const.ConstructBorder
		end
		if not IsValid(self.sphere) then
			self.sphere = ChoGGi_Sphere:new()
			self.sphere:SetRadius(self.sphere_size)
			self.sphere:SetColor(self.sphere_colour)
		end

		self.mouse_down = true
		self:OnMousePos(pt)

		-- workaround to update mouse pos
		self.desktop:SetFocus()
		self:SetFocus()

    return "break"
  end
end
function ChoGGi_MapControl:OnMouseButtonUp(pt, button)
  if button == "L" then
		if IsValid(self.sphere) then
			self.sphere:delete()
		end
		self.mouse_down = false
    return "break"
  end
end

function ChoGGi_MapControl:OnMousePos(pt)
  if not self.mouse_down then
    return "break"
  end

	-- relative pt on map image
	local content_box = self.content_box
	pt = point(
		map_limit - Clamp((pt:x() - content_box:minx()) * map_limit / content_box:sizex(), 0, map_limit),
		map_limit - Clamp((pt:y() - content_box:miny()) * map_limit / content_box:sizey(), 0, map_limit)
	)
--~ 	pt = HexGetNearestCenter(pt) or pt

	self.sphere:SetPos(pt:SetZ(GetSurfaceHeight(pt)))

	-- off we go
	ViewObjectMars(pt)

  return "break"
end

function ChoGGi_MapControl:OnMouseEnter(...)
	self.mouse_pt = true
	-- workaround to update mouse pos
	self.desktop:SetFocus()
	self:SetFocus()
	return XWindow.OnMouseEnter(self,...)
end
function ChoGGi_MapControl:OnMouseLeft(...)
	self.mouse_pt = false
	return XWindow.OnMouseLeft(self,...)
end

function ChoGGi_MapControl:DrawContent(clip_rect)
	if not self.mouse_pt then
		return
	end

  local content_box = self.content_box

	-- workaround to update mouse pos
	self.desktop:SetFocus()
	self:SetFocus()
	local x, y = self.desktop.last_mouse_pos:xy()

	local minx = content_box:minx()
	local miny = content_box:miny()
	local sizex = content_box:sizex()
	local sizey = content_box:sizey()

	-- I'm sure there's a better way to do this
  local percent_x = 1000 - Clamp((x - minx) * 1000 / sizex, 0, 1000)
  local percent_y = 1000 - Clamp((y - miny) * 1000 / sizey, 0, 1000)
  local weight_x = 1000 - Clamp(percent_x, 0, 1000)
  local weight_y = 1000 - Clamp(percent_y, 0, 1000)
  local slider_pos = point(
		minx + weight_x * sizex / 1000,
		miny + weight_y * sizey / 1000
	)

	local slider_size = point(ScaleXY(self.scale, self.slider_size:x(), self.slider_size:y()))
	local slider_box = sizebox(slider_pos - slider_size / 2, slider_size)
	DrawImageFit(self.slider_image, slider_box, slider_size:x(), slider_size:y(), box(0, 0, self.slider_size:x(), self.slider_size:y()), self.slider_color, 0)
end
