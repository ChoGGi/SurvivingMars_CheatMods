-- See LICENSE for terms

local DoneObject = DoneObject
local CreateNumberEditor = CreateNumberEditor
local IsValidXWin = ChoGGi.ComFuncs.IsValidXWin

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

local function AddButtons(item, order, list, dlg)
	local edit, top_btn, bottom_btn = CreateNumberEditor(item, "useless_edit", function(self, _)
		if order == 1 then
			return
		end
		local orig = list[order-1]
		local new = list[order]
		list[order-1] = new
		list[order] = orig

		Msg("ResearchQueueChange", UICity, new, dlg)
	end, function(self, _)
		if order == #list then
			return
		end
		local orig = list[order+1]
		local new = list[order]
		list[order+1] = new
		list[order] = orig

		Msg("ResearchQueueChange", UICity, new, dlg)
	end, true)

	-- Lib 9.7
	-- CreateNumberEditor adds an edit input
	if IsValidXWin(edit) then
		DoneObject(edit)
	end
	-- Lib 9.7

	top_btn:SetBackground(-1)
	bottom_btn:SetBackground(-1)
end


local function EditDlg(dlg)
--~ 	ex(dlg)
	WaitMsg("OnRender")
	local res_list = dlg.idResearchQueueList

	local context = res_list.context
	local count = #res_list

	for i = 1, count do
		if i == 1 then
			AddButtons(res_list[i][2], i, context, dlg)
		elseif i == count then
			AddButtons(res_list[i][2], i, context, dlg)
		else
			AddButtons(res_list[i][2], i, context, dlg)
		end
	end
end

function OnMsg.ResearchQueueChange(UICity, tech_id, dlg)
	if mod_EnableMod and dlg and dlg.idResearchQueueList and
		IsValidXWin(dlg.idResearchQueueList)
	then
		CreateRealTimeThread(EditDlg, dlg)
	end
end

local orig_OpenDialog = OpenDialog
function OpenDialog(dlg_str, ...)
	local dlg = orig_OpenDialog(dlg_str, ...)

	if not mod_EnableMod then
		return dlg
	end

	if dlg_str == "ResearchDlg" then
		CreateRealTimeThread(EditDlg, dlg)
	end

	return dlg
end
