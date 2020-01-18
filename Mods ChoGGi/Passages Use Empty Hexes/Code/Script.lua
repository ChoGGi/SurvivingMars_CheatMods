-- See LICENSE for terms

-- TEST WITH NO ECM

local mod_ShowUseableGrids

-- fired when settings are changed/init
local function ModOptions()
	mod_ShowUseableGrids = CurrentModOptions:GetProperty("ShowUseableGrids")
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


local IsValid = IsValid
local IsPoint = IsPoint
local IsKindOf = IsKindOf
local GetDomeAtPoint = GetDomeAtPoint
local table_unpack = table.unpack

-- the only thing I care about is that a dome is at the current pos, the rest is up to the user
local function IsDomePoint(obj)
	if not obj then
		return
	end
	-- from construct controller or point
	obj = obj.current_points and obj.current_points[#obj.current_points] or obj
	-- if it's a point and a dome we're good (enough)
	if IsPoint(obj) and IsValid(GetDomeAtPoint(obj)) then
		return true
	end
end

-- like I said, if it's a dome then I'm happy
GridConstructionController.CanCompletePassage = IsDomePoint

-- Domes? DOMES!@!!!!
local clrNoModifier = const.clrNoModifier
local orig_Activate = GridConstructionController.Activate
function GridConstructionController:Activate(pt,...)
	-- override passage placement func to always be true for any dome spots (Activate happens when start of passage is placed)
	if self.mode == "passage_grid" and IsDomePoint(self) then
		self.current_status = clrNoModifier
	end
	return orig_Activate(self, pt,...)
end

local skip_reasons = {
	block_entrance = true,
	block_life_support = true,
	dome = true,
	roads = true,
}
-- this combined with the skip block reasons allows us to place in the life-support pipe area
local orig_block = SupplyGridElementHexStatus.blocked
local orig_PlacePassageLine = PlacePassageLine
function PlacePassageLine(...)
	-- 1 == clear
	SupplyGridElementHexStatus.blocked = 1
	local ret = {orig_PlacePassageLine(...)}
	SupplyGridElementHexStatus.blocked = orig_block
	return table_unpack(ret)
end

-- extend your massive passage from a DOME (or road)?
local orig_CanExtendFrom = GridConstructionController.CanExtendFrom
function GridConstructionController:CanExtendFrom(...)
	local res, reason, obj = orig_CanExtendFrom(self, ...)

	if self.mode == "passage_grid" and not res and skip_reasons[reason] then
		return true
	end

	return res, reason, obj
end

-- sites always have a parent_dome, so we have to check if the passage is on a HexInteriorShapes
-- (the only place that grid connections work with)
local HexAngleToDirection = HexAngleToDirection
local HexRotate = HexRotate
local WorldToHex = WorldToHex
local function TestEndPoint(passage, end_point)
	local dome = passage[end_point].parent_dome

	local cq, cr = WorldToHex(dome)
	local eq, er = WorldToHex(passage[end_point])
	local dir = HexAngleToDirection(dome:GetAngle())
	local shape = dome:GetInteriorShape()
	for i = 1, #shape do
		local sq, sr = shape[i]:xy()
		local q, r = HexRotate(sq, sr, dir)
		if eq == (cq + q) and er == (cr + r) then
			return true
		end
	end
end

function Passage:GetChoGGi_ValidDomes()
	-- passages that don't connect won't have a parent_dome
	if #self.elements > 0 then
		return IsValid(self.parent_dome)
			and T("<green>") .. T(8019, "Connected to building") .. T("</green>")
			or T("<red>") .. T(8773, "No dome") .. T("</red>")
	else
		if TestEndPoint(self, "start_el") and TestEndPoint(self, "end_el") then
			return T("<green>") .. T(8019, "Connected to building") .. T("</green>")
		end
		return T("<red>") .. T(8773, "No dome") .. T("</red>")
	end
end

-- add status to let people know if it"s a valid spot
function OnMsg.ClassesPostprocess()
	local xtemplate = XTemplates.ipPassage[1]
	if xtemplate.ChoGGi_PassageWarningAdded then
		return
	end
	xtemplate.ChoGGi_PassageWarningAdded = true

	local section = PlaceObj("XTemplateTemplate", {
		"__condition", function (_, context)
			return IsKindOf(context, "Passage")
		end,
		"__template", "InfopanelSection",
		"Title", T(10351, "Connect"),
	}, {
		PlaceObj("XTemplateTemplate", {
			"__template", "InfopanelText",
			"Text", T("<ChoGGi_ValidDomes>"),
		}),
	})
	-- add template to passage and construction site
	xtemplate[#xtemplate+1] = section
	local con = XTemplates.sectionConstructionSite[1][1]
	con[#con+1] = section
end

local orig_ConnectDomesWithPassage = ConnectDomesWithPassage
function ConnectDomesWithPassage(d1, d2, ...)
	if d1 and d2 then
		return orig_ConnectDomesWithPassage(d1, d2, ...)
	end
end

	local ObjHexShape_Clear = ChoGGi.ComFuncs.ObjHexShape_Clear

-- REMOVE NEXT LIBRARY UPDATE
	local SuspendPassEdits = SuspendPassEdits
	local ResumePassEdits = ResumePassEdits
	local RandomColourLimited = ChoGGi.ComFuncs.RandomColourLimited
	local IsValidXWin = ChoGGi.ComFuncs.IsValidXWin
	local HexToWorld = HexToWorld
	local tostring = tostring
	local DoneObject = DoneObject
	local table_clear = table.clear
	local dupe_list = {}
	local point = point
	local OHexSpot, XText
	local parent
	local FallbackOutline = FallbackOutline

	local function CleanInfoAttachDupes(list, cls)
		table_clear(dupe_list)
		SuspendPassEdits("ChoGGi.ComFuncs.CleanInfoAttachDupes")

		-- clean up dupes in order of older
		for i = 1, #list do
			local mark = list[i]
			if not cls or cls and mark:IsKindOf(cls) then

				local pos = tostring(mark:GetPos())
				local dupe = dupe_list[pos]
				if dupe then
					DoneObject(dupe)
				else
					dupe_list[pos] = mark
				end

			end
		end

		-- remove removed items
		list:Validate()
		ResumePassEdits("ChoGGi.ComFuncs.CleanInfoAttachDupes")
	end
	local function CleanInfoXwinDupes(list, cls)
		table_clear(dupe_list)

		-- clean up dupes in order of older
		for i = #list, 1, -1 do
			local mark = list[i]
			if not cls or cls and mark:IsKindOf(cls) then

				local pos = tostring(mark.FindModifier and mark:FindModifier("follow_obj").target:GetPos())
				if pos then
					local dupe = dupe_list[pos]
					if dupe then
						dupe:Close()
					else
						dupe_list[pos] = mark
					end
				end

			end
		end
	end

	-- function Dome:GenerateWalkablePoints() (mostly)
	local function BuildShape(obj, shape, depth_test, hex_pos, colour1, colour2, offset)
		local dir = HexAngleToDirection(obj:GetAngle())
		local cq, cr = WorldToHex(obj)

		local c = #obj.ChoGGi_shape_obj
		for i = 1, #shape do
			local sq, sr = shape[i]:xy()
			local q, r = HexRotate(sq, sr, dir)
			local pt = point(HexToWorld(cq + q, cr + r)):SetTerrainZ(offset)

			local hex = OHexSpot:new()
			hex:SetOpacity(25)
			hex:SetPos(pt)

			if colour1 then
				hex:SetColorModifier(colour1)
			end

			-- wall hax off
			if not depth_test then
				hex:SetNoDepthTest(true)
			end

			-- pos text
			if hex_pos then
				local text_obj = XText:new(nil, parent)
				if colour2 then
					text_obj:SetTextColor(colour2)
				end
				text_obj:FollowObj(hex)

				-- easy access
				hex.text_obj = text_obj
				text_obj:SetText(sq .. "," .. sr)
			end

			c = c + 1
			obj.ChoGGi_shape_obj[c] = hex
		end
	end
	local function ObjHexShape_Clear(obj)
		if type(obj) ~= "table" then
			return
		end
		SuspendPassEdits("ChoGGi.ComFuncs.ObjHexShape_Clear")
		if obj.ChoGGi_shape_obj then
			obj.ChoGGi_shape_obj:Destroy()
			obj.ChoGGi_shape_obj = nil
			if IsValidXWin(obj.ChoGGi_shape_obj_xwin) then
				obj.ChoGGi_shape_obj_xwin:Close()
				obj.ChoGGi_shape_obj_xwin = nil
			end
			return true
		end
		ResumePassEdits("ChoGGi.ComFuncs.ObjHexShape_Clear")
	end
	local ObjHexShape_Toggle = ChoGGi.ComFuncs.ObjHexShape_Toggle or function(obj, params)
		params = params or {shape = FallbackOutline}
		if not IsValid(obj) or not params.skip_return then
			return
		end
		if not params.skip_clear then
			if (ObjHexShape_Clear(obj) and not params.skip_return) then
				return
			end
		end

		obj.ChoGGi_shape_obj = obj.ChoGGi_shape_obj or objlist:new()
		params.colour1 = params.colour1 or RandomColourLimited()
		params.colour2 = params.colour2 or RandomColourLimited()
		params.offset = params.offset or 1

		if not OHexSpot then
			OHexSpot = ChoGGi_OHexSpot
		end
		if not XText then
			XText = ChoGGi_XText_Follow
		end

		if not IsValidXWin(obj.ChoGGi_shape_obj_xwin) then
			local parent = terminal.desktop
			local id = "ChoGGi_ObjHexShape_Toggle" .. obj.handle
			parent[id] = XWindow:new({Id = id}, parent)
			obj.ChoGGi_shape_obj_xwin = parent[id]
		end
		parent = obj.ChoGGi_shape_obj_xwin

		SuspendPassEdits("ChoGGi.ComFuncs.ObjHexShape_Toggle")
		BuildShape(
			obj,
			params.shape,
			params.depth_test,
			params.hex_pos,
			params.colour1,
			params.colour2,
			params.offset
		)
		ResumePassEdits("ChoGGi.ComFuncs.ObjHexShape_Toggle")
		if not params.skip_clear then
			CleanInfoXwinDupes(obj.ChoGGi_shape_obj_xwin)
			CleanInfoAttachDupes(obj.ChoGGi_shape_obj, "ChoGGi_OHexSpot")
		end

		return obj.ChoGGi_shape_obj
	end
-- REMOVE NEXT LIBRARY UPDATE

local grids_visible
local function ShowGrids()
	local HexInteriorShapes = HexInteriorShapes
	local IsValidEntity = IsValidEntity
	local params = {
		colour1 = -1,
		colour2 = -1,
		depth_test = false,
		hex_pos = false,
		offset = 1,
		skip_clear = false,
		skip_return = true,
	}

	local domes = UICity.labels.Dome or ""
	for i = 1, #domes do
		local dome = domes[i]
		local entity = dome:GetEntity()
		-- probably don't need to check, but eh
		if IsValidEntity(entity) then
			params.shape = HexInteriorShapes[entity]
			ObjHexShape_Toggle(dome, params)
		end
	end
	grids_visible = true
end

local function HideGrids()
	local domes = UICity.labels.Dome or ""
	for i = 1, #domes do
		ObjHexShape_Clear(domes[i])
	end
	grids_visible = false
end

local orig_GridConstructionDialog_Open = GridConstructionDialog.Open
function GridConstructionDialog:Open(...)
	if mod_ShowUseableGrids and self.mode_name == "passage_grid" then
		ShowGrids()
	end
	return orig_GridConstructionDialog_Open(self, ...)
end

local orig_GridConstructionDialog_Close = GridConstructionDialog.Close
function GridConstructionDialog:Close(...)
	if self.mode_name == "passage_grid" then
		HideGrids()
	end
	return orig_GridConstructionDialog_Close(self, ...)
end

-- add keybind for toggle
local Actions = ChoGGi.Temp.Actions
Actions[#Actions+1] = {ActionName = T(302535920011491, "Passages Use Empty Hexes"),
	ActionId = "ChoGGi.PassagesUseEmptyHexes.ToggleGrid",
	OnAction = function()
		if grids_visible then
			HideGrids()
		else
			ShowGrids()
		end
	end,
	ActionShortcut = "Numpad 6",
	replace_matching_id = true,
	ActionBindable = true,
}
