-- See LICENSE for terms

local type = type
local table = table
local DoneObject = DoneObject
local CreateNumberEditor = CreateNumberEditor

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

local function MoveItem(test, list, order1, order2)
	if test then
		return
	end
	-- swap around tech ids
	local orig = list[order1]
	local new = list[order2]
	list[order1] = new
	list[order2] = orig

	PlayFX("EnqueueResearch", "start")
	Msg("ResearchQueueChange", UICity, new)
end

local function AddButtons(item, order, list)
	local _, top_btn, bottom_btn = CreateNumberEditor(item, "useless_edit", function()
		MoveItem(order == 1, list, order-1, order)
	end, function()
		MoveItem(order == #list, list, order+1, order)
	end, true)

	top_btn:SetBackground(-1)
	bottom_btn:SetBackground(-1)

	-- centre button height
	top_btn.parent:SetVAlign("center")

	top_btn.parent.ChoGGi_ReorderButtons = true
end


local function EditDlg(dlg, res_list)
	if not mod_EnableMod then
		return
	end
	WaitMsg("OnRender")

--~ 	ex(res_list)

	local context = res_list.context
	local count = #res_list

	for i = 1, count do
		local list_item = res_list[i]
		if list_item.context then
			local right_side = list_item[2]
			-- holding ctrl while adding an item to a full list with add double buttons
			if not table.find(right_side, "ChoGGi_ReorderButtons", true) then
				if i == 1 then
					AddButtons(right_side, i, context)
				elseif i == count then
					AddButtons(right_side, i, context)
				else
					AddButtons(right_side, i, context)
				end
			end
		end
	end

end

function OnMsg.ResearchQueueChange(UICity, tech_id)
	local dlg = Dialogs.ResearchDlg
	if dlg then
		CreateRealTimeThread(EditDlg, dlg, dlg.idResearchQueueList)
	end
end

local orig_OpenDialog = OpenDialog
function OpenDialog(dlg_str, ...)
	local dlg = orig_OpenDialog(dlg_str, ...)

	if dlg_str == "ResearchDlg" then
		CreateRealTimeThread(EditDlg, dlg, dlg.idResearchQueueList)
	end

	return dlg
end
