-- See LICENSE for terms

local options
local mod_ShowConstruct

-- fired when settings are changed/init
local function ModOptions()
	mod_ShowConstruct = options.ShowConstruct
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

local white = white
local GridSpacing = const.GridSpacing
local HexSize = const.HexSize
local ShowHexRanges = ShowHexRanges

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
		-- if ecm is active we check for custom range, otherwise use default
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

-- since the circle gets attached to the CursorBuilding it'll be removed when it's removed, no need to fiddle with :Close()
