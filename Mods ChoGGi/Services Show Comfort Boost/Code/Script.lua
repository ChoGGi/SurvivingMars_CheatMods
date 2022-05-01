-- See LICENSE for terms

local table = table
local type = type
local T = T

function StatsChangeBase:GetChoGGi_EffectiveComfortIncrease()
	return self.comfort_increase
end

function OnMsg.ClassesPostprocess()
	local template = PlaceObj("XTemplateTemplate", {
		"Id" , "ChoGGi_Template_ServiceShowComfortIncrease",
		"ChoGGi_Template_ServiceShowComfortIncrease", true,
		"__template", "InfopanelText",
		"Text", table.concat{
			T(731, "Comfort increase on visit"),
			T("<right><Stat(ChoGGi_EffectiveComfortIncrease)>"),
		},
	})

	local xtemplate1 = XTemplates.sectionVisitors[1]
	local xtemplate2 = XTemplates.sectionTrainees[1]

	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate1, "ChoGGi_Template_ServiceShowComfortIncrease", true)
	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate2, "ChoGGi_Template_ServiceShowComfortIncrease", true)

	xtemplate1[#xtemplate1+1] = template
	xtemplate2[#xtemplate2+1] = template
end

-- also add it to build menu
local ChoOrig_GetConstructionDescription = GetConstructionDescription
function GetConstructionDescription(class, ...)
	local ret = ChoOrig_GetConstructionDescription(class, ...)
	if ret ~= "" and class.comfort_increase then
		local tmeta = ret[1]
		for i = tmeta.i, tmeta.j do
			-- 3963 == "Service Comfort: <Stat(comfort)>"
			if type(tmeta.table[i]) == "table" and tmeta.table[i][1] == 3963 then
				tmeta.j = tmeta.j + 1
				tmeta.table[tmeta.j] = table.concat{
					T(731, "Comfort increase on visit"),
					T{": <Stat(comfort)>",
						comfort = class.comfort_increase or 0,
					},
				}
				break
			end
		end
	end
	return ret
end
