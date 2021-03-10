-- See LICENSE for terms

local mod_ShowConstruct
local mod_SetMaxRadius

-- fired when settings are changed/init
local function ModOptions()
	mod_ShowConstruct = CurrentModOptions:GetProperty("ShowConstruct")
	mod_SetMaxRadius = CurrentModOptions:GetProperty("SetMaxRadius")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

local white = white
local GridSpacing = const.GridSpacing
local HexSize = const.HexSize
local ShowHexRanges = ShowHexRanges
local table = table

local function AddRadius(self, radius)
	local circle = Circle:new()
	circle:SetRadius(radius)
	circle:SetColor(white)
	self:Attach(circle)
end

local cls_saved_settings = {"TriboelectricScrubber", "SubsurfaceHeater", "CoreHeatConvector", "ForestationPlant"}
local cls_heaters = {"SubsurfaceHeater", "CoreHeatConvector"}

local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding:GameInit(...)
	if not mod_ShowConstruct then
		return orig_CursorBuilding_GameInit(self, ...)
	end

	if self.template and self.template:IsKindOfClasses(cls_saved_settings) then
		-- If ecm is active we check for custom range, otherwise use default
		local uirange
		local idx = table.find(ModsLoaded, "id", "ChoGGi_Library")
		if idx then
			local bs = ChoGGi.UserSettings.BuildingSettings[self.template.template_name]
			if bs and bs.uirange then
				uirange = bs.uirange
			end
		end
		uirange = uirange or self.template:GetPropertyMetadata("UIRange").max

		-- update with max size
		self.GetSelectionRadiusScale = uirange
		-- and call this again to update grid marker
		ShowHexRanges(UICity, false, self, "GetSelectionRadiusScale")

		if self.template:IsKindOfClasses(cls_heaters) then
			AddRadius(self, (uirange * GridSpacing) + HexSize)
		end

	else
		-- see if the cls obj has a GetHeatRange func
		local cls = self.template
		if cls.template_name and cls.template_name ~= "" then
			cls = cls.template_name
		elseif cls.template_class and cls.template_class ~= "" then
			cls = cls.template_class
		end
		cls = g_Classes[cls]

		if cls and cls.GetHeatRange then
			AddRadius(self, cls.GetHeatRange(self.template))
		end
	end

--~ 	ex(self)
	return orig_CursorBuilding_GameInit(self, ...)
end

-- since the circle gets attached to the CursorBuilding it'll be removed when it's removed, no need to fiddle with :Done()


-- set max radius
function OnMsg.BuildingInit(obj)
--~ 	if not mod_SetMaxRadius or not obj:IsKindOfClasses(cls_saved_settings) then
--~ 		return
--~ 	end
	if not mod_SetMaxRadius then
		return
	end

	-- If ECM is active we check for custom range, otherwise use default
	local uirange
	local idx = table.find(ModsLoaded, "id", "ChoGGi_Library")
	if idx then
		local bs = ChoGGi.UserSettings.BuildingSettings[obj.template_name]
		if bs and bs.uirange then
			uirange = bs.uirange
		end
	end
	-- don't call func if we have a range from ECM
	local prop = not uirange and obj:GetPropertyMetadata("UIRange")
	uirange = uirange or prop and prop.max

	-- set it
	obj.UIRange = uirange
end
