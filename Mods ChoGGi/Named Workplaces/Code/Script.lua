-- See LICENSE for terms

local orig_AddWorker = Workplace.AddWorker
function Workplace:AddWorker(worker, ...)
	if not self.ChoGGi_AddedNamedWorkplace then
		local name = worker.name
		self.name = T{302535920011335,"<name>'s <workplace>, est. <sol>",
			name = type(name) == "table"
				-- first name for eng, or "last" name for rtl (assuming that's how the devs did them)
				and name[config.TextWrapAnywhere and #name or 1]
				-- user added a custom name? don't bother trying to get a first name and just use it as is
				or name,
			workplace = self.display_name or "Thppt!",
			sol = (self.city or UICity).day,
		}
		self.ChoGGi_AddedNamedWorkplace = true
	end
	return orig_AddWorker(self, worker, ...)
end
