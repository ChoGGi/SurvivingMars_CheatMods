-- See LICENSE for terms

local IsKindOf = IsKindOf
local Sleep = Sleep
local SetUnitControlInteractionMode = SetUnitControlInteractionMode
local SetUnitControlInteraction = SetUnitControlInteraction
local FindNearestObject = FindNearestObject

-- add stuff to rovers so they can interact with garage

-- status updates
local rcc = RoverCommands
rcc.ChoGGi_UseGarage = T(302535920011181, [[Storing in garage]])
rcc.ChoGGi_InGarage = T(302535920011182, [[Stored in garage]])

local BaseRover = BaseRover

-- if it's garage otherwise return orig func
--~ (interact, obj, interaction_mode)
local function CanInteractWithObject_local(interact, obj)
	local garage = g_ChoGGi_RCGarages
	if (interact == false or interact == "default" or interact == "move")
			and garage.main and garage.main.working
			and IsKindOf(obj, "RCGarage") and obj:CheckMainGarage()
	then
		return true, T(302535920011183, [[<UnitMoveControl('ButtonA', interaction_mode)>: Use Garage]])
	end
end

local orig_BaseRover_CanInteractWithObject = BaseRover.CanInteractWithObject
function BaseRover:CanInteractWithObject(obj, interaction_mode, ...)
	local ret1, ret2 = CanInteractWithObject_local(self.interaction_mode, obj, interaction_mode)
	if ret1 then
		return ret1, ret2
	end

	return orig_BaseRover_CanInteractWithObject(self, obj, interaction_mode, ...)
end

local orig_BaseRover_InteractWithObject = BaseRover.InteractWithObject
function BaseRover:InteractWithObject(obj, interaction_mode, ...)
	local garage = g_ChoGGi_RCGarages
	if (self.interaction_mode == false or self.interaction_mode == "default" or self.interaction_mode == "move")
			and garage.main and garage.main.working
			and IsKindOf(obj, "RCGarage") and obj:CheckMainGarage()
	then
		self:SetCommand("ChoGGi_UseGarage", obj)
		SetUnitControlInteractionMode(self, false) --toggle button
	end

	return orig_BaseRover_InteractWithObject(self, obj, interaction_mode, ...)
end

-- there isn't a BaseRover:GotoFromUser, or use Unit as fallback (just in case it gets added)
local orig_BaseRover_GotoFromUser = BaseRover.GotoFromUser or Unit.GotoFromUser
function BaseRover:GotoFromUser(...)
	-- block rover from goto when in garage
	if self.ChoGGi_InGarage then
		return
	end
	return orig_BaseRover_GotoFromUser(self, ...)
end
-- maybe add SetCommand

-- block RCRover from dropping the poor little drones in the void
local orig_RCRover_Siege = RCRover.Siege
function RCRover:Siege(...)
	if self.ChoGGi_InGarage then
		Sleep(5000)
	else
		return orig_RCRover_Siege(self, ...)
	end
end

-- fix for any rovers stuck on the map from missing rover story
local function RestoreMissingRover(obj)
	local nearest = FindNearestObject(UICity.labels.RCGarage, obj)
	obj:SetPos(nearest:GetPos())
	nearest:RemoveFromGarage(obj)
end

local InvalidPos = InvalidPos()
function OnMsg.LoadGame()
	local rovers = MapGet("map", "BaseRover")
	for i = 1, #rovers do
		local r = rovers[i]
		if r.ChoGGi_InGarage and r:GetPos() ~= InvalidPos then
			RestoreMissingRover(r)
		end
	end
end
local orig_BaseRover_Appear = BaseRover.Appear or Unit.Appear
function BaseRover:Appear(...)
	if self.ChoGGi_InGarage then
		RestoreMissingRover(self)
	end
	return orig_BaseRover_Appear(self, ...)
end

function BaseRover:ChoGGi_UseGarage(garage)
	-- maybe not needed?
	self:ExitHolder(garage)

	-- pack away the drones
	if self:IsKindOf("RCRover") and self.sieged_state then
		-- if drones already being sent in
		self:Unsiege()
		self.siege_state_name = "UnSiege"
		self.sieged_state = false
	end

	local pos = select(2, garage:GetEntrance(self, "tunnel_entrance"))
	if not pos or not self:Goto_NoDestlock(pos) or not IsValid(garage) then
		return
	end

	SetUnitControlInteraction(false, self)
	garage:StickInGarage(self)
end

-- override for Patriot missile sys
function OnMsg.ClassesBuilt()

	if rawget(g_Classes, "PMSAttackRover") then
		local orig_PMSAttackRover_CanInteractWithObject = PMSAttackRover.CanInteractWithObject
		function PMSAttackRover:CanInteractWithObject(obj, interaction_mode, ...)
			local ret1, ret2 = CanInteractWithObject_local(self, obj, interaction_mode)
			if ret1 then
				return ret1, ret2
			end
			return orig_PMSAttackRover_CanInteractWithObject(self, obj, interaction_mode, ...)
		end
	end

	if rawget(g_Classes, "NASAAttackRover") then
		local orig_NASAAttackRover_CanInteractWithObject = NASAAttackRover.CanInteractWithObject
		function NASAAttackRover:CanInteractWithObject(obj, interaction_mode, ...)
			local ret1, ret2 = CanInteractWithObject_local(self, obj, interaction_mode)
			if ret1 then
				return ret1, ret2
			end
			return orig_NASAAttackRover_CanInteractWithObject(self, obj, interaction_mode, ...)
		end
	end

end
