-- See LICENSE for terms

-- TEST WITH NO ECM

local IsValid = IsValid
local IsPoint = IsPoint
local GetDomeAtPoint = GetDomeAtPoint
local table_unpack = table.unpack

-- the only thing I care about is that a dome is at the current pos, the rest is up to the user
local function IsDomePoint(obj)
	if not obj then
		return
	end
	-- from construct controller or point
	obj = obj.current_points and obj.current_points[#obj.current_points] or obj

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
-- this combined with the skip block reasons allows us to use the life-support pipe area
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
local TestDomeBuildabilityForPassage = TestDomeBuildabilityForPassage
local function TestEndPoint(self, end_point)
	local eq, er = WorldToHex(self[end_point])

	local dome = self[end_point].parent_dome
	local dir = HexAngleToDirection(dome:GetAngle())
	local cq, cr = WorldToHex(dome)
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


	table.insert(xtemplate, #xtemplate, section)

	local con = XTemplates.sectionConstructionSite[1][1]
	table.insert(con, #con, section)
end

local orig_ConnectDomesWithPassage = ConnectDomesWithPassage
function ConnectDomesWithPassage(d1, d2, ...)
	if d1 and d2 then
		return orig_ConnectDomesWithPassage(d1, d2, ...)
	end
end




-- getting there...
do return end




-- improperly placed passage == no parent_dome == not valid connection
local orig_IsObjInDome = IsObjInDome
local function fake_IsObjInDome(obj)
	print("FAKE IsObjInDome")
	return obj.start_el.parent_dome or GetDomeAtPoint(obj.start_el:GetPos())
end

local orig_SupplyGridConnectElement = SupplyGridObject.SupplyGridConnectElement
function SupplyGridObject:SupplyGridConnectElement(element, ...)
	if element.building.class == "Passage" then
		-- don't replace if it's in a valid spot
		local q, r = WorldToHex(self.start_el)
--~ 		ChoGGi.ComFuncs.ShowQR(q, r)
		local result, reason, obj = TestDomeBuildabilityForPassage(q, r, "check_edge", "check_road")
		-- in other words check for what we ignored above
		if not res and skip_reasons[reason] then
			IsObjInDome = fake_IsObjInDome
		end

		orig_SupplyGridConnectElement(self, element, ...)
		IsObjInDome = orig_IsObjInDome
		return
	end
	return orig_SupplyGridConnectElement(self, element, ...)
end

local orig_FindSupplyTunnelNodes = Passage.FindSupplyTunnelNodes

local function FakeNodes(self, name)
	print("FakeNodes", name)
	if not self.supply_tunnel_nodes then
		orig_FindSupplyTunnelNodes(self)
	end

	if not self.elements[self.supply_tunnel_nodes[1]] then
		self.supply_tunnel_nodes[1] = 1
		self.supply_tunnel_nodes[2] = #self.elements_under_construction
		if self.supply_tunnel_nodes[2] == 0 then
			self.supply_tunnel_nodes[2] = #self.elements
		end
	end
end

function Passage:FindSupplyTunnelNodes(...)
	orig_FindSupplyTunnelNodes(self, ...)
	FakeNodes(self,"FindSupplyTunnelNodes")
end

local orig_AddSupplyTunnel = Passage.AddSupplyTunnel
function Passage:AddSupplyTunnel(...)
	FakeNodes(self,"AddSupplyTunnel")
	return orig_AddSupplyTunnel(self, ...)
end

local orig_RebuildIndexes = Passage.RebuildIndexes
function Passage:RebuildIndexes(...)
	FakeNodes(self,"RebuildIndexes")
	return orig_RebuildIndexes(self, ...)
end
