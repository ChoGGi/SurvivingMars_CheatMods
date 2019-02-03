-- See LICENSE for terms

-- displays images

--~ local StringFormat = string.format
local MeasureImage = UIL.MeasureImage

local S
local GetParentOfKind
local PopupToggle
local Random

function OnMsg.ClassesGenerate()
	S = ChoGGi.Strings
	PopupToggle = ChoGGi.ComFuncs.PopupToggle
	GetParentOfKind = ChoGGi.ComFuncs.GetParentOfKind
	Random = ChoGGi.ComFuncs.Random
end

local function GetRootDialog(dlg)
	return GetParentOfKind(dlg,"ChoGGi_ImageViewerDlg")
end
DefineClass.ChoGGi_ImageViewerDlg = {
	__parents = {"ChoGGi_Window"},

	dialog_width = 700.0,
	dialog_height = 700.0,
	title = 302535920001469--[[Image Viewer--]],
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
	if type(self.images) == "string" then
		self.images = {self.images}
	end

	self.idImageMenu = Random()
	self.prefix = S[302535920001469--[[Image Viewer--]]]

	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	self.idButtonContainer = g_Classes.ChoGGi_DialogSection:new({
		Id = "idButtonContainer",
		Dock = "top",
		-- dark gray
		Background = -13158858,
	}, self.idDialog)

	self:BuildImageMenuPopup()
	self.idImages = g_Classes.ChoGGi_ComboButton:new({
		Id = "idImages",
		Text = S[3794--[[Image--]]],
		OnMouseButtonDown = self.idImagesOnMouseButtonDown,
		Dock = "left",
	}, self.idButtonContainer)

	self.idImageSize = g_Classes.ChoGGi_Text:new({
		Id = "idImageSize",
		Dock = "left",
		VAlign = "center",
	}, self.idButtonContainer)

	self.idImage = g_Classes.XFrame:new({
		Id = "idImage",
	}, self.idDialog)

	-- invis background
	self.idDialog:SetBackground(0)

	-- first up
	self:SetImageFile(self.images[1])

	self:PostInit(context.parent)
end

local image_str = "%sx%s"
function ChoGGi_ImageViewerDlg:BuildImageMenuPopup()
	local images = {}
	local c = 0
	for i = 1, #self.images do
		local image_name = self.images[i]
		c = c + 1
		local w,h = MeasureImage(image_name)
		local width_height = image_str:format(w,h)
		images[c] = {
			name = image_name,
			mouseover = function()
				self:SetImageFile(image_name,width_height)
			end,
		}
	end
	self.image_menu_popup = images
end

function ChoGGi_ImageViewerDlg:SetImageFile(image,width_height)
	self = GetRootDialog(self)
	self.idImage:SetImage(image)
	self.idCaption:SetTitle(self,image)

	if not width_height then
		local w,h = MeasureImage(image)
		width_height = image_str:format(w,h)
	end
	self.idImageSize:SetText(width_height)
end

function ChoGGi_ImageViewerDlg:idImagesOnMouseButtonDown()
	local dlg = GetRootDialog(self)
	PopupToggle(self,dlg.idImageMenu,dlg.image_menu_popup,"left")
end
