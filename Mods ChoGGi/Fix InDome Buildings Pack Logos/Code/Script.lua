-- See LICENSE for terms

if LuaRevision > 1001586 then
	return
end

if not g_AvailableDlc.kerwin then
	print(CurrentModDef.title, ": In-Dome Buildings Pack DLC not installed!")
	return
end

local function StartupCode()
	if not CurrentModOptions:GetProperty("EnableMod") then
		return
	end

	MissionLogoPresetMap.CCP1Logo_1.entity_name = "DecCCP1Logo_01"
	MissionLogoPresetMap.CCP1Logo_2.entity_name = "DecCCP1Logo_02"
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
-- fires every time the new game screen changes (flying rocket logo)
OnMsg.GameTimeStart = StartupCode
