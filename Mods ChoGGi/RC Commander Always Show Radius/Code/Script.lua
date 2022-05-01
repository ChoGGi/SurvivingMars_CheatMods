-- See LICENSE for terms

local IsKindOf = IsKindOf

function OnMsg.SelectionAdded(obj)
	if IsKindOf(obj, "RCRover") then
		obj:ShowWorkRadius(true, "selected_and_sieged")
	end
end
