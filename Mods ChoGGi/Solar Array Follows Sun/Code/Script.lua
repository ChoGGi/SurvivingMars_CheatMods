-- See LICENSE for terms

local function AddPanels(bld)
	bld.ChoGGi_panels = {}
  local attaches = bld:GetAttaches() or ""
  for i = 1, #attaches do
		bld.ChoGGi_panels[i] = attaches[i]
  end
end

function OnMsg.BuildingInit(bld)
	-- add panels into table for ease of looping
	if bld:IsKindOf("SolarArray") then
		AddPanels(bld)
	end
end

function OnMsg.LoadGame()
	-- do any existing
	local arrays = UICity.labels.SolarArray or ""
	for i = 1, #arrays do
		local bld = arrays[i]
		if not bld.ChoGGi_panels then
			AddPanels(bld)
		end
	end
	-- i probably need to do this since i load mods in the main menu and it's a GlobalGameTimeThread
	RestartGlobalGameTimeThread("SolarArrayOrientation")
end

function OnMsg.CityStart()
	CreateRealTimeThread(function()
		WaitMsg("MarsResume")
		RestartGlobalGameTimeThread("SolarArrayOrientation")
	end)
end

GlobalGameTimeThread("SolarArrayOrientation", function()
	local CalcOrientation = CalcOrientation
	local GetSunPos = GetSunPos
	local SunToSolarPanelAngle = SunToSolarPanelAngle
	local Sleep = Sleep
	local update_interval = 3*const.MinuteDuration
	while true do
		Sleep(update_interval)
		-- 18250 matches them up with the other panels (I assume they rotate on a diff angle or something)
		local azi = SunToSolarPanelAngle(GetSunPos()) + 18250
		local arrays = UICity.labels.SolarArray or ""
		for i = 1, #arrays do
			local array = arrays[i]
			local art_sun = array.artificial_sun and array.artificial_sun:GetPos()
			for j = 1, #array.ChoGGi_panels do
				local panel_obj = array.ChoGGi_panels[j]

				if array:IsAffectedByArtificialSun() then
					local angle = CalcOrientation(panel_obj:GetPos(), art_sun)
					panel_obj:SetAngle(angle+90*60, update_interval)
				else
					panel_obj:SetAngle(azi, update_interval)
				end

			end

		end

	end
end)
