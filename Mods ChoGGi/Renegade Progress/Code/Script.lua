-- See LICENSE for terms

local options
local mod_DisableRenegades

-- fired when settings are changed/init
local function ModOptions()
	mod_DisableRenegades = options.DisableRenegades
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

function OnMsg.ColonistAddTrait(colonist, trait)
	if trait == "Renegade" and mod_DisableRenegades then
		colonist:RemoveTrait(trait)
	end
end

local constRenegadeCreation
local function CalcProgress(dome)
	if not constRenegadeCreation then
		constRenegadeCreation = IsGameRuleActive("RebelYell")
			and g_Consts.GameRuleRebelYellRenegadeCreation or g_Consts.RenegadeCreation
	end

	return MulDivRound(dome.renegade_progress, 100, constRenegadeCreation)
end
local function CalcRenegades(dome)
	return #(dome.labels.Renegade or "")
end

function OnMsg.ClassesPostprocess()

	-- add progress info
	local xtemplate = XTemplates.sectionDome[1]
	local idx = table.find(xtemplate, "Icon", "UI/Icons/Sections/morale.tga")
	if idx then
		xtemplate[idx].RolloverText = T(856271865233, "The average <em>Morale</em> of all Colonists living in this Dome.")
			.. "\n\n" .. T(4368, "Renegade") .. " " .. T(7637, "Growth Sequence")
			.. T{"<right><percent(progress)>", progress = CalcProgress}
			.. T("\n<left>") .. T{7346, "Renegades<right><colonist(number)>",
				number = CalcRenegades,
			}
	end

	-- sure be nice if xtemplates weren't so ugly to navigate
	xtemplate = XTemplates.Infobar[1][3][1]
	idx = table.find(xtemplate, "Id", "idColonists")
	if not idx then
		return
	end
	xtemplate = xtemplate[idx][2][4] -- idJobs

	local rene_str = T(4368, "Renegade") .. " " .. T(83, "Domes")
	xtemplate.RolloverHint = T(11708, "<left_click> Cycle unemployed citizens")
		.. T("\n<right_click>") .. rene_str
	xtemplate.RolloverHintGamepad = T(11717, "<ButtonA> Cycle unemployed citizens<newline><DPad> Navigate <DPadDown> Close")
		.. T("\n<ButtonX>") .. rene_str

	xtemplate.AltPress = true
	xtemplate.OnAltPress = function(self)
		self.context:ChoGGi_CycleRenegadeDomes()
	end
end

function InfobarObj:ChoGGi_CycleRenegadeDomes()
	local list = {}
	local c = 0

	local domes = UICity.labels.Dome or ""

	for i = 1, #domes do
		local dome = domes[i]
		local l = dome.labels

		if dome.renegade_progress > 0
			and #(l.Senior or l["Middle Aged"] or l.Adult or l.Youth or "") > 0
		then
			c = c + 1
			list[c] = dome
		end
	end

	if #list > 0 then
		-- dunno why they localed it, instead of making it InfobarObj:CycleObjects()...
		local idx = SelectedObj and table.find(list, SelectedObj) or 0
		idx = (idx % #list) + 1
		local next_obj = list[idx]

		ViewAndSelectObject(next_obj)
		XDestroyRolloverWindow()
	end
end
