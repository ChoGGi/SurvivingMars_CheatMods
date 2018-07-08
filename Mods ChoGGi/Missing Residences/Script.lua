-- See LICENSE for terms

local table = table
local DoneObject = DoneObject

local cleaned_res

local orig_GetFreeLivingSpace = GetFreeLivingSpace
function GetFreeLivingSpace(city, count_children)
  local res = city.labels.Residence or empty_table
  if not cleaned_res then
    for i = #res, 1, -1 do
      if res[i].class == "UnpersistedMissingClass" then
        DoneObject(res[i])
        table.remove(res,i)
      end
    end
    cleaned_res = true
  end

  return orig_GetFreeLivingSpace(city, count_children)
end
