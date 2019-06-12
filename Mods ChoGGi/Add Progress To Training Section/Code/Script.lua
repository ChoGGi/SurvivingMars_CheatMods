-- See LICENSE for terms

local table_concat = table.concat
local MulDivRound = MulDivRound
local _InternalTranslate = _InternalTranslate
local T = T

local function GetPoints(self, text, skip)
	local c = #text
	if not skip then
		c = c + 1
		text[c] = "<newline><left>"
	end
	for i = 1, #self.visitors do
		local shift = self.visitors[i]
		c = c + 1
		text[c] = "<newline><left><color 119 212 255>Shift " .. i .. "</color>"

		for j = 1, #shift do
			local unit = shift[j]
			unit.training_points = unit.training_points or {}
			local units_points = unit.training_points[self.training_type] or 0

			c = c + 1
			text[c] = _InternalTranslate(T{unit:GetDisplayName()})
				.. _InternalTranslate("<right>")
				.. MulDivRound(units_points, 100, self.evaluation_points) .. "%"
		end
	end
	return table_concat(text, "<newline><left>")
end

local orig_MartianUniversity_GetTrainedRollover = MartianUniversity.GetTrainedRollover
function MartianUniversity:GetTrainedRollover(...)
	local text = {orig_MartianUniversity_GetTrainedRollover(self, ...)}
	return GetPoints(self, text)
end

function Sanatorium:GetTrainedRollover()
	return GetPoints(self, {}, true)
end

function School:GetTrainedRollover()
	local text = {}
	local c = 0

	for i = 1, #self.visitors do
		local shift = self.visitors[i]
		c = c + 1
		text[c] = "<newline><left><color 119 212 255>Shift " .. i .. "</color>"

		for j = 1, #shift do
			local unit = shift[j]

			unit.training_points = unit.training_points or {}
			local units_points = unit.training_points[self.training_type] or 0

			c = c + 1
			text[c] = _InternalTranslate(T{unit:GetDisplayName()})
				.. _InternalTranslate("<right>")
				.. MulDivRound(
					unit.age or 0,
					100,
					unit.MinAge_Adult or Colonist.MinAge_Adult
				)
				-- 150 is from function School:OnTrainingCompleted(unit)
				.. "% (" .. MulDivRound(units_points, 100, 150) .. "%)"
		end
	end
	return table_concat(text, "<newline><left>")
end

-- add a rollover to the lifetime area
function OnMsg.ClassesPostprocess()
	local xt = XTemplates.sectionTraits[1]
	local idx = table.find(xt, "class", "XTemplateWindow")
	if not idx then
		return
	end
	xt = xt[idx]

	if not xt.ChoGGi_AddProgressToTrainingSection then
		xt.ChoGGi_AddProgressToTrainingSection = true

		-- update each template (School/Sanatorium)
		for i = 1, #xt do
			local item = xt[i]
			item.RolloverTemplate = "InfopanelSectionRollover"
			item.RolloverText = T(7977, "<TrainedRollover>")
			item.RolloverTitle = T(126824585435, "Training Program")
		end
	end
end
