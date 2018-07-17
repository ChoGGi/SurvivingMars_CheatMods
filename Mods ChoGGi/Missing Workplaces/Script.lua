-- See LICENSE for terms

local table = table

local cleaned_work

local function CleanWork(city)
  local work = city.labels.Workplace or empty_table
  if not cleaned_work then
    for i = #work, 1, -1 do
      if work[i].class == "UnpersistedMissingClass" then
        work[i]:delete()
        table.remove(work,i)
      end
    end
    cleaned_work = true
  end
end

local orig_GetFreeWorkplacesAround = GetFreeWorkplacesAround
function GetFreeWorkplacesAround(dome)
  local city = dome.city or UICity
  CleanWork(city)
  return orig_GetFreeWorkplacesAround(city)
end

local orig_GetFreeWorkplaces = GetFreeWorkplaces
function GetFreeWorkplaces(city)
  CleanWork(city)
  return orig_GetFreeWorkplaces(city)
end
