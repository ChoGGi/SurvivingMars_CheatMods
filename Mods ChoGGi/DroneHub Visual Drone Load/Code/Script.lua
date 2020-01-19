-- See LICENSE for terms

local table_ifilter = table.ifilter
local DroneLoadLowThreshold = const.DroneLoadLowThreshold
local DroneLoadMediumThreshold = const.DroneLoadMediumThreshold

local white, purple, green, orange, red = white, purple, green, orange, red

function OnMsg.ClassesPostprocess()
	local orig_UpdateHeavyLoadNotification = DroneHub.UpdateHeavyLoadNotification
	function DroneHub:UpdateHeavyLoadNotification(...)

		local colour = white
		if self.working then
			-- no working drones
			if #table_ifilter(self.drones, function(_, o)
						return not o:IsDisabled()
					end) < 1 then
				colour = purple
			else
				local lap_time = self:CalcLapTime()
				if lap_time < DroneLoadLowThreshold then
					colour = green
				elseif lap_time < DroneLoadMediumThreshold then
					colour = orange
				else
					colour = red
				end
			end
		end

--~ 		print(colour,GetRGB(colour))
		self:SetColor1(colour)

		local entity = self:GetEntity()
		if entity == "DroneHubCP3" then
			self:GetAttach("DroneHubCP3Antenna"):SetColor1(colour)
		else
			self:GetAttach("DroneHubAntenna"):SetColor1(colour)
		end

		return orig_UpdateHeavyLoadNotification(self, ...)
	end
end

