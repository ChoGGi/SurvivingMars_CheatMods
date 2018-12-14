-- See LICENSE for terms

-- probably best not to use this on a saved game?

--~ HexPainter()
--~ HexPainter(GetEntityHexShapes(s:GetEntity()))
--~ HexPainter(GetEntityBuildShape(s:GetEntity()))
--~ HexPainter(GetEntityInverseBuildShape(s:GetEntity()))
--~ HexPainter(GetEntityCombinedShape(s:GetEntity()))

GlobalVar("painted_hexes", false)
GlobalVar("painted_hexes_thread", false)
function PaintHexArray(arr, mid_hex_pt) --paints zero based hex shapes (such as from GetEntityHexShapes)
	if IsValidThread(painted_hexes_thread) then
		DeleteThread(painted_hexes_thread)
	end

	if painted_hexes then
		for i = 1, #painted_hexes do
			painted_hexes[i]:delete()
		end
		painted_hexes = false
	end
	if arr then
		painted_hexes_thread = CreateRealTimeThread(function()
			local last_q, last_r
			painted_hexes = {}

			while true do
				local q, r
				if mid_hex_pt then
					q, r = mid_hex_pt:x(), mid_hex_pt:y()
				else
					q, r = WorldToHex(GetTerrainCursor())
				end
				if last_q ~= q or last_r ~= r then
					for i = 1, #arr do
						local q_i, r_i = q + arr[i]:x(), r + arr[i]:y()
						local c = painted_hexes[i] or ChoGGi_HexSpot:new()
						c:SetPos(point(HexToWorld(q_i, r_i)))
--~ 							c:SetRadius(const.GridSpacing/2)
--~ 							c:SetColorModifier(RGBA(100, 255, 100, 0))
						painted_hexes[i] = c
					end
					last_q = q
					last_r = r
				end
				Sleep(50)
			end
		end)
	end
end

-- allows you to redefine hex shapes (right-click offsets the hex grid)
local HexPainter_toggle
function HexPainter(arr)
	if HexPainter_toggle then
		HexPainter_toggle = nil
		Dialogs.InGameInterface:SetMode("selection")
	else
		HexPainter_toggle = true
		Dialogs.InGameInterface:SetMode("hex_painter", {res_arr = arr, hex_mid_pt = point(WorldToHex(GetTerrainCursor()))})
	end
end

GlobalVar("HexPainterResultArr", false)

DefineClass.HexPainterModeDialog = {
	__parents = { "InterfaceModeDialog" },
	mode_name = "hex_painter",

	hex_mid_pt = false,
	hex_mid_circle = false,
	res_arr = false,
}

function HexPainterModeDialog:Init()
	self:SetFocus()
	self.res_arr = self.context.res_arr or {}
	self.hex_mid_pt = self.context.hex_mid_pt
end

function HexPainterModeDialog:Open(...)
	InterfaceModeDialog.Open(self, ...)
--~	 self:PaintMid()
	PaintHexArray(self.res_arr, self.hex_mid_pt)
end

function HexPainterModeDialog:Close(...)
	InterfaceModeDialog.Close(self, ...)
	HexPainterResultArr = self.res_arr
	PaintHexArray()
	if self.hex_mid_circle then
		self.hex_mid_circle:delete()
	end
end

--~ function HexPainterModeDialog:OnMouseButtonDown(pt, button)
function HexPainterModeDialog:OnMouseButtonDown(_, button)
	if button == "L" then
		local p = point(WorldToHex(GetTerrainCursor()))
		if self.hex_mid_pt then
			p = p - self.hex_mid_pt
		end

		local idx = table.find(self.res_arr, p)
		if idx then
			table.remove(self.res_arr, idx)
		else
			table.insert(self.res_arr, p)
		end

		PaintHexArray(self.res_arr, self.hex_mid_pt)

		return "break"
	elseif button == "R" then
		if self.hex_mid_pt then
			for i = 1, #self.res_arr do
				self.res_arr[i] = self.res_arr[i] + self.hex_mid_pt
			end


		end
		self.hex_mid_pt = point(WorldToHex(GetTerrainCursor()))

		if self.hex_mid_pt then
			for i = 1, #self.res_arr do
				self.res_arr[i] = self.res_arr[i] - self.hex_mid_pt
			end
			self:PaintMid()
		end


		PaintHexArray(self.res_arr, self.hex_mid_pt)
		return "break"
	end
end

function HexPainterModeDialog:PaintMid()
	if self.hex_mid_circle then
		self.hex_mid_circle:delete()
	end
	if self.hex_mid_pt then
		self.hex_mid_circle = ChoGGi_HexSpot:new()
		self.hex_mid_circle:SetPos(point(HexToWorld(self.hex_mid_pt:x(), self.hex_mid_pt:y())))
			self.hex_mid_circle:SetColorModifier(RGB(100, 255, 100))
--~ 			self.hex_mid_circle:SetRadius(const.GridSpacing/2)
	end
end
