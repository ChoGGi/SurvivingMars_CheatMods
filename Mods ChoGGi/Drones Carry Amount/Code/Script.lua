-- See LICENSE for terms

local FuckingDrones = ChoGGi.ComFuncs.FuckingDrones
local SetConstsG = ChoGGi.ComFuncs.SetConstsG
local UpdateDroneResourceUnits = UpdateDroneResourceUnits

function OnMsg.ClassesBuilt()

	local orig_SingleResourceProducer_Produce = SingleResourceProducer.Produce
	function SingleResourceProducer:Produce(...)
		-- get them lazy drones working
		FuckingDrones(self)
		-- be on your way
		return orig_SingleResourceProducer_Produce(self,...)
	end

end

function OnMsg.NewHour()
	local labels = UICity.labels

	-- Hey. Do I preach at you when you're lying stoned in the gutter? No!
	local objs = labels.ResourceProducer or ""
	for i = 1, #objs do
		local obj = objs[i]
		FuckingDrones(obj:GetProducerObj())
		if obj.wasterock_producer then
			FuckingDrones(obj.wasterock_producer)
		end
	end

	objs = labels.BlackCubeStockpiles or ""
	for i = 1, #objs do
		FuckingDrones(objs[i])
	end
end

-- update carry amount
local mod_id = "ChoGGi_DronesCarryAmountFix"
local mod = Mods[mod_id]

local default_drone_amount

local function UpdateAmount(amount)
	SetConstsG("DroneResourceCarryAmount",amount)
	UpdateDroneResourceUnits()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= mod_id then
		return
	end
	-- if enabled then apply option
	if mod.options.UseCarryAmount then
		if g_Consts.DroneResourceCarryAmount ~= mod.options.CarryAmount then
			UpdateAmount(mod.options.CarryAmount)
		end
	elseif default_drone_amount and g_Consts.DroneResourceCarryAmount ~= default_drone_amount then
		UpdateAmount(default_drone_amount)
	end
end

local function StartupCode()
	-- get default
	default_drone_amount = ChoGGi.ComFuncs.GetResearchedTechValue("DroneResourceCarryAmount")

	if mod.options.UseCarryAmount then
		UpdateAmount(mod.options.CarryAmount)
	end
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
