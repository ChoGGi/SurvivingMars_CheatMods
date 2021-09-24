-- See LICENSE for terms

local p = PassageGridElement.__parents
if not table.find(p, "ElectricityGridObject") then
	p[#p+1] = "ElectricityGridObject"
end

PassageGridElement.CreateElectricityElement = ElectricityGridElement.CreateElectricityElement

local ChoOrig_OnDestroyed = PassageGridElement.OnDestroyed
function PassageGridElement:OnDestroyed(...)
	ElectricityGridObject.OnDestroyed(self)
	return ChoOrig_OnDestroyed(self, ...)
end
