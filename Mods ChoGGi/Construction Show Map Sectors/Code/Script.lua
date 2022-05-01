-- See LICENSE for terms

local mod_Option1

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_Option1 = CurrentModOptions:GetProperty("Option1")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local type, pairs = type, pairs
local table = table
local MulDivRound = MulDivRound
local IsValid = IsValid
local DoneObject = DoneObject

local size = 100 * guim
local green = green

local function AddSectors()
	local SectorUnexplored = SectorUnexplored
	local sectors = UICity.MapSectors
	for sector in pairs(sectors) do
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
			if not (sector.decal and IsValid(sector.ChoGGi_decal)) then
				sector.ChoGGi_decal = SectorUnexplored:new()
				local decal = sector.ChoGGi_decal
				decal:SetColorModifier(green)
				decal:SetPos(sector:GetPos())
				decal:SetScale(MulDivRound(sector.area:sizex(), 100, size)+1)
				decal:SetOpacity(25)
			end
		end
	end
end

local sector_objs = {}
local function RemoveStuckSectors(obj)
	-- remove any that shouldn't be there
	if not sector_objs[obj] then
		DoneObject(obj)
	end
end

local function RemoveSectors()
	table.clear(sector_objs)

	local sectors = UICity.MapSectors
	for sector in pairs(sectors) do
		if type(sector) == "table" then
			-- I'm lazy and deleting them now instead of checking for scanned sectors and removing them then
			if IsValid(sector.ChoGGi_decal) then
				DoneObject(sector.ChoGGi_decal)
				sector.ChoGGi_decal = nil
			end
			-- hide any white sectors
			if IsValid(sector.decal) then
				sector_objs[sector.decal] = true
				sector.decal:SetVisible(false)
			end
		end
	end

	MapForEach("map", "SectorUnexplored", RemoveStuckSectors)
end

-- can't hurt
OnMsg.SaveGame = RemoveSectors

local ChoOrig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding.GameInit(...)
	if mod_Option1 then
		AddSectors()
	end
	return ChoOrig_CursorBuilding_GameInit(...)
end

local ChoOrig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding.Done(...)
	RemoveSectors()
	return ChoOrig_CursorBuilding_Done(...)
end

