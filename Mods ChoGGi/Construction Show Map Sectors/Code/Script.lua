local size = 100 * guim
local green = green
local MulDivRound = MulDivRound
local PlaceObject = PlaceObject

local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding:GameInit()
	if not ChoGGi_ConstructionShowMapSectors.Option1 then
		return orig_CursorBuilding_GameInit(self)
	end

  local g_MapSectors = g_MapSectors
	for sector in pairs(g_MapSectors) do
		if type(sector) == "table" then
			sector.ChoGGi_decal = sector.decal
			if not sector.decal then
				sector.decal = PlaceObject("SectorUnexplored")
				sector.decal:SetColorModifier(green)
				sector.decal:SetPos(sector:GetPos())
				sector.decal:SetScale(MulDivRound(sector.area:sizex(), 100, size)+1)
			end
			if IsValid(sector.decal) then
				sector.decal:SetVisible(true)
			end
		end
	end

  return orig_CursorBuilding_GameInit(self)
end

local orig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding:Done()

  local g_MapSectors = g_MapSectors
	for sector in pairs(g_MapSectors) do
		if type(sector) == "table" then
			if not sector.ChoGGi_decal then
				sector.decal:delete()
			end
			sector.decal = sector.ChoGGi_decal
			sector:UpdateDecal()
		end
	end

  return orig_CursorBuilding_Done(self)
end
