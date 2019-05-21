-- See LICENSE for terms

local mod_id = "ChoGGi_ResearchSmallCheckMarks"
local mod = Mods[mod_id]

local mod_ChangePercent = mod.options and mod.options.ChangePercent or true
local mod_HideBackground = mod.options and mod.options.HideBackground or true

local function ModOptions()
	mod_ChangePercent = mod.options.ChangePercent
	mod_HideBackground = mod.options.HideBackground
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= mod_id then
		return
	end

	ModOptions()
end

-- for some reason mod options aren't retrieved before this script is loaded...
OnMsg.CityStart = ModOptions
OnMsg.LoadGame = ModOptions

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
