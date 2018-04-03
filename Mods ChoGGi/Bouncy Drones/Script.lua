--set all drone gravity on load
function OnMsg.LoadGame()
  for _,object in ipairs(UICity.labels.Drone or empty_table) do
    object:SetGravity(2000)
  end
end
