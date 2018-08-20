### Functions you can use with task requests (ex: building.maintenance_work_request)

```
-- create a new work/supply/demand request (see Lua/_TaskRequest.lua)
bld.maintenance_work_request = Request_New(bld, "metals", 1000)

-- building the request is attached to
req:GetBuilding()
-- amount being requesting
req:GetTargetAmount()
-- amount stored
req:GetActualAmount()
-- resource being requesting
req:GetResource()
-- There seems to be 2^16 of them
req:GetFreeUnitSlots()
-- see const.rf*
req:GetFlags()
-- set the amount the request already has (rocket.refuel_request:SetAmount(number))
req:SetAmount()
-- add to the amount
req:AddAmount()
```
