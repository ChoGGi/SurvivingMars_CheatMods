-- See LICENSE for terms

local mod_DisableSelect

-- fired when settings are changed/init
local function ModOptions()
	mod_DisableSelect = CurrentModOptions:GetProperty("DisableSelect")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
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
