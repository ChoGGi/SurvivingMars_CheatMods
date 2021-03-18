-- See LICENSE for terms

local table = table
local Max = Max

local mod_GlobalDomeCount
local mod_RespectIncubator
local mod_BypassNoNurseries
local mod_UltimateNursery

-- fired when settings are changed/init
local function ModOptions()
	local options = CurrentModOptions
	mod_GlobalDomeCount = options:GetProperty("GlobalDomeCount")
	mod_RespectIncubator = options:GetProperty("RespectIncubator")
	mod_BypassNoNurseries = options:GetProperty("BypassNoNurseries")
	mod_UltimateNursery = options:GetProperty("UltimateNursery")
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

local Max = Max

local orig_SpawnChild = Dome.SpawnChild
function Dome:SpawnChild(...)
	-- hi Ski
	if mod_RespectIncubator and self.IncubatorReloc then
		return orig_SpawnChild(self, ...)
	end
	local city = self.city or UICity

	local class = mod_UltimateNursery and "UltimateNursery" or "Nursery"

	local objs_g = table.icopy(city.labels[class] or empty_table)
	if not mod_UltimateNursery then
		-- why make a label with all the nursery varients, when you can cause extra work for modders...
		table.append(objs_g, city.labels.LargeNursery or empty_table)
	end

	local objs

	-- check all nurseries or per-dome
	if mod_GlobalDomeCount then
		objs = objs_g
	else
		objs = table.icopy(self.labels[class] or empty_table)
		if not mod_UltimateNursery then
			table.append(objs, self.labels.LargeNursery or empty_table)
		end
	end

	local objs_count = #objs

	-- no nursery so abort
	if objs_count == 0 then
		-- If there's no nurseries at all and then send back orig func
		if not objs_g and mod_BypassNoNurseries then
			return orig_SpawnChild(self, ...)
		end
		return
	end

	-- cut down copy of function Dome:GetFreeLivingSpace()
	local used = 0
	local capacity = 0
	for i = 1, objs_count do
		local obj = objs[i]
		if not obj.destroyed then
			capacity = capacity + (obj.capacity - obj.closed)
			used = used + (#obj.colonists + #obj.reserved)
		end
	end
	local free_space = Max(0, capacity - used)

--~ 	print(free_space,ChoGGi.ComFuncs.RetName(self))

	-- fire up the babby factory
	if free_space > 0 then
		return orig_SpawnChild(self, ...)
	end
end
