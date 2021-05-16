-- See LICENSE for terms

local IsKindOf = IsKindOf
local IsGameRuleActive = IsGameRuleActive

 -- library 10.0
local OneBuildingExists = ChoGGi.ComFuncs.OneBuildingExists or function(template_id)
  local building_exists
	if 0 < #(UICity.labels[template_id] or "") then
		return true
	else
		local sites = UICity.labels.ConstructionSite or ""
		for i = 1, #sites do
			local site = sites[i]
			if site.building_class_proto.template_name == template_id then
				return true
			end
		end
		if not building_exists then
			local sites = UICity.labels.ConstructionSiteWithHeightSurfaces or ""
			for i = 1, #sites do
				local site = sites[i]
				if site.building_class_proto.template_name == template_id then
					return true
				end
			end
		end
	end
end
-- library 10.0

function OnMsg.GetAdditionalBuildingLocks(template, locks)
	if IsGameRuleActive("ChoGGi_OneMOXIE") and OneBuildingExists("MOXIE") then
		local classdef = g_Classes[template.template_class]
		if IsKindOf(classdef, "MOXIE") then
			locks.BuildOnlyOnce = true
		end
	end
end

function OnMsg.ClassesPostprocess()
	if GameRulesMap.ChoGGi_OneMOXIE then
		return
	end

	PlaceObj("GameRules", {
		description = T(302535920011954, "You can only build one MOXIE."),
		flavor = T(302535920011955, [[<grey>"Tell me Jim, what did you see when the psychologist held up that blank sheet of paper?"
<right>Clayton Stone</grey><left>]]),
		display_name = T(302535920011956, "One MOXIE"),
		challenge_mod = 100,
		group = "Default",
		id = "ChoGGi_OneMOXIE",
	})
end
