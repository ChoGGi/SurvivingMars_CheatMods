-- See LICENSE for terms

local mod_id = "ChoGGi_ResearchFilter"
local mod = Mods[mod_id]

local mod_HideCompleted = mod.options and mod.options.HideCompleted or false

local function ModOptions()
	mod_HideCompleted = mod.options.HideCompleted
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

-- stores list of tech dialog ui hexy things
local tech_list = {}
local count = 0

-- local some globals
local table_find = table.find
local KbdShortcut = KbdShortcut
local IsTechResearched = IsTechResearched
local CreateRealTimeThread = CreateRealTimeThread
local T, _InternalTranslate = T, _InternalTranslate

local function FilterTech(str)
	-- loop through the stored tech cats
	for i = 1, count do
		local item = tech_list[i]
		if str == "" or item.str:find_lower(str) then
			-- only toggle vis if we need to
			if not item.vis then
				-- make sure option is off
				if not (mod_HideCompleted and IsTechResearched(item.tech.context[1].id)) then
					item.tech:SetVisible(true)
					item.vis = true
				end
			end
		else
			if item.vis then
				item.tech:SetVisible(false)
				item.vis = false
			end
		end
	end
end

-- it's quicker to the user
local function OnKbdKeyDown(input, vk, ...)
	if KbdShortcut(vk) == "Shift-Enter" then
		input:SetText("")
		FilterTech("")
		return "break"
	end
	return XEdit.OnKbdKeyDown(input, vk, ...)
end

local function OnKbdKeyUp(input, vk, ...)
	FilterTech(input:GetText())
	return XEdit.OnKbdKeyUp(input, vk, ...)
end

local function EditDlg(dlg)
	WaitMsg("OnRender")
	local left_side = dlg.idActionBar.parent

	local area = XWindow:new({
		Id = "idFilterArea",
		Margins = box(0, 0, 0, 8),
		Dock = "bottom",
	}, left_side)

	local input = XEdit:new({
		Id = "idFilterBar",
		RolloverTemplate = "Rollover",
		RolloverTitle = T(126095410863, "Info"),
		RolloverText = T(0,[[Filter checks name, description, and id.
<color 0 200 0>Shift-Enter</color> to clear.]]),
		Hint = [[Tech Filter]],
		TextStyle = "LogInTitle",
		OnKbdKeyUp = OnKbdKeyUp,
		OnKbdKeyDown = OnKbdKeyDown,
	}, area)

	input:SetFocus()

	-- attach to dialog
	area:SetParent(left_side)

	count = 0
	-- if it's the first time opening research then build a list of name/desc to search
	local first_time = #tech_list

	-- build a list of tech ui hexes which will be used for filtering (we just build it once per session, since new tech objs aren't added mid-game)
	for i = 1, #dlg.idArea do
		local techfield = dlg.idArea[i].idFieldTech
		-- there's some other ui elements without a idFieldTech we want to skip
		if techfield then
			-- loop through tech list
			for j = 1, #techfield do
				local tech = techfield[j]
				local c = tech.context[1]
				count = count + 1

				if mod_HideCompleted then
					tech.FoldWhenHidden = true
					if IsTechResearched(c.id) then
						tech:SetVisible(false)
					end
				else
					tech.FoldWhenHidden = false
					tech:SetVisible(true)
				end

				if first_time == 0 then
					tech_list[count] = {
						id = c.id,
						-- stick all the strings into one for quicker searching (i use a \0 (null char) so the strings are separate)
						str = c.id .. "\t" .. _InternalTranslate(T{c.description, c})
							.. "\t" .. _InternalTranslate(T(c.display_name)),
						-- ui ref
						tech = tech,
						-- fast check if vis
						vis = true,
					}
				else
					-- could just use tech_list[count], but just in case? (it's still quicker than translating each time I suppose)
					local item = tech_list[table_find(tech_list, "id", c.id)]
					if item then
						item.tech = tech
						item.vis = true
					end
				end

			end
		end
	end
end

local orig_OpenDialog = OpenDialog
function OpenDialog(dlg_str, ...)
	local dlg = orig_OpenDialog(dlg_str, ...)
	if dlg_str == "ResearchDlg" then
		CreateRealTimeThread(EditDlg, dlg)
	end
	return dlg
end
