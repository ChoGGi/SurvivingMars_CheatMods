-- See LICENSE for terms

local mod_ChangePercent
local mod_HideBackground

-- fired when settings are changed/init
local function ModOptions()
	mod_ChangePercent = CurrentModOptions:GetProperty("ChangePercent")
	mod_HideBackground = CurrentModOptions:GetProperty("HideBackground")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

local function EditDlg(dlg)
	WaitMsg("OnRender")

	for i = 1, #dlg.idArea do
		local techfield = dlg.idArea[i].idFieldTech
		-- there's some other ui elements without a idFieldTech we want to skip
		if techfield then
			-- loop through tech list
			for j = 1, #techfield do
				local tech = techfield[j]

				if mod_ChangePercent and tech.idProgressInfo then
					-- fiddle with in-progress tech
					for l = 1, #tech.idProgressInfo do
						local element = tech.idProgressInfo[l]
						if element:IsKindOf("XImage") then
							element:SetVisible(false)
						elseif element:IsKindOf("XText") then
							element:SetHAlign("left")
							element:SetVAlign("top")
							-- hard to see the numbers
							element:SetBackground(-16777216)
						end
					end
				else
					-- fiddle with completed tech
					local button = tech.idContent
					for l = 1, #button do
						local element = button[l]
						if element.Image == "UI/Icons/Research/rm_completed.tga" then
							-- less visible blue
							if mod_HideBackground then
								element:SetTransparency(255)
							else
								element:SetTransparency(135)
							end
						elseif element.Image == "UI/Icons/Research/rm_researched_2.tga" then
							element:SetHAlign("left")
							element:SetVAlign("top")
							element:SetImageFit("none")
							element:SetImageScale(point(200, 200))
						end
					end
				end -- if

			end
		end
	end
end

local orig_OpenDialog = OpenDialog
function OpenDialog(dlg_str, ...)
	local dlg = orig_OpenDialog(dlg_str, ...)
	if dlg_str == "ResearchDlg" then
		CreateRealTimeThread(EditDlg, dlg)
	end
	return dlg
end
