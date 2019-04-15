-- See LICENSE for terms

local table_concat = table.concat
local MulDivRound = MulDivRound
local _InternalTranslate = _InternalTranslate
local T = T

local function Translate(...)
	return _InternalTranslate(...)
end

local orig_MartianUniversity_GetTrainedRollover = MartianUniversity.GetTrainedRollover
function MartianUniversity:GetTrainedRollover(...)
  local texts = {orig_MartianUniversity_GetTrainedRollover(self,...)}
	local c = #texts
	c = c + 1
	texts[c] = "<newline><left>"

	for i = 1, #self.visitors do
		local shift = self.visitors[i]
		c = c + 1
		texts[c] = "<newline><left><color 119 212 255>Shift " .. i .. "</color>"

		for j = 1, #shift do
			local unit = shift[j]
      unit.training_points = unit.training_points or {}
			local units_points = unit.training_points[self.training_type] or 0

			c = c + 1
			texts[c] = Translate(T{unit:GetDisplayName()}) .. Translate("<right>")
				.. MulDivRound(units_points,100,self.evaluation_points) .. "%"
		end
	end

  return table_concat(texts, "<newline><left>")
end
