-- See LICENSE for terms

-- stores list of tech dialog ui hexy things
local tech_list = {}
local count

-- local some globals
local vkEnter = const.vkEnter
local KbdShortcut = KbdShortcut
local T,_InternalTranslate = T,_InternalTranslate

local function Trans(id)
	return _InternalTranslate(id)
end

local function FilterTech(str)
	-- loop through the five cats
	for i = 1, count do
		local el = tech_list[i]
		if str == "" or el.str:find_lower(str) then
			-- only toggle vis if we need to
			if not el.vis then
				el.tech:SetVisible(true)
			end
			el.vis = true
		else
			if el.vis then
				el.tech:SetVisible(false)
			end
			el.vis = false
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
	FilterTech(input:GetText():lower())
	return XEdit.OnKbdKeyUp(input, vk, ...)
end

function OpenResearchDialog()
	local dlg = OpenDialog("ResearchDlg")
	CreateRealTimeThread(function()
		WaitMsg("OnRender")
		local left_side = dlg.idOverlayDlg.idActionBar.parent

		local area = XWindow:new({
			Id = "idFilterArea",
			Margins = box(0, 0, 0, 8),
			Dock = "bottom",
		}, left_side)

		local input = XEdit:new({
			Id = "idFilterBar",
			RolloverTemplate = "Rollover",
			RolloverTitle = "Info",
			RolloverText = [[Filter uses name, description, and id.
<color 0 200 0>Shift-Enter</color> to clear.]],
			Hint = [[Tech Filter]],
			TextStyle = "LogInTitle",
			OnKbdKeyUp = OnKbdKeyUp,
			OnKbdKeyDown = OnKbdKeyDown,
		}, area)

		-- attach to dialog
		area:SetParent(left_side)

		-- reset tech ui elements list
		table.iclear(tech_list)
		count = 0

		-- build a list of tech ui hexes now, instead of when filtering
		for i = 1, #dlg.idArea do
			local xwin = dlg.idArea[i]
			-- loop through tech list
			if xwin.idFieldTech then
				for j = 1, #xwin.idFieldTech do
					local t = xwin.idFieldTech[j]
					local c = t.context
					count = count + 1
					tech_list[count] = {
						-- stick all the strings into one for quicker searching (i use a _ so it doesn't combine strings to search)
						str = c.id:lower() .. "_" .. Trans(T(c.description,c)):lower() .. "_"
							.. Trans(T(c.display_name)):lower(),
						-- ui ref
						tech = t,
						-- fast check if vis
						vis = true,
					}
				end
			end
		end

	end)
end
