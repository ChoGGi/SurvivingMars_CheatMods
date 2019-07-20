-- See LICENSE for terms

local options
local mod_DisableSelect

-- fired when settings are changed/init
local function ModOptions()
	mod_DisableSelect = options.DisableSelect
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_DelaySelectionArrows" then
		return
	end

	ModOptions()
end

local efSelectable = const.efSelectable
local IsKindOf = IsKindOf

local orig_SelectionArrowAdd = SelectionArrowAdd
function SelectionArrowAdd(obj, ...)
	if mod_DisableSelect then
		orig_SelectionArrowAdd(obj, ...)
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
			orig_SelectionArrowAdd(obj, varargs)
		end)
	end
end
