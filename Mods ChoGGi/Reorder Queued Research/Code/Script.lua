-- See LICENSE for terms

local CreateRealTimeThread = CreateRealTimeThread
local WaitMsg = WaitMsg
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

local function AddButtons(item, order, list, dlg)
	local edit, top_btn, bottom_btn = CreateNumberEditor(item, "useless_edit", function(self, _)
		if order == 1 then
			return
		end
--~ 		print("order-", order, order-1, list[order-1], list[order])
		local orig = list[order-1]
		local new = list[order]
		list[order-1] = new
		list[order] = orig

--~ 		print("up")
		dlg:Close()
		HUD.idResearchOnPress()
	end, function(self, _)
		if order == #list then
			return
		end
--~ 		print("order+", order, order+1, list[order+1], list[order])
		local orig = list[order+1]
		local new = list[order]
		list[order+1] = new
		list[order] = orig

--~ 		print("down")
		dlg:Close()
		HUD.idResearchOnPress()
	end)
	-- CreateNumberEditor adds an edit input
	DoneObject(edit)

	top_btn:SetBackground(-1)
	bottom_btn:SetBackground(-1)
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
