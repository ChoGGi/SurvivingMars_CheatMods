function OnMsg.LoadGame()
	local o = BuildMenuPrerequisiteOverrides

	if o.WindTurbine and TGetID(o.WindTurbine) == 401896326435 --[[You can't construct this building at this time--]] then
		o.WindTurbine = nil
	end
end

