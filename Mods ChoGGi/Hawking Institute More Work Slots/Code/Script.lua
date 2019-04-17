-- See LICENSE for terms

function OnMsg.ClassesBuilt()
	local bt = BuildingTemplates.ScienceInstitute
	bt.max_workers = bt.max_workers * 2
end
