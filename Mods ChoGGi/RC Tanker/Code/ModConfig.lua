function OnMsg.ModConfigReady()
	local ModConfig = ModConfig
	local RCTankerMCR = RCTankerMCR

	-- setup menu options
	ModConfig:RegisterMod("RCTankerMCR", [[RC Tanker]])

	ModConfig:RegisterOption("RCTankerMCR", "LimitStorage", {
		name = [[Limit Tank Storage]],
		desc = [[How many resource units it can hold.]],
		type = "number",
		min = 0,
		step = 25,
		default = RCTankerMCR.LimitStorage,
	})

	-- get saved options
	RCTankerMCR.LimitStorage = ModConfig:Get("RCTankerMCR", "LimitStorage")

end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
	if mod_id == "RCTankerMCR" then
		if option_id == "LimitStorage" then
			RCTankerMCR.LimitStorage = value
		end
	end
end
