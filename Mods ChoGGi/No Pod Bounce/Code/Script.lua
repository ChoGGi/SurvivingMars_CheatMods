-- See LICENSE for terms

local reset = {
	destroy = true,
	destroy2 = true,
	destroyed = true,
	idle2 = true,
}
local orig_SetAnim = SupplyPod.SetAnim
function SupplyPod:SetAnim(num, anim, ...)
	if reset[anim] then
		anim = "idle"
	end
	return orig_SetAnim(self, num, anim, ...)
end
