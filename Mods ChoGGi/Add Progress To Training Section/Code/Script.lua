-- See LICENSE for terms

local table_concat = table.concat
local MulDivRound = MulDivRound
local T = T

local function UnitPoints(unit, self)
	unit.training_points = unit.training_points or {}
	return unit.training_points[self.training_type] or 0
end

local function GetPoints(self, text, skip, school)
	local MinAge_Adult = Colonist.MinAge_Adult

	local c = #text
	if not skip then
		c = c + 1
		text[c] = T("<newline><left>")
	end

	for i = 1, #self.visitors do
		local shift = self.visitors[i]
		c = c + 1
		text[c] = T("<newline><left><color 119 212 255>Shift ") .. i .. "</color>"

		for j = 1, #shift do
			local unit = shift[j]
			local unit_points = UnitPoints(unit, self)

			if school then
				c = c + 1
				text[c] = T(unit:GetDisplayName()) .. "<right>"
					.. T{302535920011385, "<str1> <percent(number1)>, <str2> <percent(number2)>",
						str1 = T(4779, "Adult"),
						number1 = MulDivRound(
							unit.age or 0,
							100,
							unit.MinAge_Adult or MinAge_Adult
						),
						-- 150 is from function School:OnTrainingCompleted(unit)
						str2 = T(9828, "Required"),
						number2 = MulDivRound(unit_points, 100, 150),
					}
			else
				c = c + 1
				text[c] = T(unit:GetDisplayName()) .. "<right>"
					.. T{9766, "<percent(number)>",
						number = MulDivRound(unit_points, 100, self.evaluation_points),
					}
			end
		end
	end
	return table_concat(text, "<newline><left>")
end

local orig_MartianUniversity_GetTrainedRollover = MartianUniversity.GetTrainedRollover
function MartianUniversity:GetTrainedRollover(...)
	local text = {orig_MartianUniversity_GetTrainedRollover(self, ...)}
	return GetPoints(self, text)
end

local orig_Sanatorium_GetTrainedRollover = Sanatorium.GetTrainedRollover
function Sanatorium:GetTrainedRollover(...)
	-- just in case the devs add rollovers to them
	if orig_Sanatorium_GetTrainedRollover then
		local text = {orig_Sanatorium_GetTrainedRollover(self, ...)}
		return GetPoints(self, text)
	end
	return GetPoints(self, {}, true)
end

local orig_School_GetTrainedRollover = School.GetTrainedRollover
function School:GetTrainedRollover(...)
	if orig_School_GetTrainedRollover then
		local text = {orig_School_GetTrainedRollover(self, ...)}
		return GetPoints(self, text)
	end
	return GetPoints(self, {}, true, true)
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

