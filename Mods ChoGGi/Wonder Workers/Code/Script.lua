-- See LICENSE for terms

local wonders = {
	"ArtificialSun",
	"MoholeMine",
	"OmegaTelescope",
	"ProjectMorpheus",
	"SpaceElevator",
	"TheExcavator",
}

local options
local UpdateWorkers

-- fired when settings are changed/init
local function ModOptions()
	if not GameState.gameplay then
		return
	end

	local objs = UICity.labels.Wonders or ""
	for i = 1, #objs do
		local obj = objs[i]
		UpdateWorkers(obj)
	end
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_WonderWorkers" then
		return
	end

	ModOptions()
end

local table_find = table.find

-- add workplace as parent cls obj
for i = 1, #wonders do
	local p = _G[wonders[i]].__parents
	if not table_find(p, "Workplace") then
		p[#p+1] = "Workplace"
	end
end

-- update any existing objs
GlobalVar("g_ChoGGi_WonderWorkersAdded", false)

local wonder_specs = {
--~ 	ArtificialSun
	MoholeMine = "geologist",
	OmegaTelescope = "scientist",
	ProjectMorpheus = "medic",
--~ 	SpaceElevator
	TheExcavator = "geologist",
}

function OnMsg.LoadGame()
	if g_ChoGGi_WonderWorkersAdded then
		return
	end
	g_ChoGGi_WonderWorkersAdded = true

	local Workplace_Init = Workplace.Init
	local Workplace_GameInit = Workplace.GameInit

	local objs = UICity.labels.Wonders or ""
	for i = 1, #objs do
		local obj = objs[i]
		-- we skip the geodome n capital city
		if options[obj.class] and not obj.workers then
			Workplace_Init(obj)
			Workplace_GameInit(obj)
			UpdateWorkers(obj)
		end
		local spec = wonder_specs[obj.class]
		if spec then
			obj.specialist = spec
		end
	end
end

UpdateWorkers = function(obj)
	local workers = options[obj.class]
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
