if not g_AvailableDlc.shepard then
	return
end

-- See LICENSE for terms

local mod_StockMax

local function ProdUpdate(obj)
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
	local objs = UICity.labels[label] or ""
	for i = 1, #objs do
		local obj = objs[i]
		obj.max_storage1 = mod_StockMax
		ProdUpdate(obj:GetProducerObj())
	end
end

local function UpdateRanches()
	UpdateRanchesLoop("InsidePasture")
	UpdateRanchesLoop("OpenPasture")
end

-- fired when settings are changed/init
local function ModOptions()
	mod_StockMax = CurrentModOptions:GetProperty("StockMax") * 1000

	ChoGGi.ComFuncs.SetBuildingTemplates("OpenPasture", "max_storage1", mod_StockMax)

	-- make sure we're not in menus
	if not GameState.gameplay then
		return
	end

	UpdateRanches()
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end


function OnMsg.ClassesPostprocess()
	local orig_Pasture_GameInit = Pasture.GameInit
	function Pasture.GameInit(...)
		orig_Pasture_GameInit(self, ...)
		ProdUpdate(self:GetProducerObj())
	end
end

OnMsg.CityStart = UpdateRanches
OnMsg.LoadGame = UpdateRanches
