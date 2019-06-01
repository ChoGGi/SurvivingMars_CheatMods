-- See LICENSE for terms

local mod_id = "ChoGGi_NurseryLimitBirthingToSpots"
local mod = Mods[mod_id]

local mod_GlobalDomeCount = mod.options and mod.options.GlobalDomeCount or false
local mod_BypassNoNurseries = mod.options and mod.options.BypassNoNurseries or false
local mod_RespectIncubator = mod.options and mod.options.RespectIncubator or false

local function ModOptions()
	mod_GlobalDomeCount = mod.options.GlobalDomeCount
	mod_BypassNoNurseries = mod.options.BypassNoNurseries
	mod_RespectIncubator = mod.options.RespectIncubator
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= mod_id then
		return
	end

	ModOptions()
end

-- for some reason mod options aren't retrieved before this script is loaded...
OnMsg.CityStart = ModOptions
OnMsg.LoadGame = ModOptions

local Max = Max

local orig_SpawnChild = Dome.SpawnChild
function Dome:SpawnChild(...)
	-- hi Ski
	if mod_RespectIncubator and self.IncubatorReloc then
		return orig_SpawnChild(self, ...)
	end

	local objs_g = (self.city or UICity).labels.Nursery
	local objs

	-- not global so use dome count
	if mod_GlobalDomeCount then
		objs = objs_g
	else
		objs = self.labels.Nursery
	end

	-- no nursery so abort
	if not objs then
		-- if there's no nurseries at all and then send back orig func
		if not objs_g and mod_BypassNoNurseries then
			return orig_SpawnChild(self, ...)
		end
		return
	end

	-- cut down copy of function Dome:GetFreeLivingSpace()
	local used = 0
	local capacity = 0
	for i = 1, #objs do
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
