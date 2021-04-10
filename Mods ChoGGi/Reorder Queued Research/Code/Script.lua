-- See LICENSE for terms

local type = type
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

local function MoveItem(test, list, order1, order2, dlg)
	if test then
		return
	end
	-- swap around tech ids
	local orig = list[order1]
	local new = list[order2]
	list[order1] = new
	list[order2] = orig

	Msg("ResearchQueueChange", UICity, new, dlg)
end

local function AddButtons(item, order, list, dlg)
	local edit, top_btn, bottom_btn = CreateNumberEditor(item, "useless_edit", function()
		MoveItem(order == 1, list, order-1, order, dlg)
	end, function()
		MoveItem(order == #list, list, order+1, order, dlg)
	end, true)

	top_btn:SetBackground(-1)
	bottom_btn:SetBackground(-1)

	-- centre button height
	top_btn.parent:SetVAlign("center")
end


local function EditDlg(dlg)
	WaitMsg("OnRender")
	local res_list = dlg.idResearchQueueList
--~ 	ex(res_list)

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
	if mod_EnableMod and type(dlg) == "table" and IsValidXWin(dlg.idResearchQueueList) then
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
