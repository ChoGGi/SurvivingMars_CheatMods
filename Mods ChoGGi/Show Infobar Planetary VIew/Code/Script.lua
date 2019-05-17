-- See LICENSE for terms

local Sleep = Sleep

local function AddInfobar()
	local Dialogs = Dialogs
	Dialogs.Infobar:SetVisible(true)
	Dialogs.Infobar.idTerraformingBar:SetVisible(false)
	local TerraParams = Dialogs.TerraformingParamsBarDlg
	TerraParams[1]:SetMargins(box(0,Dialogs.Infobar.idPad.box:sizey(),0,0))
	while TerraParams.window_state ~= "destroying" do
		Sleep(1000)
	end
	Dialogs.Infobar.idTerraformingBar:SetVisible(true)
end

local orig_OpenDialog = OpenDialog
function OpenDialog(dlg_str, ...)
	local dlg = orig_OpenDialog(dlg_str, ...)
	if dlg_str == "PlanetaryView" then
		CreateRealTimeThread(AddInfobar)
	end
	return dlg
end
