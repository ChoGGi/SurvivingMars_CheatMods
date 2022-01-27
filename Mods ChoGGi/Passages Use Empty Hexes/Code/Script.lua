-- See LICENSE for terms

-- TEST WITH NO ECM

local table = table
local IsValid = IsValid
local IsPoint = IsPoint
local IsKindOf = IsKindOf
local GetDomeAtPoint = GetDomeAtPoint
local HexAngleToDirection = HexAngleToDirection
local HexRotate = HexRotate
local WorldToHex = WorldToHex
local GetObjectHexGrid = GetObjectHexGrid
local ObjHexShape_Clear = ChoGGi.ComFuncs.ObjHexShape_Clear
local ObjHexShape_Toggle = ChoGGi.ComFuncs.ObjHexShape_Toggle
local DeleteObject = ChoGGi.ComFuncs.DeleteObject
local CollisionsObject_Toggle = ChoGGi.ComFuncs.CollisionsObject_Toggle

local mod_ShowUseableGrids

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_ShowUseableGrids = CurrentModOptions:GetProperty("ShowUseableGrids")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- the only thing I care about is that a dome is at the current pos, the rest is up to the user
local function IsDomePoint(obj)
	if not obj then
		return
	end
	-- from construct controller or point
	obj = obj.current_points and obj.current_points[#obj.current_points] or obj
	-- If it's a point and a dome we're good (enough)
	if IsPoint(obj) and IsValid(GetDomeAtPoint(GetObjectHexGrid(obj.city or UICity), obj)) then
		return true
	end
end

-- like I said, if it's a dome then I'm happy
GridConstructionController.CanCompletePassage = IsDomePoint

-- Domes? DOMES!@!!!!
local clrNoModifier = const.clrNoModifier
local ChoOrig_Activate = GridConstructionController.Activate
function GridConstructionController:Activate(pt,...)
	-- override passage placement func to always be true for any dome spots (Activate happens when start of passage is placed)
	if self.mode == "passage_grid" and IsDomePoint(self) then
		self.current_status = clrNoModifier
	end
	return ChoOrig_Activate(self, pt,...)
end

local skip_reasons = {
	block_entrance = true,
	block_life_support = true,
	dome = true,
	roads = true,
}
-- this combined with the skip block reasons allows us to place in the life-support pipe area
local ChoOrig_block = SupplyGridElementHexStatus.blocked
local ChoOrig_PlacePassageLine = PlacePassageLine
function PlacePassageLine(...)
	-- 1 == clear
	SupplyGridElementHexStatus.blocked = 1
	local ret = {ChoOrig_PlacePassageLine(...)}
	SupplyGridElementHexStatus.blocked = ChoOrig_block
	return table.unpack(ret)
end

-- extend your massive passage from a DOME (or road)?
local ChoOrig_CanExtendFrom = GridConstructionController.CanExtendFrom
function GridConstructionController:CanExtendFrom(...)
	local res, reason, obj = ChoOrig_CanExtendFrom(self, ...)

	if self.mode == "passage_grid" and not res and skip_reasons[reason] then
		return true
	end

	return res, reason, obj
end

-- sites always have a parent_dome, so we have to check if the passage is on a HexInteriorShapes
-- (the only place that grid connections work with)
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
	if self.elements[1] then
		return IsValid(self.parent_dome)
			and T(302535920011818, "<green>Dome Connection Established</green>")
			or T(302535920011819, "<red>Connection Failed! (white hexes only)</red>")
	end
	return TestEndPoint(self, "start_el") and TestEndPoint(self, "end_el")
		and T(302535920011818, "<green>Dome Connection Established</green>")
		or T(302535920011819, "<red>Connection Failed! (white hexes only)</red>")
end

-- add status to let people know if it's a valid spot (also add toggle coll button)
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
		"Title", T(302535920011820, "Dome Connection"),
	}, {
		PlaceObj("XTemplateTemplate", {
			"__template", "InfopanelText",
			"Text", T("<ChoGGi_ValidDomes>"),
		}),
	})
	-- add template to passage and construction site
	table.insert(xtemplate, 1, section)

  xtemplate[#xtemplate+1] = PlaceObj("XTemplateTemplate", {
		"__template", "InfopanelButton",
		"RolloverTitle", T(302535920000581, "Toggle Object Collision"),
		"RolloverText", T(302535920000582, "Select an object and activate this to toggle collision (if you have a rover stuck in a dome)."),
		"OnPress", function(self)
			-- doesn't do anything, but I use it for notification
			CollisionsObject_Toggle(self.context)
			local objs = self.context.elements or ""
			for i = 1, #objs do
				local obj = objs[i]
				-- skip outside passage chunks
				if IsValid(obj.dome) then
					CollisionsObject_Toggle(obj, true)
				end
			end
		end,
		"Icon", "UI/Icons/IPButtons/dome_buildings.tga",
	})

--~ 	xtemplate[#xtemplate+1] = section
	table.insert(XTemplates.sectionConstructionSite[1][1], 1, section)
end

local ChoOrig_ConnectDomesWithPassage = ConnectDomesWithPassage
function ConnectDomesWithPassage(d1, d2, ...)
	return d1 and d2 and ChoOrig_ConnectDomesWithPassage(d1, d2, ...)
end

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
		shape = o,
	}

	local domes = UICity.labels.Dome or ""
	for i = 1, #domes do
		local dome = domes[i]
		local entity = dome:GetEntity()
		-- probably don't need to check, but eh
		if IsValidEntity(entity) then
			-- open city hex shape can be different for each city
			if dome:IsKindOf("OpenCity") then
				params.shape = dome.hex_shape_interior or Dome.GetInteriorShape(dome)
			else
				params.shape = HexInteriorShapes[entity]
			end
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

local ChoOrig_GridConstructionDialog_Open = GridConstructionDialog.Open
function GridConstructionDialog:Open(...)
	if mod_ShowUseableGrids and self.mode_name == "passage_grid" then
		ShowGrids()
	end
	return ChoOrig_GridConstructionDialog_Open(self, ...)
end

local ChoOrig_GridConstructionDialog_Close = GridConstructionDialog.Close
function GridConstructionDialog:Close(...)
	if self.mode_name == "passage_grid" then
		HideGrids()
	end
	return ChoOrig_GridConstructionDialog_Close(self, ...)
end

function OnMsg.LoadGame()
	local fallback_dome = UICity.labels.Dome[1]

	local objs = UICity.labels.Passage or ""
	for i = #objs, 1, -1 do
		local obj = objs[i]

		-- stuck in demolish countdown with no colonists inside
		if obj.demolishing and (obj.demolishing_countdown or 1) <= 0
			and #obj.traversing_colonists == 0
		then
			-- get a valid dome
			local start_el = obj.start_el
			local end_el = obj.end_el
			local start_dome = IsValid(start_el.dome) and start_el.dome
			local end_dome = IsValid(end_el.dome) and end_el.dome
			-- reset passage to have valid domes, so we can delete without errors
			if not start_dome and not end_dome then
				start_el.dome = fallback_dome
				end_el.dome = fallback_dome
			elseif start_dome and not end_dome then
				end_el.dome = start_dome
			elseif end_dome and not start_dome then
				start_el.dome = end_dome
			end
			-- bye bye
			DeleteObject(obj)
		end
	end
end

-- add keybind for toggle
local Actions = ChoGGi.Temp.Actions
Actions[#Actions+1] = {ActionName = T(302535920011567, "Passages Use Empty Hexes"),
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
