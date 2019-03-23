-- modconfig
SpecialistByExperience = {
	IgnoreSpec = false,
	SolsToTrain = 25,
}

local orig_Workplace_AddWorker = Workplace.AddWorker
function Workplace:AddWorker(worker, shift)
  -- ignore workplaces without a spec
  if self.specialist ~= "none" then
    -- add table to store handles of workers with starting Sol
    if not self.ChoGGi_SpecByExp then
      self.ChoGGi_SpecByExp = {}
    end
    -- they shouldn't have a table already, but best to check I suppose
    -- and add every worker even if they have a spec, since we have the modconfig option for any spec
    if not self.ChoGGi_SpecByExp[worker.handle] then
      self.ChoGGi_SpecByExp[worker.handle] = {
        started_on = UICity.day,
        obj = worker,
      }
    end
  end
  return orig_Workplace_AddWorker(self, worker, shift)
end

-- checks for table then clears out worker table
local function FiredWorker(workplace, worker)
  if workplace.specialist == "none" then
    return
  end
  -- loaded game and workplace that hasn't hired anyone yet
  if not workplace.ChoGGi_SpecByExp then
    workplace.ChoGGi_SpecByExp = {}
  end
  -- quitter
  if workplace.ChoGGi_SpecByExp[worker.handle] then
    workplace.ChoGGi_SpecByExp[worker.handle] = nil
  end
end

local orig_Workplace_RemoveWorker = Workplace.RemoveWorker
function Workplace:RemoveWorker(worker)
  FiredWorker(self,worker)
  return orig_Workplace_RemoveWorker(self, worker)
end
local orig_Workplace_FireWorker = Workplace.FireWorker
function Workplace:FireWorker(worker)
  FiredWorker(self,worker)
  return orig_Workplace_FireWorker(self, worker)
end

-- everyone is fired so empty table
local orig_Workplace_KickAllWorkers = Workplace.KickAllWorkers
function Workplace:KickAllWorkers()
  if self.specialist ~= "none" then
    self.ChoGGi_SpecByExp = {}
  end
  return orig_Workplace_KickAllWorkers(self)
end

-- loop through all the workplaces, and check for anyone who worked over 24 Sols
local pairs,IsValid = pairs,IsValid
function OnMsg.NewDay(sol) -- NewSol...
  local ignore_spec = SpecialistByExperience.IgnoreSpec
  local sols_to_train = SpecialistByExperience.SolsToTrain
  local g_Classes = g_Classes

  local workplaces = UICity.labels.Workplace or ""
  for i = 1, #workplaces do
    local work = workplaces[i]
    -- only workplaces with my table
    if work.ChoGGi_SpecByExp then
      for handle,c_table in pairs(work.ChoGGi_SpecByExp) do

        -- just in case
        if IsValid(c_table.obj) or not c_table.obj.dying then
          -- only allow spec=none or if modconfig then any spec, then check if worked long enough
          if (c_table.obj.specialist == "none" or ignore_spec) and (sol - c_table.started_on) >= sols_to_train then
						c_table.obj:SetSpecialization(work.specialist)
						-- needed to remove NonSpecialistPerformancePenalty
						c_table.obj:ChangeWorkplacePerformance()
          end
        else
          -- if not valid then remove
          work.ChoGGi_SpecByExp[handle] = nil
        end

      end
    end
  end

end -- OnMsg
