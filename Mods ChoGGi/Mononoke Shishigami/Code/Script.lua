-- See LICENSE for terms

local point = point
local Sleep = Sleep
local DeleteThread = DeleteThread
local IsValidThread = IsValidThread
local CreateGameTimeThread = CreateGameTimeThread
local GetTimeFactor = GetTimeFactor
local GetCursorWorldPos = GetCursorWorldPos
local GetDomeAtHex = GetDomeAtHex
local AsyncRand = AsyncRand

local function Random(m, n)
	return AsyncRand(n - m + 1) + m
end

local mod_ToggleShrubs

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_ToggleShrubs = CurrentModOptions:GetProperty("ToggleShrubs")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- entities to use
local entities = {}
local count = 0
local EntityData = EntityData
for key in pairs(EntityData) do
	local five = key:sub(1, 5)
	local eight = key:sub(1, 8)
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

DefineClass.ChoGGi_TransitoryEntity = {
	__parents = {"EntityClass", "Object"},
	flags = {
		efShadow = false,
		efSunShadow = false,
		gofNoDepthTest = true,
	},

	shrub_thread = false,
}

-- fade them to brown while shrinking
function ChoGGi_TransitoryEntity:GameInit()
	self.shrub_thread = CreateGameTimeThread(function()
		-- scale/steps to loop
		local steps = 30
		if self.entity:sub(1, 4) == "Tree" then
			self:SetPos(
				self.shrub_pos:SetTerrainZ(-35 + Random(-10, 10))
			)
		end

		-- first we grow
		for i = 1, steps do
			self:SetScale(i)
			Sleep(50 + Random(1, 10))
		end
		Sleep(75)
		-- than we shrink to brown
		for i = steps, 1, -1 do
			steps = steps - 1
			self:SetScale(i)
			self:SetColorModifier(colours[count_colours - i])
			Sleep(50 + Random(1, 10))
		end

		-- byebye
		self:delete()
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

local cursor_pos
local entity_cls
local surface_map_id
local active_map_id
local function SpawnGreen()
	-- weird lag underground, almost like domes, but seemingly random spots
	if active_map_id ~= surface_map_id then
		return
	end

	local obj = entity_cls:new()
	local ent = entities[Random(1, count)]
	obj:ChangeEntity(ent)
	obj:SetScale(1)
	obj:SetAngle(Random(0, 21600))
	local pos = cursor_pos + point(Random(-250, 250), Random(-250, 250))
	obj:SetPos(pos)
	obj.shrub_pos = pos
end

local growth_thread

local function CleanUp()
	-- good as any place
	active_map_id = ActiveMapID
	surface_map_id = UIColony.surface_map_id
	entity_cls = ChoGGi_TransitoryEntity

	-- actual cleanup
	DeleteThread(growth_thread)
	local GameMaps = GameMaps
	for _, map in pairs(GameMaps) do
		local objs = map.realm:MapGet("map", "ChoGGi_TransitoryEntity")
		for i = 1, #objs do
			DeleteThread(self.shrub_thread)
			objs[i]:delete()
		end
	end
end
OnMsg.ChangeMapDone = CleanUp

function OnMsg.InGameInterfaceCreated(igi)
	CleanUp()

	local object_hex_grid = GameMaps[ActiveMapID].object_hex_grid
	local Dialogs = Dialogs

	local function OnMousePos()
		if mod_ToggleShrubs and not skip and GetTimeFactor() > 0 then
			cursor_pos = GetCursorWorldPos()
			local dome = GetDomeAtHex(object_hex_grid, WorldToHex(cursor_pos))
			-- Domes are laggy
			if not dome then
				SpawnGreen()

				if not IsValidThread(growth_thread) then
					growth_thread = CreateGameTimeThread(function()
						while true do
							cursor_pos = GetCursorWorldPos()
							local dome = GetDomeAtHex(object_hex_grid, WorldToHex(cursor_pos))
							if not dome then
								SpawnGreen()
							end
							Sleep(100)
							-- Stop it in construction mode
							if Dialogs.ConstructionModeDialog then
								DeleteThread(growth_thread)
							end
						end
					end)
				end

			end
		end
	end

	-- we remove this hook once selection dialog is good
	local ChoOrig_OnMousePos_igi = igi.OnMousePos
	function igi:OnMousePos(...)
		OnMousePos()
		return ChoOrig_OnMousePos_igi(self,...)
	end

	-- override OnMousePos for the SelectionModeDialog (works in both regular and selected, but not build menu)
	local ChoOrig_OpenDialog = OpenDialog
	function OpenDialog(cls,...)
		local dlg = ChoOrig_OpenDialog(cls,...)
		if cls == "SelectionModeDialog" then
			CreateRealTimeThread(function()
				if ChoOrig_OnMousePos_igi then
					-- stop igi from doing it, since we can stick with this one
					igi.OnMousePos = ChoOrig_OnMousePos_igi
					ChoOrig_OnMousePos_igi = nil
				end
				WaitMsg("OnRender")

				local ChoOrig_OnMousePos = dlg.OnMousePos
				function dlg.OnMousePos(...)
					OnMousePos()
					return ChoOrig_OnMousePos(...)
				end

			end)
		end
		return dlg
	end

end
