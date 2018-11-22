local Sleep = Sleep
local SunToSolarPanelAngle = SunToSolarPanelAngle
local GetSunPos = GetSunPos
local CalcOrientation = CalcOrientation

local function AddPanels(a,bld)
	bld.ChoGGi_panels[#bld.ChoGGi_panels+1] = a
end
function OnMsg.BuildingInit(bld)
	-- add panels into table for ease of looping
	if bld:IsKindOf("SolarArray") then
		bld.ChoGGi_panels = {}
		bld:ForEachAttach("SolarArrayPanel",AddPanels,bld)
	end
end

function OnMsg.LoadGame()
	-- do any existing
	local arrays = UICity.labels.SolarArray or ""
	for i = 1, #arrays do
		local a = arrays[i]
		if not a.ChoGGi_panels then
			a.ChoGGi_panels = {}
			a:ForEachAttach("SolarArrayPanel",AddPanels,a)
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

local MinuteDuration = const.MinuteDuration
function SolarArraysOrientToSun(anim_time)
	anim_time = anim_time or MinuteDuration
	local azi = SunToSolarPanelAngle(GetSunPos()) + 18250
	local arrays = UICity.labels.SolarArray or ""
	for i = 1, #arrays do
		local array = arrays[i]
		local art_sun = array.artificial_sun and array.artificial_sun:GetPos()
--~ 		local array_pos = array:GetPos()
		for j = 1, #array.ChoGGi_panels do
			local panel_obj = array.ChoGGi_panels[j]

			if array:IsAffectedByArtificialSun() then
				local angle = CalcOrientation(panel_obj:GetPos(), art_sun)
--~ 				local angle = CalcOrientation(array_pos, art_sun)
				panel_obj:SetAngle(angle+90*60, anim_time)
			else
				panel_obj:SetAngle(azi, anim_time)
			end

		end

	end
end

GlobalGameTimeThread("SolarArrayOrientation", function()
	local update_interval = 3*const.MinuteDuration
	while true do
		Sleep(update_interval)
		SolarArraysOrientToSun(update_interval)
	end
end)
