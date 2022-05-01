-- See LICENSE for terms

local demo_colour = black
local default_colour = 6579300

local GetAllAttaches = ChoGGi.ComFuncs.GetAllAttaches

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

	local attaches = GetAllAttaches(obj)
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

local ChoOrig_ToggleDemolish = Demolishable.ToggleDemolish
function Demolishable:ToggleDemolish(...)
	CreateRealTimeThread(ChangeDemo, self)
	return ChoOrig_ToggleDemolish(self, ...)
end

local ChoOrig_DestroyedClear = Building.DestroyedClear
function Building:DestroyedClear(...)
	CreateRealTimeThread(ChangeRemove, self, true)
	return ChoOrig_DestroyedClear(self, ...)
end

local ChoOrig_CancelDestroyedClear = Building.CancelDestroyedClear
function Building:CancelDestroyedClear(...)
	CreateRealTimeThread(ChangeRemove, self, false)
	return ChoOrig_CancelDestroyedClear(self, ...)
end


-- reset on demo
function OnMsg.Demolished(obj)
	if not obj.ChoGGi_ColourDemo then
		return
	end

	obj:SetColorModifier(obj.ChoGGi_ColourDemo or default_colour)
	obj.ChoGGi_ColourDemo = nil

	local attaches = GetAllAttaches(obj)
	for i = 1, #attaches do
		local a = attaches[i]
		a:SetColorModifier(a.ChoGGi_ColourDemo or default_colour)
	end

end
