function OnMsg.ModConfigReady()
	local ModConfig = ModConfig
	local MarkDepositGround = MarkDepositGround

	-- setup menu options
	ModConfig:RegisterMod("MarkDepositGround", "Mark Deposit Ground")

	ModConfig:RegisterOption("MarkDepositGround", "HideSigns", {
		name = [[Hide signs]],
		desc = [[Hide signs on the map (pressing I will not toggle them).]],
		type = "boolean",
		default = MarkDepositGround.HideSigns,
	})
	ModConfig:RegisterOption("MarkDepositGround", "AlienAnomaly", {
		name = [[Alien Signs]],
		desc = [[Change anomaly signs to aliens.]],
		type = "boolean",
		default = MarkDepositGround.AlienAnomaly,
	})
	ModConfig:RegisterOption("MarkDepositGround", "ShowConstruct", {
		name = [[Construction Signs]],
		desc = [[Signs are visible during construction.]],
		type = "boolean",
		default = MarkDepositGround.ShowConstruct,
	})

	-- get saved options
	MarkDepositGround.HideSigns = ModConfig:Get("MarkDepositGround", "HideSigns")
	MarkDepositGround.AlienAnomaly = ModConfig:Get("MarkDepositGround", "AlienAnomaly")
	MarkDepositGround.ShowConstruct = ModConfig:Get("MarkDepositGround", "ShowConstruct")

end

local function ChangeMarks(label,entity,value)
	local anomalies = UICity.labels[label] or ""
	if value then
		local AsyncRand = AsyncRand
		for i = 1, #anomalies do
			local a = anomalies[i]
			if not a.ChoGGi_alien then
				a.ChoGGi_alien = a:GetEntity()
				a:ChangeEntity(entity)
				a:SetScale(500)
				a:SetAngle(AsyncRand())
			end
		end
	else
		local g_Classes = g_Classes
		for i = 1, #anomalies do
			local a = anomalies[i]
			a:ChangeEntity(a.ChoGGi_alien or g_Classes[a.class]:GetEntity())
			a.ChoGGi_alien = nil
			a:SetScale(100)
			a:SetAngle(0)
		end
	end
end


function OnMsg.ModConfigChanged(mod_id, option_id, value)
	if mod_id == "MarkDepositGround" then
		local MarkDepositGround = MarkDepositGround

		if option_id == "AlienAnomaly" then
			MarkDepositGround.AlienAnomaly = value
			ChangeMarks("Anomaly","GreenMan",value)

		elseif option_id == "HideSigns" then
			MarkDepositGround.HideSigns = value
			-- update signs
			if GameState.gameplay then
				MarkDepositGround.UpdateOpacity("SubsurfaceDeposit",value)
				MarkDepositGround.UpdateOpacity("EffectDeposit",value)
				MarkDepositGround.UpdateOpacity("TerrainDeposit",value)
			end

		elseif option_id == "ShowConstruct" then
			MarkDepositGround.ShowConstruct = value

		end

	end -- if ME!@!$#*&^!@#
end
