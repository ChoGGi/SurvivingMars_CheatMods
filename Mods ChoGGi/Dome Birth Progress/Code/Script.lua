-- See LICENSE for terms

local ChoOrig_Community_GetBirthText = Community.GetBirthText
function Community:GetBirthText(...)
	local info = ChoOrig_Community_GetBirthText(self, ...)

	local list = info[1]
	list.j = list.j + 1
	list.table[list.j] = T{1197, "Progress <right><percent(ProgressPct)>",
		ProgressPct = MulDivRound(self.birth_progress, 100, g_Consts.BirthThreshold),
	}

	return info
end
