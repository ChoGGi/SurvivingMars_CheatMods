-- See LICENSE for terms

local table_ifilter = table.ifilter
local table_find = table.find
local DroneLoadLowThreshold = const.DroneLoadLowThreshold
local DroneLoadMediumThreshold = const.DroneLoadMediumThreshold

local white, purple, green, orange, red, gray = white, purple, green, orange, red, const.clrGray

local mod_ColouredRovers
local mod_ChangePinnedRoverIcons

-- fired when settings are changed/init
local function ModOptions()
	mod_ColouredRovers = CurrentModOptions:GetProperty("ColouredRovers")
	mod_ChangePinnedRoverIcons = CurrentModOptions:GetProperty("ChangePinnedRoverIcons")

	-- make sure we're not in menus
	if not GameState.gameplay
		-- reset pin bg (below)
		or mod_ChangePinnedRoverIcons
	then
		return
	end

	local pins_dlg = OpenDialog("PinsDlg", GetInGameInterface())
	if not pins_dlg then
		return
	end

	local objs = g_PinnedObjs or ""
	for i = 1, #objs do
		local obj = objs[i]
		if obj:IsKindOf("RCRover") or obj:IsKindOf("DroneHub") then
			pins_dlg[table_find(pins_dlg, "context", obj)].idCondition:SetBackground(0)
		end
	end

end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

local function UpdateColour(self)
	local colour = white
	if self.working then
		-- no working drones
		if #table_ifilter(self.drones, function(_, drone)
					return not drone:IsDisabled()
				end) < 1 then
			colour = purple
		-- idle drones
		elseif self:GetIdleDronesCount() == self:GetDronesCount() then
			colour = gray
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
	return colour
end

local function RoverUpdate(func, self, ...)
	local colour
	if mod_ColouredRovers or mod_ChangePinnedRoverIcons then
		colour = UpdateColour(self)
	end

	if mod_ColouredRovers then

		if self.class == "RCSensor" then
			local attach = self:GetAttach("RoverEuropeAntena")
			attach:SetColor2(colour)
			attach:SetColor3(colour)
			-- rims
			self:SetColor3(colour)
		elseif self.class == "RCSolar" then
			self:GetAttach("RoverChinaSolarPanel"):SetColor2(colour)
			-- rims
			self:SetColor3(colour)
		else -- rover
			-- mast
			self:SetColor1(colour)
			-- rims
			self:SetColor3(colour)
		end
	end

	-- update pin icon
	if mod_ChangePinnedRoverIcons then
		local pins_dlg = OpenDialog("PinsDlg", GetInGameInterface())
		if pins_dlg and self:IsPinned() then
			-- get button and update
			pins_dlg[table_find(pins_dlg, "context", self)].idCondition:SetBackground(colour)
		end
	end

	return func(self, ...)
end

function OnMsg.ClassesPostprocess()
	-- UpdateHeavyLoadNotification is the same func for all, but just in case someone changes one of them

	local orig_RCRover_UpdateHeavyLoadNotification = RCRover.UpdateHeavyLoadNotification
	function RCRover:UpdateHeavyLoadNotification(...)
		return RoverUpdate(orig_RCRover_UpdateHeavyLoadNotification, self, ...)
	end

	if RCSensor then
		local orig_RCSensor_UpdateHeavyLoadNotification = RCSensor.UpdateHeavyLoadNotification
		function RCSensor:UpdateHeavyLoadNotification(...)
			return RoverUpdate(orig_RCSensor_UpdateHeavyLoadNotification, self, ...)
		end
	end

	if RCSolar then
		local orig_RCSolar_UpdateHeavyLoadNotification = RCSolar.UpdateHeavyLoadNotification
		function RCSolar:UpdateHeavyLoadNotification(...)
			return RoverUpdate(orig_RCSolar_UpdateHeavyLoadNotification, self, ...)
		end
	end



	local orig_DroneHub_UpdateHeavyLoadNotification = DroneHub.UpdateHeavyLoadNotification
	function DroneHub:UpdateHeavyLoadNotification(...)
		local colour = UpdateColour(self)
--~ 		print(colour,GetRGB(colour))
		self:SetColor1(colour)

		local entity = self:GetEntity()
		if entity == "DroneHubCP3" then
			self:GetAttach("DroneHubCP3Antenna"):SetColor1(colour)
		else
			self:GetAttach("DroneHubAntenna"):SetColor1(colour)
		end

		return orig_DroneHub_UpdateHeavyLoadNotification(self, ...)
	end
end

