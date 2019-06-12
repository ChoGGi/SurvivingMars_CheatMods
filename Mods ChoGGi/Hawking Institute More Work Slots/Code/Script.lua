-- See LICENSE for terms

local value
function OnMsg.ClassesPostprocess()
	if not value then
		local bt = BuildingTemplates.ScienceInstitute
		value = bt.max_workers * 2
		bt.max_workers = value
	end
end
