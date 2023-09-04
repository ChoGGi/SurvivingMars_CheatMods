-- See LICENSE for terms

local mod_UseScreenshots

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_UseScreenshots = CurrentModOptions:GetProperty("UseScreenshots")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- clickable map image


local ViewObjectMars = ViewObjectMars
local Clamp = Clamp
local point = point
local box = box
local sizebox = sizebox
local tonumber = tonumber
local ScaleXY = ScaleXY
local DrawImageFit = UIL.DrawImageFit
local cameraRTS = cameraRTS
local terrain = terrain
local transition_time = 0

local GetCursorWorldPos = GetCursorWorldPos

local GetParentOfKind = ChoGGi.ComFuncs.GetParentOfKind
local function GetRootDialog(dlg)
	return dlg.parent_dialog or GetParentOfKind(dlg, "ChoGGi_MinimapDlg")
end
DefineClass.ChoGGi_MinimapDlg = {
	__parents = {"ChoGGi_XWindow"},
	dialog_width = 500.0,
	dialog_height = 500.0,
	dialog_original_pos = false,

	opacity = 100,

	map_name = false,
	-- Image name we save/load for map
	filename = false,

	map_update_thread = false,
	map_file = "AppData/minimap.tga",
	camera_sleep = 50,
}
local map_limit

function ChoGGi_MinimapDlg:Init(parent, context)
	-- crashes in main menu
	if not map_limit then
		map_limit = terrain.GetMapWidth() - const.ConstructBorder
	end

	local g_Classes = g_Classes
	-- so it updates the hud button when we use the X to close
	self.close_func = HUD.idMinimapOnPress

	self.filename = "AppData/Minimap.tga"

	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	self.idCaptionToggle = g_Classes.ChoGGi_XImageRows:new({
		Id = "idCaptionToggle",
		Dock = "left",
		ZOrder = 0,
		RolloverTitle = T(302535920011003, [[Toggle Controls]]),
		RolloverText = T(302535920011109, [[Toggle showing controls at bottom.]]),
		RolloverHint = T(608042494285, "<left_click> Activate"),
		OnMouseButtonDown = self.idCaptionToggleOnMouseButtonDown,
		MouseCursor = "UI/Cursors/Rollover.tga",
		HandleMouse = true,
		Image = "CommonAssets/UI/treearrow-40.tga",
		ScaleModifier = point(2000, 2000),
	}, self.idMoveControl)
	self.idCaptionToggle:SetRow(1)
	self.idCaption:SetPadding(box(self.idCaptionToggle.box:sizex(), 0, 0, 0))
	-- disable rollup for minimap (add as option in bottom
--~ 	self.idMoveControl.OnMouseButtonDoubleClick = empty_func

	self.idDialog:SetTransparency(self.opacity)

	self.idMapArea = g_Classes.ChoGGi_XDialogSection:new({
		Id = "idMapArea",
	}, self.idDialog)

	self.idMapImage = g_Classes.XFrame:new({
		Id = "idMapImage",
	}, self.idMapArea)

	self.idMapControl = g_Classes.ChoGGi_XMapControl:new({
		Id = "idMapControl",
	}, self.idMapImage)

	self.idToggleArea = g_Classes.ChoGGi_XDialogSection:new({
		Id = "idToggleArea",
		Dock = "bottom",
	}, self.idDialog)
	self.idToggleArea:SetVisible(false)
	self.idToggleArea:SetTransparency(-255)

	self.idToggleDblSize = g_Classes.ChoGGi_XButton:new({
		Id = "idToggleDblSize",
		Dock = "left",
		Text = T(302535920011110, [[Dbl Size]]),
		RolloverTitle = T(302535920011111, [[Double Size]]),
		RolloverText = T(302535920011112, [[Toggle between original size and double.]]),
		RolloverHint = T(608042494285, "<left_click> Activate"),
		OnPress = self.idToggleDblSizeOnPress,
	}, self.idToggleArea)

	self.idResetDialog = g_Classes.ChoGGi_XButton:new({
		Id = "idResetDialog",
		Dock = "left",
		Text = T(302535920011113, [[Reset]]),
		RolloverTitle = T(302535920011114, [[Reset Dialog]]),
		RolloverText = T(302535920011115, [[Moves map back to original position and size.]]),
		RolloverHint = T(608042494285, "<left_click> Activate"),
		OnPress = self.idResetDialogOnPress,
	}, self.idToggleArea)

	self.idUseScreenShots = g_Classes.ChoGGi_XCheckButton:new({
		Id = "idUseScreenShots",
		Dock = "left",
		Text = T(302535920011116, [[Image]]),
		RolloverTitle = T(302535920011117, [[Use ScreenShots]]),
		RolloverText = T(302535920011118, [[Screenshots or topography images (needs my map images pack mod).]]),
		RolloverHint = T(608042494285, "<left_click> Activate"),
		OnChange = self.idUseScreenShotsOnChange,
	}, self.idToggleArea)

	self.idUseScreenShots:SetCheck(mod_UseScreenshots)

	self.idUpdateMap = g_Classes.ChoGGi_XButton:new({
		Id = "idUpdateMap",
		Dock = "left",
		Text = T(302535920011119, [[Update]]),
		RolloverTitle = T(302535920011120, [[Update Image]]),
		RolloverText = T(302535920011121, [[This will update the map image (resets camera orientation).]]),
		RolloverHint = T(608042494285, "<left_click> Activate"),
		OnPress = self.idUpdateMapOnPress,
	}, self.idToggleArea)
	if not mod_UseScreenshots then
		self.idUpdateMap:SetVisible(false)
	end

	self.idOpacity = g_Classes.ChoGGi_XTextInput:new({
		Id = "idOpacity",
		Dock = "right",
		MinWidth = 50,
		RolloverText = T(302535920011122, [[Set opacity of map dialog (0 to 240).]]),
		OnTextChanged = self.idOpacityOnTextChanged,
	}, self.idToggleArea)
	self.idOpacity:SetText(tostring(self.opacity))

	-- default dialog position if we can't find the ui stuff (new version or whatnot)
	local x, y = 150, 75
	local HUD = Dialogs.HUD

	if HUD then
		-- wrapped in a pcall, so if we fail then it doesn't matter (other than an error in the log)
		pcall(function()
			x, y = HUD.idRight.box:minxyz()
--~ 			x = x - 25
			y = y - self.dialog_height_scaled
		end)
	end

	-- restore old pos
	x = context.x or x
	y = context.y or y
	local pt = point(x, y)
	self.dialog_original_pos = pt

	self:PostInit(nil, pt)
end

function ChoGGi_MinimapDlg:idUseScreenShotsOnChange()
	local check = self:GetCheck()
	ChoGGi_Minimap_Options.UpdateTopoImage(check)
	GetRootDialog(self).idUpdateMap:SetVisible(check)

	CurrentModOptions.UseScreenshots = check
	mod_UseScreenshots = check
	-- hopefully the devs add an option to update options...
end

function ChoGGi_MinimapDlg:idResetDialogOnPress()
	self = GetRootDialog(self)
	self:ResetSize()
	self:PostInit(nil, self.dialog_original_pos, true)
end

function ChoGGi_MinimapDlg:idToggleDblSizeOnPress()
	self = GetRootDialog(self)
	local size = self:GetSize()
	if size:x() == self.dialog_width_scaled and size:y() == self.dialog_height_scaled then
		self:SetSize(self.dialog_width_scaled*2, self.dialog_height_scaled*2)
		-- we don't want it off screen
		self:PostInit(nil, self:GetPos(), true)
	else
		self:ResetSize()
	end
end

function ChoGGi_MinimapDlg:idOpacityOnTextChanged()
	local num = tonumber(self:GetText())
	if num then
		-- Invisible doesn't help anyone
		if num > 240 then
			num = 240
		end
		GetRootDialog(self).idDialog:SetTransparency(num)
	end
end

function ChoGGi_MinimapDlg:idCaptionToggleOnMouseButtonDown()
	self = GetRootDialog(self)
	local visible = self.idToggleArea:GetVisible()
	if visible then
		self.idToggleArea:SetVisible(false)
		self.idCaptionToggle:SetRow(1)
	else
		self.idToggleArea:SetVisible(true)
		self.idCaptionToggle:SetRow(2)
	end
end

-- mostly from OverviewModeDialog
function ChoGGi_MinimapDlg:CameraPos_Screenshot()
	-- save current pos
	local old_pos = cameraRTS.GetEye()
	local old_lookat = cameraRTS.GetLookAt()
	local old_eye = old_lookat + MulDivRound(old_pos - old_lookat, 1000, cameraRTS.GetZoom())
	self.saved_camera = { eye = old_eye, lookat = old_lookat }
	self.saved_dist = old_eye:Dist(old_lookat)
	self.saved_angle = asin(MulDivRound(4096, old_eye:z() - old_lookat:z(), self.saved_dist))

	LockCamera("overview")

	local pos, lookat = CalcOverviewCameraPos(2700) --45*60

	pos = lookat + MulDivRound(pos - lookat, 1000, cameraRTS.GetZoom())
	cameraRTS.SetCamera(pos, lookat, transition_time)

	table.change(hr, "overview", {
		FarZ = 1500000,
		ShadowRangeOverride = 1500000,
		ShadowFadeOutRangePercent = 0,
	})
	camera.SetAutoFovX(1, transition_time, const.Camera.OverviewFovX_4_3, 4, 3, const.Camera.OverviewFovX_16_9, 16, 9)

	repeat
		Sleep(self.camera_sleep)
	until not cameraRTS.IsMoving()
end

function ChoGGi_MinimapDlg:CameraPos_Restore()
	local lookat = self.saved_camera and self.saved_camera.lookat or GetCursorWorldPos()

	-- clamp to the map borders
	local min_border = cameraRTS.GetBorder()
	local max_border = terrain.GetMapWidth() - min_border
	local dx, dy = 0, 0
	if lookat:x() < min_border then
		dx = min_border - lookat:x()
	end
	if lookat:x() > max_border then
		dx = max_border - lookat:x()
	end
	if lookat:y() < min_border then
		dy = min_border - lookat:y()
	end
	if lookat:y() > max_border then
		dy = max_border - lookat:y()
	end

	lookat = point(lookat:x() + dx, lookat:y() + dy):SetStepZ()
	local cpos, clookat = cameraRTS.GetEye(), cameraRTS.GetLookAt()
	local invdir = SetLen((cpos - clookat):SetZ(0), guim)
	local axis = SetLen(point(invdir:y(), -invdir:x(), 0), guim)
	invdir = RotateAxis(invdir, axis, self.saved_angle)
	local offset = SetLen(invdir, self.saved_dist)
	local eye = lookat + offset

	UnlockCamera("overview")

	cameraRTS.SetCamera(eye, lookat, transition_time)
	camera.SetAutoFovX(1, transition_time, const.Camera.DefaultFovX_16_9, 16, 9)

	table.restore(hr, "overview")

	repeat
		Sleep(self.camera_sleep)
	until not cameraRTS.IsMoving()
end

function ChoGGi_MinimapDlg:idUpdateMapOnPress()
	self = GetRootDialog(self)

	-- If someone decides to hammer the update button
	if IsValidThread(self.map_update_thread) then
		return
	end

	-- no need to update...
	if not mod_UseScreenshots then
		self:UpdateMapImage()
		return
	end

	local is_overview = InGameInterfaceMode == "overview"

	self.map_update_thread = CreateRealTimeThread(function()
		-- we don't need to fiddle with camera if we're already in overview
		if not is_overview then
			self:CameraPos_Screenshot()
		end

		-- figure out a way to capture a 16:9 from a 48:9?
		if not WaitCaptureScreenshot(self.map_file, {
--~ 			width = 1920,
--~ 			height = 1080,
--~ 			src = box(point20, point(1920, 1080)),
			interface = false,
		}) then
			WaitMsg("OnRender")
			-- needed to be able to update control
			UnloadTexture(self.map_file)
			WaitMsg("OnRender")
			self:UpdateMapImage(self.map_file)
		end

		if not is_overview then
			self:CameraPos_Restore()
		end
	end)
end

function ChoGGi_MinimapDlg:UpdateMapImage(image)
	if image then
		self.idMapImage:SetImage(image)
	else
		local str = ChoGGi_Minimap.image_str
		if str then
			self:UpdateMapImage(str:format(self.map_name))
		end
	end
end

--~ GetRootDialog2(self)
--~ local function GetRootDialog2(dlg)
--~ 	return dlg.parent_dialog or GetParentOfKind(dlg, "ChoGGi_XMapControl")
--~ end
DefineClass.ChoGGi_XMapControl = {
	__parents = {"XControl"},
	-- the little red circle that could
	slider_color = red,
	slider_size = point(20, 20),
	slider_image = "CommonAssets/UI/circle-20.tga",
	-- update circle?
	mouse_pt = false,
	-- move camera?
	mouse_down = false,
	-- our green marker
	sphere = false,
	sphere_size = 500 * guic,
	sphere_colour = green,
}

function ChoGGi_XMapControl:OnMouseButtonDown(pt, button)
	if button == "L" then

		if not IsValid(self.sphere) then
			self.sphere = ChoGGi_OSphere:new()
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

function ChoGGi_XMapControl:OnMouseButtonUp(_, button)
	if button == "L" then
		if IsValid(self.sphere) then
			self.sphere:delete()
		end
		self.mouse_down = false
		return "break"
	end
end

function ChoGGi_XMapControl:OnMousePos(pt)
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

	self.sphere:SetPos(pt:SetZ(GetGameMap(self.sphere).terrain:GetSurfaceHeight(pt)))

	-- off we go
	ViewObjectMars(pt)

	return "break"
end

function ChoGGi_XMapControl:OnMouseEnter(...)
	self.mouse_pt = true
	-- workaround to update mouse pos
	self.desktop:SetFocus()
	self:SetFocus()
	return XWindow.OnMouseEnter(self, ...)
end
function ChoGGi_XMapControl:OnMouseLeft(...)
	self.mouse_pt = false
	return XWindow.OnMouseLeft(self, ...)
end

--~ (clip_rect)
function ChoGGi_XMapControl:DrawContent()
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
--~ 	print(slider_pos)
	local slide_x, slide_y = self.slider_size:xy()

	local slider_size = point(ScaleXY(self.scale, slide_x, slide_y))
	local slider_box = sizebox(slider_pos - slider_size / 2, slider_size)
	DrawImageFit(self.slider_image, slider_box, slider_size:x(), slider_size:y(), box(0, 0, slide_x, slide_y), self.slider_color, 0)
end
