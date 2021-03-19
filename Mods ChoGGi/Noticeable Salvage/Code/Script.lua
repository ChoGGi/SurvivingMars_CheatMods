-- See LICENSE for terms

--- Remove 9.5
local table_clear = table.clear
local table_find = table.find
local table_remove = table.remove
local IsValid = IsValid
local pairs = pairs
local objlist = objlist
local attach_dupes = {}
local attaches_list, attaches_count
local parent_obj
local skip = {"ExplorableObject", "TerrainDeposit", "DroneBase", "Dome"}

local function AddAttaches(obj, only_include)
	for _, a in pairs(obj) do
		if not attach_dupes[a] and IsValid(a) and a ~= parent_obj
			and (not only_include or only_include and a:IsKindOf(only_include))
			and not a:IsKindOfClasses(skip)
		then
			attach_dupes[a] = true
			attaches_count = attaches_count + 1
			attaches_list[attaches_count] = a
		end
	end
end

local mark
local function ForEach(a, parent_cls, only_include)
	if not attach_dupes[a] and a ~= parent_obj
		and (not only_include or only_include and a:IsKindOf(only_include))
		and not a:IsKindOfClasses(skip)
	then
		attach_dupes[a] = true
		attaches_count = attaches_count + 1
		attaches_list[attaches_count] = a
		if mark then
			a.ChoGGi_Marked_Attach = parent_cls
		end
		-- add level limit?
		if a.ForEachAttach then
			a:ForEachAttach(ForEach, a.class)
		end
	end
end

--- Remove 9.5



local demo_colour = black
local default_colour = 6579300

--~ local GetAllAttaches = ChoGGi.ComFuncs.GetAllAttaches
local GetAllAttaches

function OnMsg.ModsReloaded()
	local ModsLoaded = ModsLoaded
	-- no need to check for dependencies
	if ModsLoaded[table.find(ModsLoaded, "id", "ChoGGi_Library")].version > 9.4 then
		GetAllAttaches = ChoGGi.ComFuncs.GetAllAttaches
	else
		GetAllAttaches = function(obj, mark_attaches, only_include, safe)
			mark = mark_attaches

			table_clear(attach_dupes)
			if not IsValid(obj) then
				-- I always use #attach_list so "" is fine by me
				return ""
			end

			-- we use objlist instead of {} for delete all button in examine
			attaches_list = objlist:new()
			attaches_count = 0
			parent_obj = obj

			-- add regular attachments
			if obj.ForEachAttach then
				obj:ForEachAttach(ForEach, obj.class, only_include)
			end

			if safe then
				local attaches = obj:GetAttaches() or ""
				for i = 1, #attaches do
					local a = attaches[i]
					ForEach(a, a.class, only_include)
				end

			else
				-- add any non-attached attaches (stuff that's kinda attached, like the concrete arm thing)
				AddAttaches(obj, only_include)
				-- and the anim_obj added in gagarin
				if IsValid(obj.anim_obj) then
					AddAttaches(obj.anim_obj, only_include)
				end
				-- pastures
				if obj.current_herd then
					AddAttaches(obj.current_herd, only_include)
				end
			end

			-- remove original obj if it's in the list
			local idx = table_find(attaches_list, obj)
			if idx then
				table_remove(attaches_list, idx)
			end

			return attaches_list

		end
	end
end

local skips = {"GridTileWater", "GridTile", "BuildingSign"}

local function ChangeColour(obj, toggle)
	if obj:IsKindOf("Dome") then
		return
	end

	-- save orig colour
	if not obj.ChoGGi_ColourDemo then
		obj.ChoGGi_ColourDemo = obj:GetColorModifier()
	end

	if toggle then
		obj:SetColorModifier(demo_colour)
	else
		obj:SetColorModifier(obj.ChoGGi_ColourDemo or default_colour)
	end

	local attaches = GetAllAttaches(obj, nil, nil, true)
	for i = 1, #attaches do
		local a = attaches[i]
		if not a:IsKindOfClasses(skips) then
			if not a.ChoGGi_ColourDemo then
				a.ChoGGi_ColourDemo = a:GetColorModifier()
			end

			if toggle then
				a:SetColorModifier(demo_colour)
			else
				a:SetColorModifier(a.ChoGGi_ColourDemo or default_colour)
			end

		end
	end
end

-- for buildings to be demo'd
local function ChangeDemo(obj)
	WaitMsg("OnRender")
	ChangeColour(obj, obj.demolishing)
end

-- for buildings to be destroyed
local function ChangeRemove(obj, toggle)
	WaitMsg("OnRender")
	ChangeColour(obj, toggle)
end

local orig_ToggleDemolish = Demolishable.ToggleDemolish
function Demolishable:ToggleDemolish(...)
	CreateRealTimeThread(ChangeDemo, self)
	return orig_ToggleDemolish(self, ...)
end

local orig_DestroyedClear = Building.DestroyedClear
function Building:DestroyedClear(...)
	CreateRealTimeThread(ChangeRemove, self, true)
	return orig_DestroyedClear(self, ...)
end

local orig_CancelDestroyedClear = Building.CancelDestroyedClear
function Building:CancelDestroyedClear(...)
	CreateRealTimeThread(ChangeRemove, self, false)
	return orig_CancelDestroyedClear(self, ...)
end


-- reset on demo
function OnMsg.Demolished(obj)
	if not obj.ChoGGi_ColourDemo then
		return
	end

	obj:SetColorModifier(obj.ChoGGi_ColourDemo or default_colour)
	obj.ChoGGi_ColourDemo = nil

	local attaches = GetAllAttaches(obj, nil, nil, true)
	for i = 1, #attaches do
		local a = attaches[i]
		a:SetColorModifier(a.ChoGGi_ColourDemo or default_colour)
	end

end
