-- See LICENSE for terms

if not g_AvailableDlc.gagarin then
	print(CurrentModDef.title, ": Space Race DLC not installed!")
	return
end

local CalcOrientation = CalcOrientation
local GetSunPos = GetSunPos
local SunToSolarPanelAngle = SunToSolarPanelAngle
local Sleep = Sleep

-- GlobalGameTimeThread("SolarPanelOrientation", function()
local update_interval = 3 * const.MinuteDuration

local function AddPanels(bld)
	bld.ChoGGi_panels = {}
	local c = 0
	bld:ForEachAttach("SolarArrayPanel", function(a)
		c = c + 1
		bld.ChoGGi_panels[c] = a
	end)
end

function OnMsg.BuildingInit(bld)
	if not bld:IsKindOf("SolarArray") then
		return
	end
	-- add panels into table for ease of looping
	AddPanels(bld)
end

function OnMsg.LoadGame()
	-- do any existing
	local arrays = UIColony.city_labels.labels.SolarArray or ""
	for i = 1, #arrays do
		local bld = arrays[i]
		if not bld.ChoGGi_panels then
			AddPanels(bld)
		end
	end
	-- I probably need to do this since i load mods in the main menu and it's a GlobalGameTimeThread
	RestartGlobalGameTimeThread("SolarArrayOrientation")
end

function OnMsg.CityStart()
	CreateRealTimeThread(function()
		WaitMsg("MarsResume")
		RestartGlobalGameTimeThread("SolarArrayOrientation")
	end)
end

GlobalGameTimeThread("SolarArrayOrientation", function()
	while true do
		Sleep(update_interval)
		-- 18250 matches them up with the other solar panel buildingss
		-- I assume they rotate on a diff angle or something?
		local panel_offset = 18250
		local azi = SunToSolarPanelAngle(GetSunPos()) + panel_offset
		local arrays = UIColony.city_labels.labels.SolarArray or ""
		for i = 1, #arrays do
			local array = arrays[i]
			local art_sun = array.artificial_sun and array.artificial_sun:GetPos()
			for j = 1, #(array.ChoGGi_panels or "") do
				local panel_obj = array.ChoGGi_panels[j]

				if array:IsAffectedByArtificialSun() then
					local angle = CalcOrientation(panel_obj:GetPos(), art_sun)
					-- 21600 / 360 = 60, not sure what 90 is for...
					panel_obj:SetAngle(angle+90*60, update_interval)
				else
					panel_obj:SetAngle(azi, update_interval)
				end

			end
		end
	end
end)


-- sink into ground when no sun.
SolarArray.open_close_thread = false
SolarArray.interaction_state = false
function OnMsg.ClassesPostprocess()

	SolarArray.IsOpened = SolarPanel.IsOpened
	SolarArray.UpdateProduction = SolarPanel.UpdateProduction

	function SolarArray:SetInteractionState(state)
		if self.ChoGGi_PanelGround == nil then
			self.ChoGGi_PanelGround = true
		end

		if state == self.interaction_state then
			return
		end
		self.interaction_state = state
		self:OnChangeState()
		DeleteThread(self.open_close_thread)
		self.open_close_thread = CreateGameTimeThread(function()
			if state then
			end

			if self:CanBeOpened() and not self.ChoGGi_PanelGround then
				self:SetPos(self:GetPos():AddZ(300), 2000)
				self.ChoGGi_PanelGround = true
			elseif not self:CanBeOpened() and self.ChoGGi_PanelGround then
				self:SetPos(self:GetPos():AddZ(-300), 2000)
				self.ChoGGi_PanelGround = false
			end

		end)
	end

end

-- the below is for removing the persist warnings from the log


function OnMsg.SaveGame()
	DeleteThread(SolarArrayOrientation)
	_G.SolarArrayOrientation = false
end
-- PostSaveGame is added by my lib mod
function OnMsg.PostSaveGame()
	RestartGlobalGameTimeThread("SolarArrayOrientation")
end

-- seems they stop after awhile, so...
function OnMsg.NewDay()
	DeleteThread(SolarArrayOrientation)
	_G.SolarArrayOrientation = false
	RestartGlobalGameTimeThread("SolarArrayOrientation")
end
