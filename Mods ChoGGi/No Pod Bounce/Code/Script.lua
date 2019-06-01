-- See LICENSE for terms

local reset = {
	destroy = true,
	destroy2 = true,
	destroyed = true,
	idle2 = true,
}

local PlaySound = PlaySound
local PlayFX = PlayFX

local SetAnim = g_CObjectFuncs.SetAnim

function SupplyPod:SetAnim(num, anim, ...)
	if anim == "idle2" then
		local entity = self:GetEntity()
		if entity == "DropPod" then
			self:SetPos(self:GetPos():SetTerrainZ(-350), 1000)
		else
			self:SetPos(self:GetPos():SetTerrainZ(-400), 1000)
		end
	end
	if reset[anim] then
		anim = "idle"
	end
	return SetAnim(self, num, anim, ...)
end
