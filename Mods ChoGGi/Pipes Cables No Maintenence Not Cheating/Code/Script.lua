-- See LICENSE for terms

-- wtf? fix for this error:
-- Error loading file PackedMods/*****/Code/Script.lua: PackedMods/*****/Code/Script.lua:1: syntax error near '<\1>'

-- make it do nothing instead of breaking something
--~ SupplyGridFragment.RandomElementBreakageOnWorkshiftChange = empty_func

City.RandomBreakSupplyGrid = empty_func
ElectricityGridElement.CanBreak = empty_func
LifeSupportGridElement.CanBreak = empty_func
