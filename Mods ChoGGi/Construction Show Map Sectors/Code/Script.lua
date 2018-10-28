local size = 100 * guim
local green = green
local MulDivRound = MulDivRound
local PlaceObject = PlaceObject

local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding:GameInit()

	for sector,_ in pairs(g_MapSectors) do
		if type(sector) ~= "number" then
			sector.ChoGGi_decal = sector.decal
			if not sector.decal then
				sector.decal = PlaceObject("SectorUnexplored")
				sector.decal:SetColorModifier(green)
				sector.decal:SetPos(sector:GetPos())
				sector.decal:SetScale(MulDivRound(sector.area:sizex(), 100, size)+1)
			end
			sector.decal:SetVisible(true)
		end
	end

  return orig_CursorBuilding_GameInit(self)
end

local orig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding:Done()

	for sector,_ in pairs(g_MapSectors) do
		if type(sector) ~= "number" then
			if not sector.ChoGGi_decal then
				sector.decal:delete()
			end
			sector.decal = sector.ChoGGi_decal
			sector:UpdateDecal()
		end
	end

  return orig_CursorBuilding_Done(self)
end
