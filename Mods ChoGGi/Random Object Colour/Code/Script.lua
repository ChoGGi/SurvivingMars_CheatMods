-- See LICENSE for terms

local ObjectColourRandom = ChoGGi.ComFuncs.ObjectColourRandom

local function ChangeColour(self)
	-- we need to wait a sec before we can edit attaches
	WaitMsg("OnRender")
	ObjectColourRandom(self)
end

local orig_BaseBuilding_GameInit = BaseBuilding.GameInit
function BaseBuilding:GameInit(...)
	orig_BaseBuilding_GameInit(self, ...)
	CreateRealTimeThread(ChangeColour, self)
end
