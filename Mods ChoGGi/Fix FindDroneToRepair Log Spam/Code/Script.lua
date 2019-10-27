-- See LICENSE for terms

local IsValid = IsValid

function OnMsg.LoadGame()
	local broke = g_BrokenDrones
  for i = #broke, 1, -1 do
    if not IsValid(broke[i]) then
      table.remove(broke, i)
    end
  end
end
