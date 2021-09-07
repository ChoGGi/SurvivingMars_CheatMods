-- See LICENSE for terms

ChoGGi.ComFuncs.AddParentToClass(DontBuildHere, "SelectableWithParticles")
ChoGGi.ComFuncs.AddParentToClass(DontBuildHere, "InfopanelObj")
DontBuildHere.ip_template = "ipChoGGi_DustGeyserInfo"
DontBuildHere.DisplayName = T(302535920011957, "Dust Geyser")

function DontBuildHere:GetIPDescription()
	return T(302535920011958, [[Martian dust geysers spray dust...

Circle is radius of potential dust.

Time between dust and time it lasts (random each time, these are min/max):]])
		.. PrefabFeatureChar_Geyser:GetDescription(self):sub(7)
end

-- prevent an error msg in log
DontBuildHere.BuildWaypointChains = empty_func

function OnMsg.ClassesPostprocess()
	-- added to stuff spawned with object spawner
	if XTemplates.ipChoGGi_DustGeyserInfo then
		XTemplates.ipChoGGi_DustGeyserInfo:delete()
	end

	PlaceObj("XTemplate", {
		group = "Infopanel Sections",
		id = "ipChoGGi_DustGeyserInfo",
		PlaceObj("XTemplateTemplate", {
			"__context_of_kind", "DontBuildHere",
			"__template", "Infopanel",
		}, {
			PlaceObj("XTemplateTemplate", {
				"__template", "sectionCheats",
			}),
		}),
	})
end

local sort_obj
local function SortByDist(a, b)
	return a:GetDist2D(sort_obj) < b:GetDist2D(sort_obj)
end

function DontBuildHere:OnSelected()
	local geysers = {}
	ActiveGameMap.realm:MapGet("map", "GeyserWarmup", function(warmup)
		local geyser = warmup:GetMarker()
		if not geysers[geyser] then
			geysers[#geysers+1] = geyser
			geysers[geyser] = true
		end
	end)

	local geyser_count = #geysers
	if geyser_count == 0 then
		return
	end

	-- DontBuildHere is off-map, so cursor it is
	sort_obj = GetCursorWorldPos()
	table.sort(geysers, SortByDist)

	local geyser = geysers[1]
	ChoGGi.ComFuncs.Circle(geyser:GetPos(), geyser.FeatureRadius, white, 10000)
end
