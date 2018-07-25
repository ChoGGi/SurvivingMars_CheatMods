local cursors = table.concat{Mods.ChoGGi_ReplaceCursors.path,"Cursors/"}

-- this fixes all but the default cursor
MountFolder("UI/Cursors",cursors)

-- for some reason the default cursor doesn't get replaced with the above, so we do this crap

local cursor = table.concat{cursors,"cursor.tga"}

-- starting cursor when you first load the game
SelectionModeDialog.MouseCursor = cursor

-- all new cursors use the new one
const.DefaultMouseCursor = cursor
