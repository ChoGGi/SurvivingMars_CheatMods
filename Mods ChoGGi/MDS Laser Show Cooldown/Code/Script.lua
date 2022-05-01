-- See LICENSE for terms

local function RetTime(self)
	local time = self:GetCooldownLeft()
	if time == 0 then
		return T(6722, "Idle")
	else
		-- no "Minutes" string so decimal to the rescue
		time = (time / const.MinuteDuration + 0.0) / 100
	end
	return time .. " " .. T(3778, "Hours")
end

function OnMsg.ClassesPostprocess()

	local xtemplate = XTemplates.ipBuilding[1][1]
	if not table.find(xtemplate, "Id", "ChoGGi_sectionMDSLaserStatus") then
		table.insert(xtemplate, 1, PlaceObj("XTemplateTemplate", {
			"__template", "ChoGGi_sectionMDSLaserStatus",
			"Id", "ChoGGi_sectionMDSLaserStatus",
		}))
	end

	if XTemplates.ChoGGi_sectionMDSLaserStatus then
		return
	end

	PlaceObj("XTemplate", {
		group = "Infopanel Sections",
		id = "ChoGGi_sectionMDSLaserStatus",
		PlaceObj("XTemplateGroup", {
			"__context_of_kind", "MDSLaser",
		}, {
			PlaceObj("XTemplateTemplate", {
				"__template", "InfopanelSection",
				"Title", T(49, "Status"),
			}, {
				PlaceObj("XTemplateTemplate", {
					"__template", "InfopanelText",
					"Text", T{"<str>: <time>",
						str = T(6750, "Reload Time"), time = RetTime,
					},
				}),
			}),
		}),
	})

end
