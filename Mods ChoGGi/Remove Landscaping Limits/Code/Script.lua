-- See LICENSE for terms

function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_AdjustLandscapingSize" then
		return
	end

	ChoGGi.ComFuncs.SetLandScapingLimits(CurrentModOptions.RemoveLandScapingLimits)
end
