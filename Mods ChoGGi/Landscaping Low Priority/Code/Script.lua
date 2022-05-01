-- See LICENSE for terms

function OnMsg.ConstructionSitePlaced(site)
	local t = site.building_class_proto
	if t and t.build_category == "Landscaping" then
		site:SetPriority(1)
	end
end

-- "Somebody" missed a Msg...
local ChoOrig_GameInit = LandscapeConstructionSiteBase.GameInit
function LandscapeConstructionSiteBase:GameInit(...)
	self:SetPriority(1)
	return ChoOrig_GameInit(self, ...)
end
