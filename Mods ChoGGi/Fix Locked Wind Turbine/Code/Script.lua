function OnMsg.LoadGame()
	local overrides = BuildMenuPrerequisiteOverrides
	if TGetID(overrides.WindTurbine) == 401896326435 --[[You can't construct this building at this time--]] then
		overrides.WindTurbine = nil
	end
end

