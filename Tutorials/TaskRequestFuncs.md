### Functions you can use with task requests (ex: building.maintenance_work_request)

```
-- create a new work/supply/demand request (see Lua/_TaskRequest.lua)
bld.resupply_request = Request_New(bld, "metals", 1000)

-- building the request is attached to
req:GetBuilding()
-- got me (it's not amount being requested)
req:GetTargetAmount()
-- amount left to fill request
req:GetActualAmount()
-- resource being requesting
req:GetResource()
-- depends on request?
req:GetFreeUnitSlots()
-- see const.rf*
req:GetFlags()
-- set the amount being requested (rocket.refuel_request:SetAmount(number))
req:SetAmount(amount)
-- add to the amount being requested
req:AddAmount(amount)
-- reset request to ask for this amount
req:ResetAmount(amount)

-- get amount stored
local stored = obj.requested_amount - req:GetActualAmount()
```

#### Change the limit of a request without changing how many are stored

```
-- sets task request to new amount (for some reason changing the "limit" will also boost the stored amount)
-- this will reset it back to whatever it was after changing it.
function SetTaskReqAmount(obj,value,task,setting)
	-- if it's in a table, it's almost always [1]
	if type(obj[task]) == "userdata" then
		task = obj[task]
	else
		task = obj[task][1]
	end

	-- get stored amount
	local amount = obj[setting] - task:GetActualAmount()
	-- set new amount
	obj[setting] = value
	-- and reset 'er
	task:ResetAmount(obj[setting])
	-- then add stored, but don't set to above new limit or it'll look weird (and could mess stuff up)
	if amount > obj[setting] then
		task:AddAmount(obj[setting] * -1)
	else
		task:AddAmount(amount * -1)
	end
end
```