-- See LICENSE for terms

if not g_AvailableDlc.shepard then
	print(CurrentModDef.title, ": Project Laika DLC not installed! Abort!")
	return
end

local mod_StockMax

local function ProdUpdate(obj)
	-- const.resourcescale=1000
	local max_z = (mod_StockMax / 1000) / 4
	obj.stock_max = mod_StockMax
	obj.max_storage = mod_StockMax
	-- visual cube bump
	for i = 1, #obj.stockpiles do
		local stock = obj.stockpiles[i]
		stock.max_z = max_z
	end
end

local function UpdateRanchesLoop(label)
	local objs = UIColony:GetCityLabels(label)
	for i = 1, #objs do
		local obj = objs[i]
--~ 		obj.max_storage1 = mod_StockMax
		obj.max_storage = mod_StockMax
		ProdUpdate(obj:GetProducerObj())
	end
end

local function UpdateRanches()
	UpdateRanchesLoop("InsidePasture")
	UpdateRanchesLoop("OpenPasture")
end

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_StockMax = CurrentModOptions:GetProperty("StockMax") * const.ResourceScale

	ChoGGi_Funcs.Common.SetBuildingTemplates("OpenPasture", "max_storage1", mod_StockMax)
	ChoGGi_Funcs.Common.SetBuildingTemplates("InsidePasture", "max_storage1", mod_StockMax)

	-- make sure we're in-game
	if not UIColony then
		return
	end

	UpdateRanches()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local changed
function OnMsg.ClassesPostprocess()
	if changed then
		return
	end

	local ChoOrig_Pasture_GameInit = Pasture.GameInit
	function Pasture.GameInit(...)
		ChoOrig_Pasture_GameInit(self, ...)
--~ 		self.max_storage1 = mod_StockMax
		self.max_storage = mod_StockMax
		ProdUpdate(self:GetProducerObj())
	end
	changed = true
end

OnMsg.CityStart = UpdateRanches
OnMsg.LoadGame = UpdateRanches
