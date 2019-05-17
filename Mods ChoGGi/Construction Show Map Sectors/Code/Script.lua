-- See LICENSE for terms

local mod_id = "ChoGGi_ConstructionShowMapSectors"
local mod = Mods[mod_id]
local mod_Option1 = mod.options and mod.options.Option1 or true

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= mod_id then
		return
	end

	mod_Option1 = mod.options.Option1
end

-- for some reason mod options aren't retrieved before this script is loaded...
local function StartupCode()
	mod_Option1 = mod.options.Option1
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

local size = 100 * guim
local green = green
local MulDivRound = MulDivRound
local PlaceObject = PlaceObject

local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding.GameInit(...)
	if not mod_Option1 then
		return orig_CursorBuilding_GameInit(...)
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

	return orig_CursorBuilding_GameInit(...)
end

local orig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding.Done(...)

	if mod_Option1 then
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
	end

	return orig_CursorBuilding_Done(...)
end
