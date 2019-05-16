-- See LICENSE for terms

local mod_id = "ChoGGi_MononokeShishiGami"
local mod = Mods[mod_id]

local DoneObject = DoneObject
local GetTerrainCursor = GetTerrainCursor
local point = point
local Sleep = Sleep
local GetTimeFactor = GetTimeFactor

-- entities to use
local entities = {}
local count = 0
local EntityData = EntityData
for key in pairs(EntityData) do
	local five = key:sub(1,5)
	local eight = key:sub(1,8)
	if five == "Tree_" or five == "Bush_" or eight == "TreeArm_" or eight == "BushArm_" then
		count = count + 1
		entities[count] = key
	end
end

-- green to brownish to black
local colours = {
	-10197916,
	-9541272,
	-9015956,
	-8490384,
	-7965069,
	-7637391,
	-7375247,
	-6982032,
	-6523024,
	-6458517,
	-6131096,
	-5672344,
	-5410459,
	-5083037,
	-4887201,
	-4690851,
	-4494758,
	-4364715,
	-4103086,
	-3841714,
	-3646136,
	-3385279,
	-3058886,
	-2797772,
	-2471635,
	-2144985,
	-2015714,
	-1952236,
	-2150387,
	-2675445,
	-3463417,
	-4447226,
	-5496828,
	-6415357,
	-7333373,
	-8645118,
	-9759998,
	-11005950,
	-12252159,
	-13367039,
	-14809856,
	-15596800,
	-16384000,
}
local count_colours = #colours

local AsyncRand = AsyncRand
local function Random(m, n)
	return AsyncRand(n - m + 1) + m
end

DefineClass.ChoGGi_TransitoryEntity = {
	__parents = {"EntityClass","Object"},
	flags = {efShadow = false},

	shrub_thread = false,
}

-- fade them to brown while shrinking
function ChoGGi_TransitoryEntity:GameInit()
	self.shrub_thread = CreateGameTimeThread(function()
		-- scale/steps to loop
		local steps = 30
		if self.entity:sub(1,4) == "Tree" then
			self:SetPos(self.shrub_pos:SetTerrainZ(-35+Random(-10,10)))
		end

		-- first we grow
		for i = 1, steps do
			self:SetScale(i)
			Sleep(50+Random(1,10))
		end
		Sleep(75)
		-- than we shrink to brown
		for i = steps, 1, -1 do
			steps = steps - 1
			self:SetScale(i)
			self:SetColorModifier(colours[count_colours - i])
			Sleep(50+Random(1,10))
		end

		-- byebye
		DoneObject(self)
	end)
end

-- skip adding when focus is lost
local skip = false
function OnMsg.SystemActivate()
	skip = false
end
function OnMsg.SystemInactivate()
	skip = true
end

local enabled = true
function OnMsg.ApplyModOptions(id)
	if id ~= mod_id then
		return
	end
	enabled = mod.options.ToggleShrubs
end

function OnMsg.InGameInterfaceCreated(igi)
	enabled = mod.options.ToggleShrubs
	local entity_cls = ChoGGi_TransitoryEntity

	local function OnMousePos()
		if enabled and not skip and GetTimeFactor() > 0 then
			local cursor = GetTerrainCursor()
			local obj = entity_cls:new()
			local ent = entities[Random(1,count)]
			obj:ChangeEntity(ent)
			obj:SetScale(1)
			obj:SetAngle(Random(0, 21600))
			local pos = cursor+point(Random(-250, 250),Random(-250, 250))
			obj:SetPos(pos)
			obj.shrub_pos = pos
		end
	end

	-- we remove this hook once selection dialog is good
	local orig_OnMousePos_igi = igi.OnMousePos
	function igi:OnMousePos(...)
		OnMousePos()
		return orig_OnMousePos_igi(self,...)
	end

	-- override OnMousePos for the SelectionModeDialog (works in both regular and selected, but not build menu)
	local orig_OpenDialog = OpenDialog
	function OpenDialog(cls,...)
		local dlg = orig_OpenDialog(cls,...)
		if cls == "SelectionModeDialog" then
			CreateRealTimeThread(function()
				if orig_OnMousePos_igi then
					-- stop igi from doing it, since we can stick with this one
					igi.OnMousePos = orig_OnMousePos_igi
					orig_OnMousePos_igi = nil
				end
				WaitMsg("OnRender")
				local orig_OnMousePos = dlg.OnMousePos
				function dlg.OnMousePos(...)
					OnMousePos()
					return orig_OnMousePos(...)
				end
			end)
		end
		return dlg
	end

end
