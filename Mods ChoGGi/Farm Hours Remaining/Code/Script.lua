-- See LICENSE for terms

local time_str = {12265, "Remaining Time<right><time(time)>"}

local shep = g_AvailableDlc.shepard
if shep then
	function Pasture:GetChoGGi_HarvestTimeRemaining()
		time_str.time = self.current_herd_lifetime or 0
		return T(time_str)
	end
end

function Farm:GetChoGGi_HarvestTimeRemaining()
	local grown, duration = self:GetGrowthTimes()
	time_str.time = duration - grown
	return T(time_str)
end

function OnMsg.ClassesPostprocess()

	local xtemplate = XTemplates.sectionCrop[1]
	if not xtemplate.ChoGGi_FarmTimeRemaining then
		xtemplate.ChoGGi_FarmTimeRemaining = true
		local idx = table.find(xtemplate, "Image", "UI/CommonNew/ip_header.tga")
		if idx then
			xtemplate = xtemplate[idx]
			xtemplate[#xtemplate+1] = PlaceObj("XTemplateTemplate", {
				"__template", "InfopanelText",
				"Margins", box(52, 0, 20, 0),
				"Text", T("<ChoGGi_HarvestTimeRemaining>"),
			})
		end
	end

	if shep then
		xtemplate = XTemplates.sectionPasture[1]
		if not xtemplate.ChoGGi_AddedRemaining then
			xtemplate.ChoGGi_AddedRemaining = true
			local idx = table.find(xtemplate, "Image", "UI/CommonNew/ip_header.tga")
			if idx then
				xtemplate = xtemplate[idx]
				xtemplate[#xtemplate+1] = PlaceObj("XTemplateTemplate", {
					"__template", "InfopanelText",
					"Margins", box(52, 0, 20, 0),
					"Text", T("<ChoGGi_HarvestTimeRemaining>"),
				})
			end
		end
	end

end
