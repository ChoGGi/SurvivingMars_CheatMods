-- See LICENSE for terms

local function EditDlg(dlg)
	if dlg.idTerraformingBar then
		dlg.idTerraformingBar:delete()
		dlg.idTerraformingBar = nil
	end
end

local orig_OpenDialog = OpenDialog
function OpenDialog(dlg_str, ...)
	local dlg = orig_OpenDialog(dlg_str, ...)
	if dlg_str == "Infobar" then
		EditDlg(dlg)
	end
	return dlg
end
