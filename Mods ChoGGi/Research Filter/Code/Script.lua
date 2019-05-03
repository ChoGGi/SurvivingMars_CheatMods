-- See LICENSE for terms

-- stores list of tech dialog ui hexy things
local tech_list = {}
local count

-- local some globals
local vkEnter = const.vkEnter
local KbdShortcut = KbdShortcut
local T,_InternalTranslate = T,_InternalTranslate

local function Trans(userdata)
	return _InternalTranslate(userdata)
end

local function FilterTech(str)
	-- loop through the five cats
	for i = 1, count do
		local item = tech_list[i]
		if str == "" or item.str:find_lower(str) then
			-- only toggle vis if we need to
			if not item.vis then
				item.tech:SetVisible(true)
			end
			item.vis = true
		else
			if item.vis then
				item.tech:SetVisible(false)
			end
			item.vis = false
		end
	end
end

-- it's quicker to the user
local function OnKbdKeyDown(input,vk, ...)
	if KbdShortcut(vk) == "Shift-Enter" then
		input:SetText("")
		FilterTech("")
		return "break"
	end
	return XEdit.OnKbdKeyDown(input, vk, ...)
end

local function OnKbdKeyUp(input,vk, ...)
	FilterTech(input:GetText())
	return XEdit.OnKbdKeyUp(input, vk, ...)
end

local orig_OpenDialog = OpenDialog
function OpenDialog(dlg_str,...)
	local dlg = orig_OpenDialog(dlg_str,...)
	if dlg_str == "ResearchDlg" then
		CreateRealTimeThread(function()
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
				RolloverTitle = Trans(T(126095410863,"Info")),
				RolloverText = [[Filter checks name, description, and id.
	<color 0 200 0>Shift-Enter</color> to clear.]],
				Hint = [[Tech Filter]],
				TextStyle = "LogInTitle",
				OnKbdKeyUp = OnKbdKeyUp,
				OnKbdKeyDown = OnKbdKeyDown,
			}, area)

			input:SetFocus()

			-- attach to dialog
			area:SetParent(left_side)

			-- reset tech ui elements list (we need the newly created objs)
			table.iclear(tech_list)
			count = 0

			-- build a list of tech ui hexes which will be used for filtering (we just build it once per session, since new tech objs aren't added mid-game)
			for i = 1, #dlg.idArea do
				local techfield = dlg.idArea[i].idFieldTech
				-- there's some other ui elements without a idFieldTech we want to skip
				if techfield then
					-- loop through tech list
					for j = 1, #techfield do
						local tech = techfield[j]
						local c = tech.context
						count = count + 1
						tech_list[count] = {
							-- stick all the strings into one for quicker searching (i use a \0 (null char) so the strings are separate)
							str = c.id .. "\t" .. Trans(T{c.description,c})
								.. "\t" .. Trans(T(c.display_name)),
							-- ui ref
							tech = tech,
							-- fast check if vis
							vis = true,
						}
					end
				end
			end

		end)
	end
	return dlg
end
