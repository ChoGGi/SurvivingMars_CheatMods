-- See LICENSE for terms

local RetName = ChoGGi.ComFuncs.RetName

local ChoOrig_Workplace_AddWorker = Workplace.AddWorker
function Workplace:AddWorker(worker, ...)
	-- already named, so abort
	if self.ChoGGi_AddedNamedWorkplace then
		return ChoOrig_Workplace_AddWorker(self, worker, ...)
	end

	local name = worker.name

	self.display_name = T{302535920011335,"<name>'s <workplace>, est. <sol>",
		name = type(name) == "table"
			-- first name for eng, or "last" name for rtl (assuming that's how the devs did them)
			and name[config.TextWrapAnywhere and #name or 1]
			-- user added a custom name? don't bother trying to get a first name and just use it as is
			or name,
		workplace = RetName(self) or "Thppt!",
		sol = (self.city or UICity).day,
	}

	self.ChoGGi_AddedNamedWorkplace = true

	return ChoOrig_Workplace_AddWorker(self, worker, ...)
end
