-- See LICENSE for terms

local DroneLoadMediumThreshold = const.DroneLoadMediumThreshold
local IsValid = IsValid
local DoneObject = DoneObject

local RotatyThing_l
function DroneHub:ChoGGi_ToggleStrobe(enable)
	if enable then
		-- add if it isn't already added
		if not IsValid(self.ChoGGi_HeavyStrobeLight) then
			local blinky_obj = RotatyThing_l:new()
			self.ChoGGi_HeavyStrobeLight = blinky_obj
			blinky_obj.parent_obj = self
			-- stick it on the top
			self:Attach(blinky_obj, self:GetSpotBeginIndex("Top"))
			-- maybe a bit higher
			blinky_obj:SetAttachOffset(point(0, 0, 2500))
		end
	else
		-- byebye strobe
		if IsValid(self.ChoGGi_HeavyStrobeLight) then
			DoneObject(self.ChoGGi_HeavyStrobeLight)
			self.ChoGGi_HeavyStrobeLight = false
		end
	end
end

function OnMsg.ClassesBuilt()
	RotatyThing_l = RotatyThing_l or RotatyThing

	local orig_UpdateHeavyLoadNotification = DroneHub.UpdateHeavyLoadNotification
	function DroneHub:UpdateHeavyLoadNotification(...)

		self:ChoGGi_ToggleStrobe(self.working and self.drones
			and self:CalcLapTime() > DroneLoadMediumThreshold
		)

		return orig_UpdateHeavyLoadNotification(self, ...)
	end
end
