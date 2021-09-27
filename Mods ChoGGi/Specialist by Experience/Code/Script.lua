-- See LICENSE for terms

local mod_IgnoreSpec
local mod_SolsToTrain

-- fired when settings are changed/init
local function ModOptions()
	mod_IgnoreSpec = CurrentModOptions:GetProperty("IgnoreSpec")
	mod_SolsToTrain = CurrentModOptions:GetProperty("SolsToTrain")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

local ChoOrig_Workplace_AddWorker = Workplace.AddWorker
function Workplace:AddWorker(worker, shift)
	-- Ignore workplaces without a spec
	if self.specialist ~= "none" then
		-- add table to store handles of workers with starting Sol
		if not self.ChoGGi_SpecByExp then
			self.ChoGGi_SpecByExp = {}
		end
		-- they shouldn't have a table already, but best to check I suppose
		-- and add every worker even if they have a spec, since we have the option for any spec
		if not self.ChoGGi_SpecByExp[worker.handle] then
			self.ChoGGi_SpecByExp[worker.handle] = {
				started_on = UICity.day,
				obj = worker,
			}
		end
	end
	return ChoOrig_Workplace_AddWorker(self, worker, shift)
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

local ChoOrig_Workplace_RemoveWorker = Workplace.RemoveWorker
function Workplace:RemoveWorker(worker)
	FiredWorker(self, worker)
	return ChoOrig_Workplace_RemoveWorker(self, worker)
end
local ChoOrig_Workplace_FireWorker = Workplace.FireWorker
function Workplace:FireWorker(worker)
	FiredWorker(self, worker)
	return ChoOrig_Workplace_FireWorker(self, worker)
end

-- everyone is fired so empty table
local ChoOrig_Workplace_KickAllWorkers = Workplace.KickAllWorkers
function Workplace:KickAllWorkers()
	if self.specialist ~= "none" then
		self.ChoGGi_SpecByExp = {}
	end
	return ChoOrig_Workplace_KickAllWorkers(self)
end

-- loop through all the workplaces, and check for anyone who worked over 24 Sols
local pairs, IsValid = pairs, IsValid

-- for testing
--~ function OnMsg.NewHour()
--~ 	mod_SolsToTrain = 1
--~ 	local sol = UICity.day

function OnMsg.NewDay(sol) -- NewSol...
	local workplaces = UICity.labels.Workplace or ""
	for i = 1, #workplaces do
		local work = workplaces[i]
		-- only workplaces with my table
		if work.ChoGGi_SpecByExp then
			for handle, c_table in pairs(work.ChoGGi_SpecByExp) do
				local obj = c_table.obj
				-- just in case
				if IsValid(obj) or not obj.dying then
					-- skip units that already have the spec, only allow spec=none or if mod option then any spec, then check if worked long enough
					if not obj.traits[work.specialist] and (obj.specialist == "none" or mod_IgnoreSpec)
						and (sol - c_table.started_on) >= mod_SolsToTrain
					then
						if obj.specialist ~= "none" then
							obj:RemoveTrait(obj.specialist)
						end
						obj:AddTrait(work.specialist)
--~ 						obj:SetSpecialization(work.specialist)
--~ 						-- "fix" for picard
--~ 						obj:SetSpecialization(work.specialist)
						-- needed to remove NonSpecialistPerformancePenalty
						obj:ChangeWorkplacePerformance()
					end
				else
					-- If not valid then might as well remove it
					work.ChoGGi_SpecByExp[handle] = nil
				end

			end

		end
	end

end

GlobalVar("g_ChoGGi_SpecByExp_loadgame", false)

function OnMsg.LoadGame()
	-- only fire once or it'll keep resetting everyone
	if g_ChoGGi_SpecByExp_loadgame then
		return
	end

	-- update any buildings with existing workers
	local workplaces = UICity.labels.Workplace or ""
	for i = 1, #workplaces do
		local workplace = workplaces[i]
		if workplace.specialist ~= "none" and not workplace.ChoGGi_SpecByExp then
			workplace.ChoGGi_SpecByExp = {}
			for j = 1,  #workplace.workers do
				local workers = workplace.workers[j]
				for k = 1, #workers do
					local worker = workers[k]
					if not workplace.ChoGGi_SpecByExp[worker.handle] then
						workplace.ChoGGi_SpecByExp[worker.handle] = {
							started_on = UICity.day,
							obj = worker,
						}
					end
				end
			end
		end
	end -- for the fords

	g_ChoGGi_SpecByExp_loadgame = true
end
