-- See LICENSE for terms

local _InternalTranslate = _InternalTranslate
local T = T

-- locale id to string
local function TT(id, str)
	return _InternalTranslate(T(id, str))
end

-- Load strings
local locale_path = CurrentModPath .. "Locales/"
LoadTranslationTableFile(locale_path .. GetLanguage() .. ".csv")
-- If there's no csv for lang then it won't get to this
Msg("TranslationChanged")

local cheats_lookup = {
	Despawn = 85947360000000,
	Empty = 85947360000001,
	Fill = 85947360000002,
	Scan = 85947360000003,
}

function OnMsg.SelectionChange()
	CreateRealTimeThread(function()
		local dlg = Dialogs.Infopanel
		if not dlg then
			return
		end
		local infopanel_list = dlg.idContent
		local cheats_list
		-- Need to find the xwin with the list of cheats
		for i = 1, #infopanel_list do
			local item = infopanel_list[i]
			if item.idContent
				and item.idContent[2]
				and item.idContent[2].Toolbar
				and item.idContent[2].Toolbar == "cheats"
			then
				-- Found them
				cheats_list = item.idContent[2]
			end
		end
		if not cheats_list then
			return
		end

		-- Now go through the list of cheats and update text
		for i = 1, #cheats_list do
			local cheat = cheats_list[i]
			local str_id = cheats_lookup[cheat.Text]
			if str_id then
				cheat:SetText(TT(str_id))
			end
		end
	end)

end
