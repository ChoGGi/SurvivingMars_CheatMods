-- See LICENSE for terms

local white = -1
local GridSpacing = const.GridSpacing
local HexSize = const.HexSize
local ShowHexRanges = ShowHexRanges

local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding:GameInit()
	if not ChoGGi_ShowMaxRadiusRange.Option1 then
		return orig_CursorBuilding_GameInit(self)
	end
	if self.template:IsKindOfClasses("TriboelectricScrubber","SubsurfaceHeater") then

		-- if ecm is active we check for custom range, otherwise use default
		local uirange
		local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
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

		if self.template:IsKindOf("SubsurfaceHeater") then
			local circle = Circle:new()

			circle:SetRadius((uirange * GridSpacing) + HexSize)
			circle:SetColor(white)
			self:Attach(circle)
		end

	elseif self.template:IsKindOf("MoholeMine") then
		local circle = Circle:new()

		circle:SetRadius(MoholeMine.GetHeatRange(self.template))
		circle:SetColor(white)
		self:Attach(circle)

	elseif self.template:IsKindOf("ArtificialSun") then
		local circle = Circle:new()

		circle:SetRadius(ArtificialSun.GetHeatRange(self.template))
		circle:SetColor(white)
		self:Attach(circle)

	end

--~ 	ex(self)
	return orig_CursorBuilding_GameInit(self)
end

-- since the circle gets attached to the CursorBuilding it'll be removed when it's removed, no need to fiddle with :Done()
