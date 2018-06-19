-- See LICENSE for terms

local table = table
local DoneObject = DoneObject

local function Stuff(workplaces)
	local sum_ui_on = 0
	local sum_ui_off = 0
--~ 	for i = 1, #workplaces do
  for i = #workplaces, 1, -1 do
		local b = workplaces[i]
    --neither func checks if the class is UnpersistedMissingClass, so easy enough fix
    if b.class == "UnpersistedMissingClass" then
      DoneObject(b)
      table.remove(workplaces,i)
    elseif not b.destroyed and not b.demolishing then
      if b.ui_working then
        sum_ui_on = sum_ui_on + b:GetFreeWorkSlots()
      end
      sum_ui_off = sum_ui_off + b:GetClosedSlots()
    end
	end
	return sum_ui_on, sum_ui_off
end

function GetFreeWorkplacesAround(dome)
  local city = dome.city or UICity
  return Stuff(city.labels.Workplace or empty_table)
end

function GetFreeWorkplaces(city)
  return Stuff(city.labels.Workplace or empty_table)
end
