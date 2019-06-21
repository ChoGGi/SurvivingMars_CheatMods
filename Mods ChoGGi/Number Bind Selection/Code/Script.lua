-- See LICENSE for terms

local options
local mod_SelectView

-- fired when settings are changed and new/load
local function ModOptions()
	mod_SelectView = options.SelectView
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_NumberBindSelection" then
		return
	end

	ModOptions()
end

-- selection groups (the actions need a string, so we might as well just store these as strings)
GlobalVar("g_ChoGGi_CtrlNumBinds", {["1"] = {},["2"] = {},["3"] = {}, ["4"] = {},
	["5"] = {},["6"] = {}, ["7"] = {},["8"] = {}, ["9"] = {}, ["0"] = {},
})

local table_find = table.find
local table_remove = table.remove
local table_icopy = table.icopy

local MsgPopup = ChoGGi.ComFuncs.MsgPopup

local function ShowMsg(msg, objs)
	if Mods.ChoGGi_Library.version > 70 then
		MsgPopup(
			msg, T(302535920011343, "Number Bind"),
			nil, {expiration = 3, objects = objs}
		)
	else
		MsgPopup(
			msg, T(302535920011343, "Number Bind"),
			nil, nil, objs
		)
	end
end

local function AddObjs(action)
	local num = action.ActionShortcut:sub(-1)
	local saved = g_ChoGGi_CtrlNumBinds[num]
	local saved_c = #saved

	local Selection = Selection
	local sel_c = #Selection
	for i = 1, sel_c do
		local sel = Selection[i]
		-- don't need to use handles, but all selection I care about uses them
		if sel.handle
			-- no point in storing Wrappers
			and not sel:IsKindOf("MultiSelectionWrapper")
			-- don't add if we already added it
			and not table_find(saved, "handle", sel.handle)
		then
			saved_c = saved_c + 1
			saved[saved_c] = sel
		end
	end

	ShowMsg(T{302535920011344,
		"Added <color yellow><amount></color> objs to <color green><bindnum></color>",
		amount = sel_c > 1 and sel_c-1 or 1,
		bindnum = num,
	}, Selection)
end

local function RemoveObjs(action)
	local num = action.ActionShortcut:sub(-1)
	local saved = g_ChoGGi_CtrlNumBinds[num]

	local Selection = Selection
	local sel_c = #Selection
	for i = 1, sel_c do
		local idx = table_find(saved, "handle", Selection[i].handle)
		if idx then
			table_remove(saved, idx)
		end
	end

	ShowMsg(T{302535920011345,
		"Removed <color yellow><amount></color> objs from <color green><bindnum></color>",
		amount = sel_c > 1 and sel_c-1 or 1,
		bindnum = num,
	}, Selection)
end

local function ActivateSelection(action)
	local saved = g_ChoGGi_CtrlNumBinds[action.ActionShortcut]
	if not saved[1] then
		return
	end

	SelectObj(MultiSelectionWrapper:new{
		-- gotta be something
		selection_class = saved[1].class,
		-- we have to copy otherwise it'll mess with our saved
		objects = table_icopy(saved),
	})

	if mod_SelectView then
		CreateRealTimeThread(function()
			WaitMsg("OnRender")
			ViewAndSelectObject(Selection[1])
		end)
	end
end

local Actions = ChoGGi.Temp.Actions
local c = #Actions

for i = 0, 9 do
	-- add objs
	c = c + 1
	local id = "ChoGGi_NumBinds.Ctrl.Num" .. i
	Actions[c] = {ActionName = id,
		ActionId = id,
		OnAction = AddObjs,
		ActionShortcut = "Ctrl-" .. i,
		replace_matching_id = true,
		IgnoreRepeated = true,
	}
	-- remove
	c = c + 1
	id = "ChoGGi_NumBinds.Shift.Num" .. i
	Actions[c] = {ActionName = id,
		ActionId = id,
		OnAction = RemoveObjs,
		ActionShortcut = "Shift-" .. i,
		replace_matching_id = true,
		IgnoreRepeated = true,
	}
	-- activate
	c = c + 1
	id = "ChoGGi_NumBinds.Num" .. i
	Actions[c] = {ActionName = id,
		ActionId = id,
		OnAction = ActivateSelection,
		-- can't use numbers
		ActionShortcut = i .. "",
		replace_matching_id = true,
		IgnoreRepeated = true,
	}
end



-- copy pasta from Lua\MultiSelection.lua
-- we add objs of different classes so we need to check for methods



function MultiSelectionWrapper:ResolveObjAt(...)
	if not self:IsClassSupported("Unit") then return end
	--return the first result found
	for _,subobj in ipairs(self.objects) do
		-- the "fix", I suppose I could also add an empty_func to the objs, but that feels ugly
		if subobj.ResolveObjAt then
			local result = subobj:ResolveObjAt(...)
			if result then
				return result
			end
		end
	end
end

function MultiSelectionWrapper:CheckAny(method, ...)
--~ 	assert(g_Classes[self.selection_class]:HasMember(method),
--~ 		string.format("Base class %s doesn't have the member %s", self.selection_class, method))
	for _,subobj in ipairs(self.objects) do
		-- the "fix"
		if subobj[method] then
			local result, r2, r3, r4, r5 = subobj[method](subobj, ...)
			if result then return result, r2, r3, r4, r5 end
		end
	end
	return false
end

local orig_MultiSelectionWrapper_Broadcast = MultiSelectionWrapper.Broadcast
function MultiSelectionWrapper:Broadcast(method, ...)
	if type(method) == "string" then
--~ 		assert(g_Classes[self.selection_class]:HasMember(method),
--~ 			string.format("Base class %s doesn't have the member %s", self.selection_class, method))
		for _,subobj in ipairs(self.objects) do
			-- the "fix"
			if subobj[method] then
				subobj[method](subobj, ...)
			end
		end
	else
		return orig_MultiSelectionWrapper_Broadcast(self, method, ...)
	end
end

function MultiSelectionWrapper:Union(method, comparison_key, ...)
--~ 	assert(g_Classes[self.selection_class]:HasMember(method),
--~ 		string.format("Base class %s doesn't have the member %s", self.selection_class, method))
	local values = { }
	for _,subobj in ipairs(self.objects) do
		-- the "fix"
		if subobj[method] then
			local result = subobj[method](subobj, ...)
			if result then
				for _,v in ipairs(result) do
					if comparison_key then
						if not table.find(values, comparison_key, v[comparison_key]) then
							table.insert(values, v)
						end
					else
						--optimized when there is no comparison key
						values[v] = true
					end
				end
			end
		end
	end

	return comparison_key and values or table.keys(values)
end
