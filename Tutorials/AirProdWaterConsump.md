### A building that generates air and uses water

##### add to your building template
```lua
	'air_production', 100000,

	'air_consumption', 0,
	'water_consumption', 25000,
```

##### Script.lua (you need to replace some funcs)
```lua
function YOURBUILDING:CreateLifeSupportElements()
	-- swap prod and consump if you want a water prod and air consump

	self.air = NewSupplyGridProducer(self)
	self.air:SetProduction(self.working and self.air_production or 0)
	-- prevent errors
	self.air.consumption = self.air_consumption

	self.water = NewSupplyGridConsumer(self)
	self.water:SetConsumption(self.water_consumption)
end

function YOURBUILDING:UpdateAttachedSigns()
	self:AttachSign(self:ShouldShowNotConnectedToLifeSupportGridSign(), "SignNoPipeConnection")

	-- if you want air consump, swap Water for Air
	if self.water then
		self:AttachSign(self:ShouldShowNoWaterSign(), "SignNoWater")
	end
end
```
