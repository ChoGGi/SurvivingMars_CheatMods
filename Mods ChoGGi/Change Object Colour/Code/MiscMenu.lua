--See LICENSE for terms

local Concat = ChangeObjectColour.ComFuncs.Concat
local T = ChangeObjectColour.ComFuncs.Trans

--~ local icon = "new_city.tga"

function ChangeObjectColour.MsgFuncs.MiscMenu_LoadingScreenPreClose()
  --ChangeObjectColour.ComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  ChangeObjectColour.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/[90]",T(1000207--[[Misc--]]),"/",T(302535920000021--[[Change Colour--]])),
    ChangeObjectColour.MenuFuncs.CreateObjectListAndAttaches,
    "F6",
    T(302535920000693--[[Select/mouse over an object to change the colours.--]]),
    "toggle_dtm_slots.tga"
  )

end
