-- See LICENSE for terms

if not g_AvailableDlc.shepard then
	return
end

local time_str = {"<time(time)>"}

function Pasture:GetChoGGi_HarvestTimeRemaining()
  if not self.current_herd then
    return 0
  end

	local ticks = self.current_herd_lifetime
	local hours = ticks / const.HourDuration
	-- if over two hours then use <time> (anything under 48 hours == 0 Sols with <time)>
	if hours > 48 then
		time_str.time = ticks
		return T(time_str)
	end
	return hours .. " " .. T(3778, "Hours")
end

function OnMsg.ClassesPostprocess()
	local xtemplate = XTemplates.sectionPasture[1]
	if xtemplate.ChoGGi_AddedRemaining then
		return
	end
	xtemplate.ChoGGi_AddedRemaining = true
	local idx = table.find(xtemplate, "Image", "UI/CommonNew/ip_header.tga")
	if not idx then
		return
	end
	xtemplate = xtemplate[idx]
	xtemplate[#xtemplate+1] = PlaceObj("XTemplateTemplate", {
		"__template", "InfopanelText",
		"Margins", box(52, 0, 20, 0),
		"Text", T(12014, "Remaining Time")
			.. T("<right><ChoGGi_HarvestTimeRemaining>"),
	})

end
