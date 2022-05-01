-- See LICENSE for terms

local RetMapType = ChoGGi.ComFuncs.RetMapType
local IsValidXWin = ChoGGi.ComFuncs.IsValidXWin

local mod_EnableMod

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_SupplyPod_GameInit = SupplyPod.GameInit
function SupplyPod:GameInit(...)
	if not mod_EnableMod then
		return ChoOrig_SupplyPod_GameInit(self, ...)
	end

	local GameMaps = GameMaps
	for _, map in pairs(GameMaps) do
		if RetMapType(nil, map.map_id) == "asteroid" then
			map.pinnables.pins[#map.pinnables.pins+1] = self
		end
	end
	-- update current pins dialog
	if IsValidXWin(Dialogs.PinsDlg) then
		Dialogs.PinsDlg:Pin(self)
	end

	return ChoOrig_SupplyPod_GameInit(self, ...)
end
