-- See LICENSE for terms

local p = PassageGridElement.__parents
if not table.find(p, "ElectricityGridObject") then
	p[#p+1] = "ElectricityGridObject"
end

PassageGridElement.CreateElectricityElement = ElectricityGridElement.CreateElectricityElement

local orig_OnDestroyed = PassageGridElement.OnDestroyed
function PassageGridElement:OnDestroyed(...)
	ElectricityGridObject.OnDestroyed(self)
	return orig_OnDestroyed(self, ...)
end
