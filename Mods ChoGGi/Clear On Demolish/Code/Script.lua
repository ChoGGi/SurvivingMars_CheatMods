-- See LICENSE for terms

local IsTechResearched = IsTechResearched
local IsValid = IsValid
local DoneObject = DoneObject
local type = type
local FlattenTerrainInBuildShape = FlattenTerrainInBuildShape
local HasAnySurfaces = HasAnySurfaces
local HasRestoreHeight = terrain.HasRestoreHeight
local EntitySurfaces_Height = EntitySurfaces.Height

local function ExecFunc(obj,funcname,param)
	if type(obj[funcname]) == "function" then
		obj[funcname](obj,param)
	end
end

function OnMsg.Demolished(obj)
	if not IsTechResearched("DecommissionProtocol") then
		return
	end

	-- causes log spam, transport still drops items carried so...
	if not obj:IsKindOf("WaterReclamationSpire") and not IsValid(obj.parent_dome) and not obj:IsKindOf("RCTransport") then
		ExecFunc(obj,"Done")
	end

	ExecFunc(obj,"RestoreTerrain")
	ExecFunc(obj,"Destroy")

	if obj.GetFlattenShape and HasAnySurfaces(obj, EntitySurfaces_Height, true) and not HasRestoreHeight() then
		FlattenTerrainInBuildShape(obj:GetFlattenShape(), obj)
	end

	ExecFunc(obj,"SetDome",false)
	ExecFunc(obj,"RemoveFromLabels")

	ExecFunc(obj,"Gossip","done")
	ExecFunc(obj,"SetHolder",false)

	-- I did ask nicely
	if IsValid(obj) then
		DoneObject(obj)
	end

end
