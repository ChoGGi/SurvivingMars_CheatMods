-- See LICENSE for terms

local options
local mod_ColdCapacity

-- fired when settings are changed/init
local function ModOptions()
	-- updated during building update
	mod_ColdCapacity = options.ColdCapacity
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

local function RemoveMod(name, obj)
	local cbrl = obj[name]
	if cbrl then
		cbrl:Remove()
		DoneObject(cbrl)
		obj[name] = nil
	end
end
local function RemoveMods(obj)
	RemoveMod("ChoGGi_ColdBatteryRateLimitCharge", obj)
	RemoveMod("ChoGGi_ColdBatteryRateLimitDischarge", obj)
	RemoveMod("ChoGGi_ColdBatteryRateLimitCap", obj)
end

local function AddMod(name, prop, obj)
	obj[name] = ObjectModifier:new({
		target = obj,
		prop = prop,
		percent = -25,
	})
end

local function AddMods(obj)
	RemoveMods(obj)

	AddMod("ChoGGi_ColdBatteryRateLimitCharge", "max_electricity_charge", obj)
	AddMod("ChoGGi_ColdBatteryRateLimitDischarge", "max_electricity_discharge", obj)
	if mod_ColdCapacity then
		AddMod("ChoGGi_ColdBatteryRateLimitCap", "capacity", obj)
	end
end

-- battery placed during wave
function OnMsg.BuildingInit(obj)
	if obj:IsKindOf("ElectricityStorage") and obj:IsFreezing() then
		AddMods(obj)
	end
end

-- add ColdSensitive stuff to batteries
function OnMsg.ClassesPreprocess()
	local es = ElectricityStorage
	if table.find(es.__parents, "ColdSensitive") then
		return
	end

	es.__parents[#es.__parents+1] = "ColdSensitive"

	es.___BuildingUpdate[#es.___BuildingUpdate+1] = ElectricityStorage.UpdateFrozen
	es.freeze_progress = 0
	-- dbl water tanks
	es.freeze_time = 999 * 2
	es.defrost_time = 999
end

function ElectricityStorage:UpdateFrozen()

	local is_good = not self.destroyed and self:IsFreezing()
	-- ui update
	self.freeze_progress = is_good and self.freeze_time or 0

	-- add/remove mods
	if is_good then
		-- no need to add if already added
		if not self.ChoGGi_ColdBatteryRateLimitCharge then
			AddMods(self)
		end
	else
		-- no need to remove if already removed
		if self.ChoGGi_ColdBatteryRateLimitCharge then
			RemoveMods(self)
		end
	end

	-- if user changed mod options
	local name = "ChoGGi_ColdBatteryRateLimitCap"
	if mod_ColdCapacity and is_good and not self[name] then
		AddMod(name, "capacity", self)
	elseif not mod_ColdCapacity and self[name] then
		RemoveMod(name, self)
	end

end
