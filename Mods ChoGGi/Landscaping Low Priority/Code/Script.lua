-- See LICENSE for terms

function OnMsg.ConstructionSitePlaced(site)
	local t = site.building_class_proto
	if t and t.build_category == "Landscaping" then
		site:SetPriority(1)
	end
end

-- "Somebody" missed a Msg...
local orig_GameInit = LandscapeConstructionSiteBase.GameInit
function LandscapeConstructionSiteBase:GameInit(...)
	self:SetPriority(1)
	return orig_GameInit(self, ...)
end
