-- See LICENSE for terms

local mod_id = "ChoGGi_NurseryLimitBirthingToSpots"
local mod = Mods[mod_id]

local mod_GlobalDomeCount = mod.options and mod.options.GlobalDomeCount or false

local function ModOptions()
	mod_GlobalDomeCount = mod.options.GlobalDomeCount
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

	local objs
	if mod_GlobalDomeCount then
		objs = (self.city or UICity).labels.Nursery
	else
		objs = self.labels.Nursery
	end

	-- no Nursery so abort
	if not objs then
		return
	end

	-- cropped down copy of function Dome:GetFreeLivingSpace()
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
