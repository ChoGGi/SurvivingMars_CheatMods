-- See LICENSE for terms

local wonders = {
--~ 	ArtificialSun = "engineer",
	MoholeMine = "geologist",
	OmegaTelescope = "scientist",
	ProjectMorpheus = "medic",
	SpaceElevator = "security",
	TheExcavator = "geologist",
}

-- add workplace as parent cls obj
local table_find = table.find
for id in pairs(wonders) do
	local p = _G[id].__parents
	if not table_find(p, "Workplace") then
		p[#p+1] = "Workplace"
	end
end

local options

local function UpdateWorkers(obj)
	local workers = options:GetProperty(obj.class)
	if workers then
		obj.max_workers = workers
		if workers == 0 then
			obj.automation = 1
			obj.auto_performance = 100
		else
			obj.automation = 0
			obj.auto_performance = 0
		end
	end
end

-- fired when settings are changed/init
local function ModOptions()
	if not GameState.gameplay then
		return
	end

	local objs = UICity.labels.Wonders or ""
	for i = 1, #objs do
		UpdateWorkers(objs[i])
	end
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

-- update any existing objs
GlobalVar("g_ChoGGi_WonderWorkersAdded", false)

function OnMsg.LoadGame()
	if g_ChoGGi_WonderWorkersAdded then
		return
	end
	g_ChoGGi_WonderWorkersAdded = true

	local ToggleWorking = ChoGGi.ComFuncs.ToggleWorking
	local ShiftsBuilding_Init = ShiftsBuilding.Init
	local ShiftsBuilding_GameInit = ShiftsBuilding.GameInit
	local DomeOutskirtBld_GameInit = DomeOutskirtBld.GameInit
	local Workplace_Init = Workplace.Init
	local Workplace_GameInit = Workplace.GameInit

	local objs = UICity.labels.Wonders or ""
	for i = 1, #objs do
		local obj = objs[i]
		-- we skip the geodome n capital city
		if options:GetProperty(obj.class) and not obj.workers then
			ShiftsBuilding_Init(obj)
			Workplace_Init(obj)
			ShiftsBuilding_GameInit(obj)
			DomeOutskirtBld_GameInit(obj)
			Workplace_GameInit(obj)
			ToggleWorking(obj)
		end
		local spec = wonders[obj.class]
		if spec then
			obj.specialist = spec
		end
	end
end
