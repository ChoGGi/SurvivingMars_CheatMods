-- See LICENSE for terms

local orig_Dome_GetBirthText = Dome.GetBirthText
function Dome:GetBirthText(...)
	local info = orig_Dome_GetBirthText(self, ...)

	local list = info[1]
	list.j = list.j + 1
	list.table[list.j] = T{1197, "Progress <right><percent(ProgressPct)>",
		ProgressPct = MulDivRound(self.birth_progress, 100, g_Consts.BirthThreshold),
	}

	return info
end
