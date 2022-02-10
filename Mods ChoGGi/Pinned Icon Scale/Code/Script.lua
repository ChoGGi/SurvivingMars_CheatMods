-- See LICENSE for terms

local IsPoint = IsPoint

local mod_PinsScale

local function UpdatePins()
	if not IsPoint(mod_PinsScale) or not UICity then
		return
	end

	local pins = Dialogs.PinsDlg or ""
	for i = 1, #pins do
		local pin = pins[i]
		if pin:IsKindOf("XBlinkingButton") then
			pin:SetOutsideScale(mod_PinsScale)
		end
	end
end
OnMsg.CityStart = UpdatePins
OnMsg.LoadGame = UpdatePins
-- switch between different maps (happens before UICity)
OnMsg.ChangeMapDone = UpdatePins

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_PinsScale = tonumber(CurrentModOptions:GetProperty("PinsScale"))

	if mod_PinsScale and mod_PinsScale ~= 0 then
		mod_PinsScale = point(mod_PinsScale, mod_PinsScale)
	end

	UpdatePins()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_UpdatePinsDlgMargins = UpdatePinsDlgMargins
function UpdatePinsDlgMargins(...)
	UpdatePins()
	return ChoOrig_UpdatePinsDlgMargins(...)
end
