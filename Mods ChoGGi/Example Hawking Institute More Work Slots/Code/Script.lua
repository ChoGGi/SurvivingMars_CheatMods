-- See LICENSE for terms

function OnMsg.ClassesPostprocess()
	local bt = BuildingTemplates.ScienceInstitute
	bt.max_workers = bt.max_workers * 2
end
