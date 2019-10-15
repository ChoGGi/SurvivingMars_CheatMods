
function OnMsg.LoadGame()
	if CurrentModOptions:GetProperty("EnableMod") then
		ChoGGi.ComFuncs.DisastersStop()
	end
end
