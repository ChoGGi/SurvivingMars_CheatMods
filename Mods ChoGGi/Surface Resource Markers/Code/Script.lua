-- See LICENSE for terms

-- just wanted a class name for examine...
DefineClass.ChoGGi_OSurfaceMarker = {
	__parents = {
		"CObject",
	},
}

local IsValid = IsValid
local DoneObject = DoneObject
local point = point

local mod_EnableMod

local res_table = {
	SurfaceDepositMetals = "SignMetalsDeposit",
	SurfaceDepositPolymers = "SignWaterDeposit",
	SurfaceDepositConcrete = "SignConcreteDeposit",
}

local function AddMarker(obj, entity)
	local marker = ChoGGi_OSurfaceMarker:new()
	obj.ChoGGi_SurfaceMarker = marker

	marker:ChangeEntity(entity)
	if entity == "SignWaterDeposit" then
		marker:SetColorModifier(1179392)
	end
	marker:SetScale(25)
	obj:Attach(marker)
	-- stick it above resource
	local obj_height = point(0, 0, obj:GetObjectBBox():sizez()):AddZ(10)
	marker:SetAttachOffset(obj_height)
end

local function UpdateIcons()

	local objs = UIColony:GetCityLabels("SurfaceDeposit")
	for i = 1, #objs do
		local obj = objs[i]
		local grp = obj:GetDepositGroup()
		-- single resource (from asteroid) or group of objs
		if grp then
			obj = IsValid(grp.holder) and grp.holder or obj
		end
		local valid_marker = IsValid(obj.ChoGGi_SurfaceMarker)
		if mod_EnableMod then
			local entity = res_table[obj.class]
			if not valid_marker and entity then
				AddMarker(obj, entity)
			end
		else
			if valid_marker then
				DoneObject(obj.ChoGGi_SurfaceMarker)
				obj.ChoGGi_SurfaceMarker = nil
			end
		end

	end

end
OnMsg.CityStart = UpdateIcons
OnMsg.LoadGame = UpdateIcons

-- add marker to newly added resources (asteroids)
local ChoOrig_SurfaceDeposit_GameInit = SurfaceDeposit.GameInit
function SurfaceDeposit:GameInit(...)
	if mod_EnableMod then
		AddMarker(self, res_table[self.class])
	end
	return ChoOrig_SurfaceDeposit_GameInit(self, ...)
end

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- Make sure we're in-game
	if not UIColony then
		return
	end

	UpdateIcons()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
