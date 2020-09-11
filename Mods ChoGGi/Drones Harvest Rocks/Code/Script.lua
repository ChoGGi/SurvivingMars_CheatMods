-- See LICENSE for terms

local MapFindNearest = MapFindNearest
local WaitMsg = WaitMsg
local IsValid = IsValid
local Sleep = Sleep
local PlayFX = PlayFX
local GetRandomPassableAround = GetRandomPassableAround

function Drone:ChoGGi_RockRemove(obj)
	self:Face(obj, 100)

	PlayFX("Deconstruct", "start", self)
	self:PlayState("gatherStart")

	self:SetState("gatherIdle")
	-- we split in half so when the hands reach back it'll shrink
	local dur = self:GetAnimDuration("gatherIdle") / 2

	local scale = 100
	while scale > 0 do
		Sleep(dur)
		scale = scale - 15
		obj:SetScale(scale)
		Sleep(dur)
	end

	self:PlayState("gatherEnd")
	PlayFX("Deconstruct", "end", self)

	obj:TransformToStockpile(self)
end

local efSelectable = const.efSelectable
local function DroneRemoveRock(obj)
	if not obj.TransformToStockpile then
		return
	end
	local rock_pos = obj:GetPos()

	local drone = MapFindNearest(rock_pos, "map", "Drone", efSelectable, function(d)
		if d.command == "Idle" then
			return true
		end
	end)
	if not drone then
		return
	end

	local pos = GetRandomPassableAround(rock_pos, 500)
	if pos then
		drone:SetCommand("Goto",
		pos:SetTerrainZ())

		-- good enough
		while drone.command ~= "Idle" and drone.command ~= "GoHome" do
			WaitMsg("OnRender")
		end

		drone:SetCommand("ChoGGi_RockRemove", obj)
	end
end

-- If it's a waste rock and it doesn't DoesNotObstructConstruction then it's "safe" (read: non-cheaty) to remove
local orig_CanDemolish = DemolishModeDialog.CanDemolish
function DemolishModeDialog:CanDemolish(pt, obj, ...)
	obj = obj or SelectionMouseObj() or GetTerrainCursorObj()
	if IsValid(obj) and obj:IsKindOf("DoesNotObstructConstruction") then
		return true
	end

	return orig_CanDemolish(self, pt, obj, ...)
end

local orig_OnMouseButtonDown = DemolishModeDialog.OnMouseButtonDown
function DemolishModeDialog:OnMouseButtonDown(pt, button, obj, ...)
	if button == "L" then
		obj = obj or SelectionMouseObj() or GetTerrainCursorObj()
		if IsValid(obj) and obj:IsKindOf("DoesNotObstructConstruction") then
			CreateGameTimeThread(DroneRemoveRock, obj)
			return "break"
		end
	end

	return orig_OnMouseButtonDown(self, pt, button, obj, ...)
end
