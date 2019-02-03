## Library Changelog

## v5.3 (Unreleased)
- List dialog will set width by width of list items.
- Added action names/ids to RetName.
- Added a tooltip to the toolbar of my dialogs letting people know about rolluping them up.

## v5.2 (28 Jan 2019)
- Trying to fix some log spam made some names show up as table:XXXXXX/Missing text.

## v5.1 (25 Jan 2019)
- Support for "Next SM Update".
- Added .visible to checks for List dialog (defaults to true).

## v5.0 (03 Jan 2019)
- List dialog was sometimes showing the value instead of the text for the list.
- Editor mode toggle wasn't showing selection text till the second time it's opened.

## v4.9 (23 Dec 2018)
- List dialog:
- > Items had shrunk to the size of the text.
- > Filter Items didn't work too well on number lists.

## v4.8 (15 Dec 2018)
- Pasting RGB(0,0,0) into the colour modifier now works with the blacklist.
- My Shift-Esc to close my dialogs action wasn't getting removed from terminal actions.
- List dialogs didn't have a horizontal scroll.

## v4.7 (10 Dec 2018)
- Updates scale of opened dialogs when user changes scale in Options.
- Mushed dialogs no longer spew stuff outside of their boxes.

## v4.6 (06 Dec 2018)
- Midly broke list choice filter (for certain last items).

## v4.5 (06 Dec 2018)
- Removed length limit of dialog titles.
- the bottom entry in list dialog was never filtered.

## v4.4 (01 Dec 2018)
- More strings.
- Support for more dialogs having icons in the title bar.

## v4.3 (30 Nov 2018)
- Strings mostly, some code cleanup.

## v4.2 (29 Nov 2018)
- Cleaned up some of the UI code.
- Some log spam from list dialog.
- Filter items wasn't clearing when the filter was blank.

## v4.1 (26 Nov 2018)
- You can now paste RGB(0,0,0) or RGBA(0,0,0,0) into the colour modifier.
- Pressing enter after entering text in the value textbox in the list dialogs will fire the ok button.

## v4.0 (25 Nov 2018)
- A setting that caused a few different issues...
- Updated my large popup msgs to be smaller.

## v3.9 (24 Nov 2018)
- Shift-Esc will close an in-focus dialog.
- Hopefully fixed an issue with Change Object Colour.

## v3.8 (24 Nov 2018)
- Moved my spawn colonist func here.
- Made my random colour func work better.
- Code cleanup.

## v3.7 (21 Nov 2018)
- Fixed shuttles not paying attention to newly added/removed hills/rocks.

## v3.6 (20 Nov 2018)
- Changed my msg func to use an object that works in the main menu as well as in-game.
- Gagarin changed how certain buildings work, so change object colour and examine weren't able to list all attachments.
- List dialog filter items checks for more text.
- Checkbox menu item background turns the same colour as other menu items.

## v3.5 (18 Nov 2018)
- Other mods using XShortcutsTarget shortcuts won't be borked from this mod.
- Cleaned up some strings.
- I'll get names right one of these days.

## v3.4 (16 Nov 2018)
- Broke my get obj name function last update.

## v3.3 (15 Nov 2018)
- Code cleanup/Gagarin.

## v3.2 (06 Nov 2018)
- Code cleanup.
- Moved all my buildings/vehicles into their own category.

## v3.1 (05 Nov 2018)
- Cleaned up my DeleteObject func to remove the (hopefully) last of the log spam.
- Returns names of (some more) tables.
- Popup menus close when parent closes.

## v3.0 (01 Nov 2018)
- Better compatibility with other mods that use custom shortcut keys.
- Returns names of (some) tables.
- Shows function file/line number instead of "function: 0000000008D7C100".
- Converted UI to Use TextStyle.

## v2.9 (30 Oct 2018)
- AnimDebug_Toggle wasn't removing oriention obj.
- Slight speed up for my random colour func.

## v2.8 (24 Oct 2018)
- Strings mostly (more of an update for ECM).

## v2.7 (24 Oct 2018)
- Code cleanup.
- More icons may show up in the list choices.

## v2.6 (20 Oct 2018)
- Forgot to change a line back, and broke some tooltip hints.
- It seems I broke my blinky object awhile back.

## v2.5 (20 Oct 2018)
- Added image scaling to PopupToggle.
- Sometimes tooltip image didn't show correctly.

## v2.4 (19 Oct 2018)
- Horizontal buttons added by my mods now have a hover shine (selection panel).
- Objects spawned by ECM (ctrl-shift-s) now have a selection particle around them.

## v2.3 (17 Oct 2018)
- List choice didn't show value in hint if it was false.
- Fixed Colonists>Set Gender New.

## v2.2 (12 Oct 2018)
- Right-clicking in list dialogs will update selection.
- Sped up ToggleCollisions func.

## v2.1 (12 Oct 2018)
- Code cleanup.

## v2.0 (10 Oct 2018)
- Cleaned up locales.
- Added more functionality to spawned entity objects.
- Fixed possible issue with RotatyThing (change object colour, and some others).

## v1.9 (8 Oct 2018)
- Fixed issue with the Need/Free stuff in cheats pane not working with all/modded buildings.
- Made sure clear markers will always clear markers.

## v1.8 (2 Oct 2018)
- Submenus added to PopupToggle.
- Cleaned up a minor issue with DotNameToObject.
- Fixed issue with some overridden keybindings (thanks Bobcupcatdolphin).

## v1.7 (30 Sep 2018)
- ECM bump.

## v1.6 (28 Sep 2018)
- More strings.
- Added another custom_type to ListChoice.
- Fix for shortcuts in multiple mods.

## v1.5 (28 Sep 2018)
- More strings.
- Added/Changed some funcs.
- Removed hint from list choice list box (still shows up for title bar and Ok button).

## v1.4 (26 Sep 2018)
- Sagan Update.

## v1.3 (25 Sep 2018)
### Changed:
- Misc touchups.

## v1.2 (22 Sep 2018)
### Changed:
- Darker list items, and some hover action.
- List filter items now checks hints as well.

### Fixed:
- Messed up some of my dialog positioning code somewhere along the line.

## v1.1 (17 Sep 2018)
### Changed:
- Double-clicking a title bar will rollup the dialog into the title bar.
- If a dialog is highlighted (in blue) Shift-Esc will close it.

### Fixed:
- Couple minor issues for list choice dialogs.

## v1.0 (12 Sep 2018)
### Fixed:
- Esc will close my dialogs if the title bar is blue.

## v0.9 (09 Sep 2018)
### Added:
- More functions.
- My actions reload code.
### Changed:
- Made turning off the log for ECM more obvious.
### Fixed:
- Missed the UIScale Msg

## v0.8 (08 Sep 2018)
### Fixed:
- Broke some of my selection buttons.

## v0.7 (07 Sep 2018)
### Changed:
- Removed some more ECM only functions.
### Fixed:
- My dialogs will try to use a parent object when being opened, added a fallback if they can't.

## v0.6 (06 Sep 2018)
### Fixed:
- Problem with Examine dialogs and ECM.

## v0.5 (05 Sep 2018)
### Fixed:
- Some menus may have shown "nil" for the title.

## v0.4 (05 Sep 2018)
- *Sigh*

## v0.3 (05 Sep 2018)
### Changed:
- What mods have to look for (needed a way for them to load as soon as this mod is loaded).

## v0.2 (05 Sep 2018)
### Added:
- My `_Functions.lua` file.

## v0.1 (05 Sep 2018)
### Added:
- Moved a bunch of usually used functions/etc from ECM to here.
