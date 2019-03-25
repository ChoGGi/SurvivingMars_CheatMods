-- See LICENSE for terms

local IsTechResearched = IsTechResearched
local IsValid = IsValid
local DoneObject = DoneObject
local type = type

local function ExecFunc(obj,funcname,param)
	if type(obj[funcname]) == "function" then
		obj[funcname](obj,param)
	end
end

function OnMsg.Demolished(obj)
	if not IsTechResearched("DecommissionProtocol") then
		return
	end

	ExecFunc(obj,"RestoreTerrain")
	ExecFunc(obj,"Destroy")
	ExecFunc(obj,"SetDome",false)
	ExecFunc(obj,"RemoveFromLabels")

	-- causes log spam, transport still drops items carried so...
	if not obj:IsKindOf("WaterReclamationSpire") and not IsValid(obj.parent_dome) and not obj:IsKindOf("RCTransport") then
		ExecFunc(obj,"Done")
	end

	ExecFunc(obj,"Gossip","done")
	ExecFunc(obj,"SetHolder",false)

	-- only fire for stuff with holes in the ground (takes too long otherwise)
	if obj:IsKindOfClasses("MoholeMine","ShuttleHub","MetalsExtractor","JumperShuttleHub") then
		ExecFunc(obj,"DestroyAttaches")
	end

	-- I did ask nicely
	if IsValid(obj) then
		DoneObject(obj)
	end

end
