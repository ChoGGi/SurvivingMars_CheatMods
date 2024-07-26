-- See LICENSE for terms

function OnMsg.LoadGame()
	if CurrentModOptions:GetProperty("EnableMod") then
		ChoGGi_Funcs.Common.DisastersStop()
	end
end
