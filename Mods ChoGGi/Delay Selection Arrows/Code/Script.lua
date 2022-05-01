-- See LICENSE for terms

local efSelectable = const.efSelectable
local IsKindOf = IsKindOf

local mod_DisableSelect

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_DisableSelect = CurrentModOptions:GetProperty("DisableSelect")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_SelectionArrowAdd = SelectionArrowAdd
function SelectionArrowAdd(obj, ...)
	if mod_DisableSelect then
		ChoOrig_SelectionArrowAdd(obj, ...)
		if IsKindOf(obj, "Drone") or IsKindOf(obj, "Colonist") then
			local arrow = obj:GetAttach("SelectionArrow")
			if arrow then
				arrow:ClearEnumFlags(efSelectable)
			end
		end
	else
		local varargs = ...
		CreateRealTimeThread(function()
			WaitMsg("OnRender")
			ChoOrig_SelectionArrowAdd(obj, varargs)
		end)
	end
end
