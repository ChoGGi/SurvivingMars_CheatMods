-- See LICENSE for terms

local IsKindOf = IsKindOf
local Sleep = Sleep
local SetUnitControlInteractionMode = SetUnitControlInteractionMode
local SetUnitControlInteraction = SetUnitControlInteraction

-- add stuff to rovers so they can interact with garage

-- status updates
local rcc = RoverCommands
rcc.ChoGGi_UseGarage = [[Storing in garage]]
rcc.ChoGGi_InGarage = [[Stored in garage]]

local function CanInteractWithObject_local(self, obj, interaction_mode)
	-- if it's garage otherwise return orig func
	if (self.interaction_mode == false or self.interaction_mode == "default" or self.interaction_mode == "move") and IsKindOf(obj, "RCGarage") and obj:CheckMainGarage() and obj.garages.main.working then
		return true, T{0, [[<UnitMoveControl('ButtonA',interaction_mode)>: Use Garage]],self}
	end
end

local orig_BaseRover_CanInteractWithObject = BaseRover.CanInteractWithObject
function BaseRover:CanInteractWithObject(obj, interaction_mode, ...)
	local ret1,ret2 = CanInteractWithObject_local(self, obj, interaction_mode)
	if ret1 then
		return ret1,ret2
	end

	return orig_BaseRover_CanInteractWithObject(self, obj, interaction_mode, ...)
end

local orig_BaseRover_InteractWithObject = BaseRover.InteractWithObject
function BaseRover:InteractWithObject(obj, interaction_mode, ...)
	if (self.interaction_mode == false or self.interaction_mode == "default" or self.interaction_mode == "move") and IsKindOf(obj, "RCGarage") and obj:CheckMainGarage() and obj.garages.main.working then
		self:SetCommand("ChoGGi_UseGarage", obj)
		SetUnitControlInteractionMode(self, false) --toggle button
	end

	return orig_BaseRover_InteractWithObject(self, obj, interaction_mode, ...)
end

-- block rover from goto when in garage
local orig_BaseRover_GotoFromUser = BaseRover.GotoFromUser or Unit.GotoFromUser
function BaseRover:GotoFromUser(...)
	if not self.ChoGGi_InGarage then
		return orig_BaseRover_GotoFromUser(self,...)
	end
end
-- maybe add SetCommand

-- block RCRover from dropping the poor little drones in the void
local orig_RCRover_Siege = RCRover.Siege
function RCRover:Siege(...)
	if self.ChoGGi_InGarage then
		Sleep(1000)
	else
		return orig_RCRover_Siege(self,...)
	end
end

function BaseRover:ChoGGi_UseGarage(garage)
	-- maybe not needed?
	self:ExitHolder(garage)

	-- pack away the drones
	if self:IsKindOf("RCRover") then
		-- if drones already being sent in
		if self.sieged_state then
			self:Unsiege()
			self.siege_state_name = "UnSiege"
			self.sieged_state = false
		end
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

	if rawget(g_Classes,"PMSAttackRover") then
		local orig_PMSAttackRover_CanInteractWithObject = PMSAttackRover.CanInteractWithObject
		function PMSAttackRover:CanInteractWithObject(obj, interaction_mode, ...)
			local ret1,ret2 = CanInteractWithObject_local(self, obj, interaction_mode)
			if ret1 then
				return ret1,ret2
			end
			return orig_PMSAttackRover_CanInteractWithObject(self, obj, interaction_mode, ...)
		end
	end

	if rawget(g_Classes,"NASAAttackRover") then
		local orig_NASAAttackRover_CanInteractWithObject = NASAAttackRover.CanInteractWithObject
		function NASAAttackRover:CanInteractWithObject(obj, interaction_mode, ...)
			local ret1,ret2 = CanInteractWithObject_local(self, obj, interaction_mode)
			if ret1 then
				return ret1,ret2
			end
			return orig_NASAAttackRover_CanInteractWithObject(self, obj, interaction_mode, ...)
		end
	end

end
