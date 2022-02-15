-- See LICENSE for terms

function OnMsg.LoadGame()
	if not CurrentModOptions:GetProperty("EnableMod") then
		return
	end

	local bmpo = BuildMenuPrerequisiteOverrides

	if bmpo.WindTurbine and TGetID(bmpo.WindTurbine) == 401896326435--[[You can't construct this building at this time]] then
		bmpo.WindTurbine = nil
	end
end

