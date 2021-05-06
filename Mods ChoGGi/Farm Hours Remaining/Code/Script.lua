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

local function AddTimeRemaining(xtemplate)
	if xtemplate.ChoGGi_AddedFarmTimeRemaining then
		return
	end
	xtemplate.ChoGGi_AddedFarmTimeRemaining = true

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

function OnMsg.ClassesPostprocess()
	AddTimeRemaining(XTemplates.sectionCrop[1])
	if shep then
		AddTimeRemaining(XTemplates.sectionPasture[1])
	end
end
