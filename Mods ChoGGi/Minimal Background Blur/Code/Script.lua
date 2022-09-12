-- See LICENSE for terms

function OnMsg.ClassesPostprocess()

	local xtemplate = XTemplates.ScreenBlur[1]
	if xtemplate.ChoGGi_MinimalBackgroundBlur_updatedfunc then
		return
	end

	local idx = table.find(xtemplate, "name", "Open")
	if not idx then
		return
	end

	local template_func = xtemplate[idx]

	local ChoOrig_MinimalBackgroundBlur_Open = template_func.func
	template_func.func = function(...)
		ChoOrig_MinimalBackgroundBlur_Open(...)
		if not CurrentModOptions:GetProperty("EnableMod") then
			return
		end

		-- Normally called when the "Close" func is called
		table.restore(hr, "BackgroundBlur")
	end

	-- keep it from updating each lua reload
	xtemplate.ChoGGi_MinimalBackgroundBlur_updatedfunc = true
	--
end
