function OnMsg.ModConfigReady()
	local ModConfig = ModConfig
	local MarkDepositGround = MarkDepositGround

	-- setup menu options
	ModConfig:RegisterMod("MarkDepositGround", "Mark Deposit Ground")

	ModConfig:RegisterOption("MarkDepositGround", "HideSigns", {
		name = "Hide signs",
		type = "boolean",
		default = MarkDepositGround.HideSigns,
	})
	ModConfig:RegisterOption("MarkDepositGround", "AlienAnomaly", {
		name = "Alien anomaly signs",
		type = "boolean",
		default = MarkDepositGround.AlienAnomaly,
	})
	ModConfig:RegisterOption("MarkDepositGround", "VistaAnomaly", {
		name = "Vista/Research anomaly signs",
		type = "boolean",
		default = MarkDepositGround.VistaAnomaly,
	})

	-- get saved options
	MarkDepositGround.HideSigns = ModConfig:Get("MarkDepositGround", "HideSigns")
	MarkDepositGround.AlienAnomaly = ModConfig:Get("MarkDepositGround", "AlienAnomaly")
	MarkDepositGround.VistaAnomaly = ModConfig:Get("MarkDepositGround", "VistaAnomaly")

end

local AsyncRand = AsyncRand
local g_Classes = g_Classes


local function ChangeMarks(label,entity,value)
	local anomalies = UICity.labels[label] or ""
	if value then
		for i = 1, #anomalies do
			local a = anomalies[i]
			if not a.ChoGGi_alien then
				a.ChoGGi_alien = a.entity
				a:ChangeEntity(entity)
				a:SetScale(500)
				a:SetAngle(AsyncRand())
			end
		end
	else
		for i = 1, #anomalies do
			local a = anomalies[i]
			a:ChangeEntity(a.ChoGGi_alien or g_Classes[a.class].entity)
			a.ChoGGi_alien = nil
			a:SetScale(100)
			a:SetAngle(0)
		end
	end
end

local function UpdateOpacity(label,value)
	value = value and 0 or 100
	local deposits = UICity.labels[label] or ""
	for i = 1, #deposits do
		deposits[i]:SetOpacity(value)
	end
end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
	if mod_id == "MarkDepositGround" then
		local MarkDepositGround = MarkDepositGround

		if option_id == "AlienAnomaly" then
			MarkDepositGround.AlienAnomaly = value
			ChangeMarks("Anomaly","GreenMan",value)

		elseif option_id == "VistaAnomaly" then
			MarkDepositGround.VistaAnomaly = value
			ChangeMarks("EffectDeposit","GreenMan",value)

		elseif option_id == "HideSigns" then
			MarkDepositGround.HideSigns = value
			-- update signs
			if UICity then
				UpdateOpacity("SubsurfaceDeposit",value)
				UpdateOpacity("EffectDeposit",value)
				UpdateOpacity("TerrainDeposit",value)
			end
		end

	end -- if ME!@!$#*&^!@#

end
