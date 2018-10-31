PatientTransportRoute = {
	Amount = 1,
}

function OnMsg.ModConfigReady()
	local ModConfig = ModConfig
	local PatientTransportRoute = PatientTransportRoute

	-- setup menu options
	ModConfig:RegisterMod("PatientTransportRoute", "Patient Transport Route")

	ModConfig:RegisterOption("PatientTransportRoute", "Amount", {
		name = "Amount to wait before delivery",
		type = "number",
		min = 1,
		max = 45,
		step = 1,
		default = PatientTransportRoute.Amount,
	})

	-- get saved options
	PatientTransportRoute.Amount = ModConfig:Get("PatientTransportRoute", "Amount")

end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
	if mod_id == "PatientTransportRoute" and option_id == "Amount" then
		PatientTransportRoute.Amount = value
	end
end
