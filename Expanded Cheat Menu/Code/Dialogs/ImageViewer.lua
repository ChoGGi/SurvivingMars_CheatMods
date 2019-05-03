-- See LICENSE for terms

-- displays images

local MeasureImage = UIL.MeasureImage

local Strings = ChoGGi.Strings
local PopupToggle = ChoGGi.ComFuncs.PopupToggle
local GetParentOfKind = ChoGGi.ComFuncs.GetParentOfKind
local Random = ChoGGi.ComFuncs.Random
local Translate = ChoGGi.ComFuncs.Translate

local function GetRootDialog(dlg)
	return GetParentOfKind(dlg,"ChoGGi_ImageViewerDlg")
end
DefineClass.ChoGGi_ImageViewerDlg = {
	__parents = {"ChoGGi_XWindow"},

	dialog_width = 700.0,
	dialog_height = 700.0,
	-- index list of images
	images = false,
	-- index list of popup menu items
	image_menu_popup = false,
	-- id for togglepopup
	idImageMenu = false,
}

function ChoGGi_ImageViewerDlg:Init(parent, context)
	local g_Classes = g_Classes

	self.images = context.obj
	if type(self.images) ~= "table" then
		self.images = {
			{
				name = self.images,
				path = self.images,
			},
		}
	end

	self.idImageMenu = Random()
	self.title = Strings[302535920001469--[[Image Viewer--]]]
	self.prefix = self.title

	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	self.idButtonContainer = g_Classes.ChoGGi_XDialogSection:new({
		Id = "idButtonContainer",
		Dock = "top",
		-- dark gray
		Background = -13158858,
	}, self.idDialog)

	self:BuildImageMenuPopup()
	self.idImages = g_Classes.ChoGGi_XComboButton:new({
		Id = "idImages",
		Text = Translate(3794--[[Image--]]),
		OnMouseButtonDown = self.idImages_OnMouseButtonDown,
		Dock = "left",
	}, self.idButtonContainer)

	self.idImageSize = g_Classes.ChoGGi_XText:new({
		Id = "idImageSize",
		Dock = "left",
		VAlign = "center",
	}, self.idButtonContainer)

	-- checkered bg
	self.idImageFrame = g_Classes.XFrame:new({
		Id = "idImageFrame",
		TileFrame = true,
		Image = "CommonAssets/UI/checker-pattern-40.tga",
	}, self.idDialog)

	self.idImage = g_Classes.XFrame:new({
		Id = "idImage",
	}, self.idImageFrame)

	-- first up
	local wh = self:SetImageFile(self.images[1])

	-- only one image and it's not a valid image so close dlg
	if wh == 0 and #self.images == 1 then
		print(Strings[302535920000109--[[Invalid Image--]]])
		ChoGGi.ComFuncs.MsgPopup(
			Strings[302535920000109--[[Invalid Image--]]],
			self.title
		)
		self:Close()
	end

	self:PostInit(context.parent)
end

function ChoGGi_ImageViewerDlg:BuildImageMenuPopup()
	local images = {}
	for i = 1, #self.images do
		local image = self.images[i]
		images[i] = {
			name = image.path,
			mouseover = function()
				self:SetImageFile(image)
			end,
		}
	end
	self.image_menu_popup = images
end

function ChoGGi_ImageViewerDlg:SetImageFile(image)
	self = GetRootDialog(self)
	self.idImage:SetImage(image.path)
	self.idCaption:SetTitle(self,image.path)

	local w,h = MeasureImage(image.path)

	if image.name and image.name ~= "" then
		self.idImageSize:SetText(w .. "x" .. h .. " (" .. image.name .. ")")
	else
		self.idImageSize:SetText(w .. "x" .. h)
	end
	return w+h
end

function ChoGGi_ImageViewerDlg:idImages_OnMouseButtonDown()
	local dlg = GetRootDialog(self)
	PopupToggle(self,dlg.idImageMenu,dlg.image_menu_popup,"left")
end
