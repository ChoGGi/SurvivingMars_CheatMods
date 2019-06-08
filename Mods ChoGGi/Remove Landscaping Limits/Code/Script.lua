-- See LICENSE for terms

function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_RemoveLandscapingLimits" then
		return
	end

	ChoGGi.ComFuncs.SetLandScapingLimits(CurrentModOptions.RemoveLandScapingLimits)
end
