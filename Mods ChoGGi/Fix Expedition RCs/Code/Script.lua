-- See LICENSE for terms

local orig_MapGet = MapGet
local function fake_MapGet(world, class)
	return orig_MapGet(world, class)
end

local orig_RocketExpedition_ExpeditionLoadRover = RocketExpedition.ExpeditionLoadRover
function RocketExpedition.ExpeditionLoadRover(...)
	MapGet = fake_MapGet
	orig_RocketExpedition_ExpeditionLoadRover(...)
	MapGet = orig_MapGet
end
