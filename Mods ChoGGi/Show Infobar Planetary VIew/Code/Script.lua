-- See LICENSE for terms

local Sleep = Sleep

local function IsValidXWin(win)
	win = win and win.window_state
	if win and win ~= "destroying" then
		return true
	end
end

local function AddInfobar()
	local Dialogs = Dialogs
	Dialogs.Infobar:SetVisible(true)

	local TerraParams = Dialogs.TerraformingParamsBarDlg
	if TerraParams then
		Dialogs.Infobar.idTerraformingBar:SetVisible(false)
		TerraParams[1]:SetMargins(box(0,Dialogs.Infobar.idPad.box:sizey(),0,0))
		while IsValidXWin(TerraParams) do
			Sleep(1000)
		end
		Dialogs.Infobar.idTerraformingBar:SetVisible(true)
	end
end

local orig_OpenDialog = OpenDialog
function OpenDialog(dlg_str, ...)
	local dlg = orig_OpenDialog(dlg_str, ...)
	if dlg_str == "PlanetaryView" then
		CreateRealTimeThread(AddInfobar)
	end
	return dlg
end
