-- See LICENSE for terms

local options
local mod_Option1

-- fired when settings are changed and new/load
local function ModOptions()
	mod_Option1 = options.Option1
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_ConstructionShowMapSectors" then
		return
	end

	ModOptions()
end

local type, pairs = type, pairs
local table_clear = table.iclear
local MulDivRound = MulDivRound
local IsValid = IsValid
local DoneObject = DoneObject

local size = 100 * guim
local green = green

local function AddSectors()
	local SectorUnexplored = SectorUnexplored
	local g_MapSectors = g_MapSectors
	for sector in pairs(g_MapSectors) do
		-- skip the 1-10 sector tables
		if type(sector) == "table" then
			-- unexplored sector
			if IsValid(sector.decal) then
				sector.decal:SetVisible(true)
			else
				-- could be from this mod, or something else
				sector.decal = nil
			end

			-- add decal to explored sector
			if not sector.decal then
				local decal = SectorUnexplored:new()
				decal:SetColorModifier(green)
				decal:SetPos(sector:GetPos())
				decal:SetScale(MulDivRound(sector.area:sizex(), 100, size)+1)
				decal:SetOpacity(25)
				sector.ChoGGi_decal = decal
			end
		end
	end
end

local function RemoveSectors()
	local g_MapSectors = g_MapSectors
	for sector in pairs(g_MapSectors) do
		if type(sector) == "table" then
			-- I'm lazy and deleting them now instead of checking for scanned sectors and removing them then
			if IsValid(sector.ChoGGi_decal) then
				DoneObject(sector.ChoGGi_decal)
				sector.ChoGGi_decal = nil
			end
			sector:UpdateDecal()
		end
	end
end

local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding.GameInit(...)
	if mod_Option1 then
		AddSectors()
	end

	return orig_CursorBuilding_GameInit(...)
end

local orig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding.Done(...)
	if mod_Option1 then
		RemoveSectors()
	end

	return orig_CursorBuilding_Done(...)
end
