## ECM Changelog

##### To do:
##### Dialogs: Change map, Monitor Info.

## v9.7 (Unreleased)
### Added:
- Examine Objects: It'll show a group of objects in an examine dialog instead of a single object (Shift-F4).
- Mark All to examine dialogs for objlists.

### Changed:
- Examine menu for console now shows object name for examine title, and has submenus for certain items.
- Moved Points To Train from Sanatoriums Schools to Buildings.
- Examine will only open one dialog per object examined (when you use it in a loop, and don't want a couple dozen dialogs).

### Fixed:
- Messed up the select object func last update? (thanks McKaby).
- Building Info>Production didn't work.
- Issue with Need/Free cheats not working on some modded buildings (thanks McKaby).

### Removed:
- Help>Interface>Toggle Signs: No point in having it as you can just use the built in one (I left the interface one since you can't? rebind that).
- Some Cheat panel text buttons for the wrong objects.

## v9.6 (30 Sep 2018)
### Changed:
- Added lightning strikes option to Disasters (also added option to set amount of missiles/strikes).
- Added mapdata setting options to Disasters.
- Slight random delay added to missiles/strikes (you can do as many as you want without it getting crazy laggy, just in case you want to watch a missile storm or something).
- Mod Upload will now also check for AppData/Mod Images/ModId_*.EXT (.png or .jpg), and upload those if found (ex: d16iXjT_5.png).
- > Since the upload function will delete images on workshop without screenshots in moddef and without asking, I might as well...
- > It also works with the "official" method of defining screenshots in your moddef.

### Fixed:
- Mystery Log skip was borked by Sagan (thanks Encei).

## v9.5 (28 Sep 2018)
### Added:
- Game>Camera>Reset: If something makes the camera view wonky you can use this to fix it.

### Changed:
- You can change concrete deposit amount/max in Cheats selection.
- Overrode the Empty Deposit cheat so it looks like 0, but it won't get removed (if you mis-click).
- Moved Presets menu to Debug as a submenu.
- Added settings to some more menu item hints.
- Added Ged Editor to the Tools menu in Examine.
- When you use a string to examine an object; you now need to pass ,"str" along with it: OpenExamine("ChoGGi.UserSetting","str")

### Fixed:
- Some menu item hints with settings in them weren't being updated.
- Made sure Mod Upload works correctly with screenshots.
- Some missing/borked text in menus.
- Measure Tool.
- Issue with shortcuts and multiple of my mods that use shortcuts.

## v9.4 (28 Sep 2018)
### Added:
- Help>Extract HPKs: Shows list of Steam downloaded mod hpk files, so you can extract them.
- Threads checkbox to Find Value (allows you to search thread func names).

### Changed:
- More info shown for threads in examine (with blacklist).

## v9.3 (26 Sep 2018)
### Fixed:
- Sagan Update.
- Destroy Object removed domes with buildings in them, which may cause a crash (thanks Encei).
- Inside buildings built outside weren't getting colonists (thanks Encei).

## v9.2 (25 Sep 2018)
### Fixed:
- Removed some log spam when blacklist is enabled.
- Use Last Orientation wasn't staying disabled (thanks McKaby).
- For traits list: Default option was mixed in with the rest of the traits.
- Nasty bug with Mysteries and StopWait (thanks SkiRich).

## v9.1 (22 Sep 2018)
### Changed:
- More info added to examine:userdata (thanks SkiRich).
### Fixed:
- Hopefully last issue with service stats buildings (thanks hchsiao).

## v9.0 (17 Sep 2018)
### Added:
- Fixes>Rocket Crashes Game On Landing: When you select a landing site with certain rockets; your game will crash to desktop.

### Fixed:
- Issue with Buildings>SpaceElevator>Export When This Amount (thanks SkiRich).

## v8.9 (12 Sep 2018)
### Added:
- Cheats>Research>Change Outsource Limit: How many times you can outsource in a row.
- Buildings>Points To Train: How many points are needed to finish training.

### Changed:
- Building Stats:
- > The list doesn't show the number multiplied by a thousand anymore.
- > You can now change buildings with stats that aren't services (residences, etc).

### Fixed:
- Building Stats were being overridden by Martian Festivals (thanks hchsiao).
- Some of the bindable stuff didn't have proper names in Options.

## v8.8 (07 Sep 2018)
### Added:
- Buildings>Always Clean: Some people don't like dust.

### Changed:
- Requires ChoGGi's Library:
- > https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374
- Dialog touch ups (colours, icons added).

### Fixed:
- Newly spawned service buildings will have the settings from Service Building Stats properly applied (thanks hchsiao).
- Upgraded buildings may reset some cheat settings (thanks hchsiao).
- Drones didn't have move speed cheat after being re-assigned (thanks hchsiao).

## v8.7 (04 Sep 2018)
### Changed:
- Build Spires Outside of Spire Point is now Remove Spire Point Limit.
- > You can now build spires anywhere in domes.
- Keys are now bindable in the options (if there's any menu items you want a shortcut for?).
- Change Logo/Upload Mod shows image in hint.
- Random Object Colour is more random.
- Change Colour:
- > Renamed to Color Modifier.
- > Attachment list item will now show a blinky when you click something in the list.
- > Object colour updates when you type in custom values (useful for Metallic/Roughness).
- Research Tech only shows tech not researched.

### Fixed:
- Wrong images in Mystery Log.
- For multi-select list choices one of the hints was missing.
- Examine popups would show a list from another examine.
- Find Value was using patterns instead of plain text.
- Unlock Locked Buildings broke (thanks Antipatiko).
- Service Building Stats (thanks hchsiao).

## v8.6 (02 Sep 2018)
### Added:
- Examine>Tools>UI Click To Select: Allows you to examine UI controls by clicking them.
- Help>List All Menu Items: Show all the cheat menu items in a list dialog.
- Game>Whiter Rocks: Helps the rocks blend in better when using the polar ground texture.
- Fix for freezing issue from mods sending a nil id to the onscreen notifications (Ambassadors mod).
- Buildings>Service Building Stats: Change amount of comfort, time it takes, etc (gardens and so on).
- Rockets
- > Max Export Amount: Change how many rares per rocket you can export.
- > Launch Fuel Per Rocket: Change how much fuel rockets need to launch.
- > Rockets Ignore Fuel: Rockets don't need fuel to launch.
- Buildings>Space Elevator
- > Instant Export On Toggle: Toggle Forbid Exports to have it instantly export current stock.
- > Export When This Amount: When you have this many rares in storage launch right away.
- > Import/Export Amount Per Trip: How much cargo space/ How many rares per.

### Changed:
- Cheats>Research>Add Points: Added option to reset sponsor points to default.
- Console additions now happen sooner (for ease of use during New Game screens).
- Change Colour (F6) has more attachments listed (the ones GetAttaches doesn't get...).
- Change Colour skips Metallic/Roughness when moving colour selector.
- Resources: Add Prefabs renamed to Prefab Buildings, and Add Funding to Funding.
- Tweaked dialogs a bit (colours, list item tooltip look, spacing, enter/esc work in lists).
- Find Value has a "Case-sensitive" checkbox now.
- Hints now show up for cheats toolbar items.
- Find Nearest Resource adds a blinky for ten seconds (it also doesn't select anymore).
- Added icons to some lists (example: research tech).
- Some lists just displayed <param1> in the tooltip since I was too lazy to get the actual value.
- Examine:
- > Examine UI Flash toggles visibility now (not everything works with borders).
- > OpenExamine("object_name"): Will examine "_G.object_name" (table example: "table.table.object")

### Fixed:
- Rocket>Change Resupply Settings (thanks XxUnkn0wnxX).
- Oxygen Need/Free wasn't working (thanks XxUnkn0wnxX).
- Shuttle speed broke in DA (thanks hchsiao).
- Shuttle capacity broke in DA (thanks hchsiao).
- Examine dialog getting wrong zorder when using "Destroy It".
- Buildings>Sanatoriums & Schools: Show All Traits wasn't toggling School traits (also changed it to a saved option).
- I broke a few building cheats when updating to DA.
- Set Sponsor/Commander broke in DA (thanks Dawnmist).
- Change Terrain Type now restores concrete/dome textures.
- Issue with Fully Automated Buildings (thanks hchsiao).
- Set Game Rules broke in DA (thanks SkiRich).

## v8.5 (26 Aug 2018)
### Added:
- Added a bunch of new debug stuff in DA
- > FPS Counter Location: Reposition the FPS counter.
- > DTM Slots Display: Got me, loaded textures I suppose.
- > Toggle Render: Shadows, objects, and such.

### Changed:
- Mod Upload now has support for packed mods (you need to manually pack them: ModFolder/Pack/ModContent.hpk).
- > If they force only .hpk mods then I'll make it automagical.
- Reset Rovers renamed to Reset Commanders (and it now takes the amount of drones into account).
- Re-added Object Manipulator (Examine>Tools>Edit Obj or F5).
- Building Info: Added "Outside Buildings" (just shows which grid they're connected to).

### Fixed:
- Fixed keyboard focus when using the inputs on my dialogs (whoops).
- Shortcut keys were still enabled even with DisableECM setting (thanks XxUnkn0wnxX).
- Pressing console key made the console log show up even when disabled (thanks XxUnkn0wnxX).
- Annoying Sounds Toggle (thanks XxUnkn0wnxX).
- Set Colonist Traits wasn't setting individual traits (thanks Dawnmist).

## v8.4 (21 Aug 2018)
### Added:
- Cheats>Anomaly Scanning (requested by Antipatiko).
- Console>Examine: I used to create a folder with some commonly examined objects/funcs, now it's a list saved in settings (thanks blacklist...).
- Console>Settings>Exec Code: The devs decided to add some brittleness when pasting text (-- for one).
- > You can use this for pasting chunks of code without worry (might also be easier to work on stuff).
- Wrap Lines checkbox to my text edit dialogs (read globally).

### Changed:
- Help>Text items now open a url to files on github (no reading mod files with blacklist).
- Manage Mysteries renamed to Mystery Log.
- Examine will now open even if the object is nil/false.

### Fixed:
- Examine: Some strings were changing text colour they shouldn't.
- Activating Last Constructed Building when there isn't one caused UI to somewhat stop responding.
- Bunch of other issues with buildings (building cheats issues continued).
- Drone Factory Build Speed reset on shift change (thanks hchsiao).
- log spammed with some msgs from functions that still work (whoops).

## v8.3 (19 Aug 2018)
### Changed:
- HelperMod not needed for normal usage of ECM (modders may still prefer using it).
- To import your old settings:
- > Go to %AppData%\Surviving Mars\Mods.
- > Open CheatMenuModSettings.lua in a text editor.
- > Go to Menu>ECM>Help>Edit ECM Settings
- > Replace the settings with your settings, and press OK.
- > Restart ECM to make sure settings are applied.
- Random Colour now also changes the Roughness/Metallic settings.
- ECM dialogs will size based on UI scale.
- Unlocked camera in Terrain Editor mode.

### Fixed:
- Not using English resulted in certain menu items not appearing.
- The list dialog Filter Text wasn't showing the full list when empty/on enter.
- Change Lightmodel Custom didn't save settings, and printed some text to console.
- Some errors in log about GetColorizationMaterial (not important, just annoying).
- That slight Examine delay was messing with scroll position on refresh.

## v8.2 (18 Aug 2018)
### Changed:
- moved Annoying Sounds from Menu>ECM>Misc to Menu>Game.
- Renamed Start Disasters to Disasters (since you can stop them as well).
- Added a slight delay for loading 15K+ objects in Examine.

### Fixed:
- Unlimited Wonders stopped working after DA update (thanks hchsiao), and restart no longer needed to disable.
- Shuttle speed didn't work (thanks hchsiao).
- Also fixed a bunch of building cheats (devs moved templates from DataInstances to Presets).
- The list dialog filter text wasn't working properly (getting values from full list instead of visible list).
- The Fuel rocket cheat in Cheats pane would freeze the game (thanks CenariusPL).
- Stop Disasters may not have always stopped dust storms.
- Certain settings were reset after restarting (thanks Dawnmist).

## v8.1 (16 Aug 2018)
### Added:
- ECM will now always show a msg in the log telling user how to turn off the log.

### Changed:
- Added .. to any menu items that are "folders".
- Console button "Console" renamed to "Settings".

### Fixed:
- Menu>ECM>Capacity was showing the waste capacity list rather than a menu popup.
- Opening an Examine dialog from the top of the history list made it go off-screen (thanks SkiRich).
- Disabling the console log breaks ECM (thanks wizisi2k).
- You couldn't type in edit text dialog when 128 lines.
- You couldn't scroll textures in the paint section of Terrain Editor.
- Lightmodels (back up your setting, as you'll have to manually redo if you have a custom one saved).

## v8.0 (15 Aug 2018)
```
If any developers read this: http://keepachangelog.com (especially Deprecated/Removed).
I'm not saying to do it with your release notes, but at least add a link to an actual change log.
For instance: Moving PopupNotificationPreset from DataInstances to Presets.

Please and thank you.
```

### Added:
- Debug>Toggle Flight Grid: Shows a square grid with terrain/objects shape.
- Fixes>Toggle Working On All Buildings: Does what it says (on n off, or off n on).
- Examine Object>Tools>Find Within: Search for text within object.
- Game>Terrain Editor Toggle: Raise/Lower/Smooth/Paint/etc.
- Console>Reload Menu: Fiddling around with the editor can cause ECM menu/shortcuts to break.

### Changed:
- RandomColour is slightly more random (lines for pathing, object colour, and so on).
- Off-screen ECM dialogs will be moved onscreen.
- Nicer looking menu items (and highlighting).
- Changed some of the grid toggle shortcuts (changed F2 to squares and removed F3).
- Delete Rocks now also removes all those little buggers (if it's too slow for you: let me know and I'll make it optional).
#### Examine:
- > Up/Down in Go to text scrolls to top/bottom (used to be just top).
- > Attaches menu highlights objects.
- > UI objects will now flash (like the ged window inspector, see Tools to disable).
#### Exec Code:
- > Multi line text support.
- > Now checks clipboard content before adding ChoGGi.CurObj.
#### List Dialog:
- > Change Colour is now applied when you select a colour (default checkbox to reset).

### Fixed:
- God knows.

## v7.2 (04 Aug 2018)
### Added:
- ECM>Building Info: Shows text above buildings with info about them (domes, drones, drone controllers, deposits, production).
- Game>List All Objects: A list of objects; double-click on one to select and move the camera to it.
- Fixes>Drones Not Repairing Domes: If your drones are just dumping polymers into the centre of your dome.
- Help>ECM>Modify ECM Files: Extracts files to ECM Folder\FilesHPK so you can edit them, or use in your mod.
- Help>Text: Stats = hardware info, Game & Map Info = lists objects, and shows log.

### Changed:
- Cheats menu tooltips now show the ECM setting value instead of game value.
- More menu items have the setting in the tooltip.
- Colonist Death Age now applies to newly born/arrived (it used to just affect current colonists).
- Trigger Disasters changed to Start Disasters.
- Added Metatron Ion Storm to Start Disasters.
- Examine shows length of index based tables/objlists in caption.
#### Path Markers:
- > Destinations for every shuttle (hopefully).
- > Game Time is default (ignored for Remove).

### Fixed:
- Problem with ECM and not having Mysteries DLC installed.
- Start Disasters>Missiles/Meteors weren't aiming properly (thanks Encei).
- Examine now shows CObject functions on objects that don't include Object.
- The Soylent Option was doing birthplace Indian instead of race Indian.
- Most of the Game>Render options ignored "Default" setting.
- Buildings>Instant Building: Now works with domes.

## v7.1 (30 Jul 2018)
### Changed:
- Cheat menu buttons work with utf now.

## v7.0 (30 Jul 2018)
### Fixed:
- Cheats menu was borked if the button names used any char that wasn't ASCII (thanks SkiRich).
- Examine and other dialogs I use also used the same font.
- Examine didn't work on everything (broke it in 6.9).

## v6.9 (29 Jul 2018, 4:14PM)
### Added:
- Cheats>Research>Instant Research: Instantly research anything you click.
- Examine to Cheats pane.

### Changed:
- Hide some items in the Cheats pane when they aren't needed (ex: WaterFree on a Casino).
- The selection radius for objects under the cursor is slightly larger.

### Fixed:
- Examine wasn't stopping the auto-refresh thread after dialog was closed.
- Cheats menu settings text wasn't updating (broke it in 6.8).

## v6.8 (27 Jul 2018)
### Added:
- Rockets>Change Resupply Settings: Shows a list of all cargo and allows you to change the price, weight taken up, and how many per click.
- Debug>Delete Saved Games: Shows a list of saved games, and allows you to delete more than one at a time.

### Changed:
- ECM won't create "ECM Scripts" folder until after you open the console.
- ItemList dialogs hide empty space now.
- Mod Upload will show a popup msg when upload starts.

### Fixed:
- Examine shows proper name next to metatable now.
- Some missing strings from last update.
- I broke some ECM dialogs.

## v6.7 (25 Jul 2018)
### Added:
- Fuel to Cheat pane: Fill up rocket with fuel.

### Changed:
- Research Tech defaults to "Unlock", if both are checked then "Research" takes precedent.
- ItemList dialogs now have a "Filter Text" box: Type text to have it only show those items, Enter to clear text.
- Moved Delete All Rocks to Game from Debug.
#### Examine:
- > table (len:0) now shows "Data" if it's an associative table.
- > Translated userdata now shows < "userdata" to let you know it isn't a string.

### Fixed:
- ECM would wig out if CheatMenuModSettings.lua was a blank file (thanks Royal Rudolf).
- Examine userdata wasn't always displaying correctly.
- Issue with SkipMissingMods/SkipMissingDLC not working.
- Mod Upload shows the mod title instead of <ModLabel>.

## v6.6 (20 Jul 2018)
### Added:
- Help>Mod Upload: Show list of mods to upload to Steam Workshop.
- Fixes>Toggles>Borked Transport Pathing: RC Transports on a route have a certain tendency to get stuck and bog the game down (high speed feels like normal speed). Defaults to enabled.

### Changed:
- Re-added Mission>Disaster Occurrences, and Mission>Game Rules (not all rules/parts of rules will apply).
- Examine shows more info about functions/threads.
- Added a Close button to the console.
- The Traits functions in Colonists were missing the "other" traits (thanks Nacira).

### Removed:
- DumpObject (DumpLua works the same).

### Fixed:
- Cheats pane was missing some items.

## v6.5 (13 Jul 2018)
### Added:
- Examine>Tools>Functions: Shows a list of all functions.
- Help>ECM>Edit ECM Settings File: No more having to browse to the AppData folder if you need to change something manually.
- Options to remove water/air consumption (Cheats pane, and Menu>Buildings).
- Auto-refresh toggle in Examine Object.

### Changed:
- Moved Flatten Terrain Toggle from Debug to Game
- Examine won't show Parents/Attaches buttons if there aren't any.
- Examine now translates any userdata to strings (if it can).
- Moved Delete Object into a separate folder for less accident-prone clicking.
- Added a confirmation dialog when pressing Delete All Rocks.

### Fixed:
- Wrong string for Buildings>Instant Build (thanks lufou1).
- Flatten Ground wasn't using saved radius till after it was adjusted.
- Dome Only checkbox didn't work.
- Slightly bypassed a weird flashing UI bug with clipping the colonist head amount for residence selection panels (thanks SkiRich).

## v6.4 (06 Jul 2018)
### Added:
- Help>ECM>Disable ECM: Disables menu, cheat panel, and hotkeys, but leaves settings intact. You'll need to manually re-enable in CheatMenuModSettings.lua file.

### Fixed:
- Object Cloner was only adding 50 resource to cloned deposits (thanks McKaby).
- FlattenGround: Fixed issue with pipes getting marked as uneven terrain (works on borked saves).

## v6.3 (02 Jul 2018)
### Added:
- Fixes>All Pipe Skins To Default: Large Water Tank + Pipes + Chrome skin = borked looking connections (thanks Akashi Konno).
- Typing &handle in console will open that object in the examiner.
- Fixes>Toggles>Colonists Stuck Outside Service Buildings: Sometimes colonists will keep getting stuck when leaving some buildings.

### Changed:
- Added most shortcut keys to settings file (not 1-9 for build menu).
- Misc>Clean/Fix All Objects: They actually clean/fix all objects now.
- Any ECM stuff using Traits/Specs/etc will now also use any mod added ones.
- Somehow missed specialization for exporting colonist CSV data.
- Fixes>Most>High Stutter With High FPS: Made the colonists more random.
- Fixes>Reset Rovers: Updated for another type of broke Rover.
- Moved Change Map from Debug to Game.

### Removed:
- Debug>Path Markers: Removed flags/text from markers, added real time option to the list.

### Fixed:
- Cheat Menu menu closing when you tab back in to SM.
- The Presets menu was a little sparse.

## v6.2 (28 Jun 2018)
### Added:
- Game>Autosave Interval: Change how many Sols between autosaving.
- Fixes>Remove Blue Grid Marks: Gets rid of any selection grids for stuff that isn't selected.
- Debug>Delete All Rocks: Some people just don't like rocks.
- Debug>Export Colonist Data To CSV: Makes it easier for spreadsheet players to get their fix.
- Debug>Debug FX: Bunch of hopefully useful info in console log.

### Changed:
- Renamed "Reset Rovers With Drones Stuck" to "Reset Rovers": It fixes a number of issues with them so....
- Hover effects for Console buttons.
- Debug>Write Logs: Moved to Console Button.

### Removed:
- Console: Clear Log (F9 still works), I wanted to keep all the console related stuff in the Console menu.

### Fixed:
- Broke Drone/Colonist/etc Move Speed (thanks satirawongwan).

## v6.1 (18 Jun 2018)
### Added:
- Debug>Flatten Terrain Toggle: Press Shift-F to get terrain height, mouse the circle around to make other terrain the same height, press Shift-F to finish.
- Windowed console log: It'll stay open between sessions, and keep the size/position.
- Examine Object Tools menu>separate menu items added for dump text/object, as view takes way too long on large objects.
- Some game functions to Help>Text.
- Show Mods Log to Console Scripts: No more having to quit to see mod errors (only startup ones).

### Changed:
- Moved F2 to Help>Hide Cheats Menu.
- Console>Show File Log: Flushes the stored log to disk and displays it in the console log.
- Stop Disasters will now remove dust devils.
- Write logs just writes console output now, I don't think I've ever seen anything useful in DebugLog.log (if you have let me know I'll add it back).
- Tidied up Help menu.

### Removed:
- Debug>Toggle showing console log (added as checkbox to Console menu).

### Fixed:
- Cables & Pipes No Chance Of Break wasn't actually working (thanks BLAde).

## v6.0 (13 Jun 2018)
### Added:
- New default notification icon.
- Translation file (good luck translating 1000+ strings, partial ones are fine send 'em in).
- Steam workshop.
- Added thanks for admbraden (gifted a Steam copy of SM, Deluxe Edition no less).

- Game>No More Pulsating Pins: If they get too annoying (this is an all or nothing setting)...
- Help>Text: Hopefully useful info for modders.
- Help>Readme: It shows ECM readme.
- Fixes>Reset Rovers With Drones Stuck Inside.
- Fixes>Reset All Colonists: Helps with certain freezing issues (mouse scrolls, WASD doesn't).
- Menu>Draggable Cheats Menu: Maybe you don't want to drag the menu around.
- Fixes>Toggle Collisions On Selected Object: If you built a dome around a rover.
- Added support for multiple folders to console scripts, and added a console history button as well.
- History textbox to Console (Scripts).

### Changed:
- No more help page popup when starting the mod editor, you'll have to use the *shock* help button.
- Snappier hints for lists.
- Clicking somewhere else removes focus from text input.
- Draggable Cheats Menu buttons have a larger clickable area.
- Changed the way I create dialogs, might be lingering issues.
- Added more stuff to Monitor Info.
#### Examine:
- > Dialog is now above console log text.
- > Moved most buttons into Tools menu.
- > Added Parents button menu: examine parents/ancestors.
- > Attaches is now a button menu as well.
- > Dump Text/Obj now opens a text box.
- > Right-click Next to scroll to top (useful on small items without a scrollbar).
- > Filter Scroll now ignores case (no more need to Capitalise queries).
- > Works with threads/functions again.

### Fixed:
- I broke certain popups in 5.3.
- Set Production wasn't setting back to default.

## v5.3 (03 Jun 2018)
### Added:
- Debug>Attach Spots Toggle: Toggle showing attachment spots for selected object.

### Fixed:
- Broke Start Mystery from Curiosity update.
- Issues with the menu showing properly.

### Changed:
- When you alt-tab back in with the console opened it'll be in focus.
- Larger/blacker font for Scripts button / Scripts menu items.
- restart/quit will not longer be the last cmd saved in console history.
- @@Object in console will show type(Object).
- !!Object will open object's attachments in object examiner.

## v5.2 (03 Jun 2018)
### Added:
- Fixes>Toggle: Rover Infinite Loop In Curiosity Update: This one is enabled by default as it could affect anyone and sucks if it does.
- Fixes>Colonists Trying To Board Rocket Freezes Game: Doesn't fix the underlying cause, but it works.

### Changed:
- Anim Debug Toggle will now show for just the selected object (or all if none selected).
- Use $ in console to translate translatable strings (ex: $SelectedObj.display_name).

### Fixed:
- Cheats panel wasn't working for rockets (and maybe more).
- I broke Close Dialogs in 5.1.

## v5.1 (02 Jun 2018)
### Added:
- Cheats>Keep Cheats Menu Position: The cheats menu will stay where you drag it.
- Debug>Measure Tool: It measures stuff... (Ctrl-M)
- Debug>Set Anim State: Useful for people working on custom models.
- Using @Function in console will call debug.getinfo(Function).
- !Object will move the camera and select that object.

### Changed:
- It seems Remove Yellow Grid Marks is still useful :)
- Moved a bunch of the non-cheaty stuff from Misc to Game (new menu).
- Restored ~ for opening object examiner in console (thanks SkiRich).
- Cheats Menu is now draggable.
- Moved Toggle Width Of Cheats Menu On Hover to "Cheats" menu.

### Fixed:
- I broke Change Colour/Find Nearest Resource in 5.0.
- The "All" options in Research Tech now work (thanks McKaby).
- Custom lightmodel wasn't using the correct name (it's always ChoGGi_Custom now).

## v5.0 (31 May 2018)
### Added:
- Misc>Render>Lights Radius: Further light radius/more bleedout of domes.
- Misc>Render>Terrain Detail: Bumpier looking ground
- Misc>Render>Video Memory: Probably a placebo effect above 2048, but so what.

### Changed:
- HigherRenderDist now also effects hr.DistanceModifier (instead of just hr.LODDistanceModifier).
- No more msg spamming the consolelog whenever you select something.

### Fixed:
- Research menu items were broke.

## v4.9 (31 May 2018)
### Added:
- Misc>Change Surface Signs To Materials: Changes all the ugly immersion breaking signs to materials (reversible).
- Scripts button in console: Place lua files in AppData/ECM Scripts, and be able to execute them with this.
- Fixes>Rebuild Walkable Points In Domes: Not sure if it'll actually help for anything, but it won't hurt.

### Changed:
- Curiosity Update.
- Limited width of cheats menu, and added option to Misc> to further limit width till mouse hover.
- Auto unpin list now shows names of auto unpinned objects (in the hints).

## v4.8 (26 May 2018)
### Changed:
- and Defence Towers Attack DustDevils (same).
- Follower shuttles show what they're carrying.
- Follower shuttles now break path when you move the mouse (they do get confused at times, figured decent tradeoff).
- Only shows shuttle control button when it's a follower shuttle.
- Follower shuttles now carry visible objects (ah yeah).
- Follower shuttles will now only pick up one item at a time.
- Moved "Launch Empty Rocket" from resource overview to "Rocket>Launch Empty Rocket".
- High FPS stutter fix now fixes another stutter bug (this one by colonists).

### Removed:
- Follower shuttles from ECM (use Personal Shuttles if you want it).

### Fixed:
- Removed an error msg that would happen if you removed this mod with defence towers built (didn't actually cause problems, just log spam).
- Shuttles were spamming error log bacause I made them pinnable.
- Non-follower shuttles won't swing by and check out your cursor anymore.

## v4.7 (23 May 2018)
### Added:
- Spawned shuttles can now pick up certain items (storage depots, resource drops, rovers and drones).
- Select the item you want to pick up and press "Ignore" so it toggles to Pickup,
- Leave it selected and the mouseover it, the shuttle will come and pick it up.
- Move to where you want to drop it, and change the shuttle to "Drop Item" (from pickup) and select an item nearby where you want it.
- Then the shuttle will drop the item next to your mouse cursor.
- If you have drones or resources in un-reachable spaces you can use this to move them :)

#### Shuttles:
- > Show Shuttle Controls: I've added controls to Shuttles/ShuttleHubs/Drones/RCs/Res depots, so you can pick and move them around, use this to hide the controls.
- > Spawn Shuttle Attacker: Spawns an attacker at the nearest tower to you.
- > Spawn Shuttle Friend: Spawns an friend at the nearest tower to you.
- > Spawned Shuttles Recall: Recalls all spawned shuttles back to their towers.

### Fixed:
- Spawned shuttles work much better now.

## v4.6 (22 May 2018)
### Added:
- Gametime path markers: Use Ctrl-Numpad . 2 3 to enable different pathing options on selected objects.
- ECM>Monitor Info: Shows separate grids and city info (so far, suggestions?).
- Fixes>Colonists Stuck Outside Rocket: If any colonists are stuck AND you don't have any other rockets unloading colonists.

### Changed:
- Infopanel Cheats are hidden till you mouseover "Cheats".
- Added delay to infopanel size resetting after mouse leaving.
- Moved Annoying Sounds from Buildings to Misc.
- Annoying Sounds: Added beep from RC Rovers with deployed drones.
- Shuttle pathing is slightly better.
- Toggle Infopanel Cheats with Ctrl-F2 (request from camk16).
- Added an Attaches button to object examiner.
- Added an Exec button to object examiner: ChoGGi.CurObj is whatever object you have opened in it (I'll get around to a multi-line text box one of these days).
- ^ It'll show results in the console log. With these two buttons; no more typing in object[1].table[3][2][4] anymore :)

### Fixed:
- No more colonists stranded outside of rockets.

## v4.5-1 (21 May 2018)
### Changed:
- Follower Shuttles are now Attackers and Friends (attack are the usual, friends don't attack dustdevils).
- Control is slightly better, but if you spawn a bunch they get a little single minded.

## v4.5 (20 May 2018)
### Added:
- Colonists>No More Earthsick: Colonists will never become Earthsick.
- Buildings>Storage Amount Of Diner & Grocery: Change how much food is stored in them (less chance of starving colonists when busy).
- ShuttleHub cheat pane:
- ShuttleFollower: Spawns a Shuttle that will follow your cursor, scan nearby anomalies for you, attack nearby dustdevils.
- ShuttleReturnF: Sends any spawned shuttles back (they'll head back after about four Sols (I'd go by fuel, but when they stop; they get magical fuel).
- Debug>Reload Lua: Fires some commands to reload lua files (use OnMsg.ReloadLua() to listen for it).

### Changed:
- The Solyent Option: Added ages/races/birthplaces/specs (I'm sure Hitler wanted a mars base too).
- SetColonistRaces: Added a little bonus gift.
- Add Applicants: Option to empty the pool of applicants.

### Fixed:
- Attach Buildings To Nearest Working Dome: Cleaned up code, and now all inside buildings without a parent dome will be added.
- The random colours for path markers wasn't working like it should've been.
- Crash using Fixes>Fire All Fixes (copied wrong func name in it).
- pressing the number keys after exiting to main menu popped up broken build menu.

## v4.4 (18 May 2018)
### Added:
- Buildings>Triboelectric Scrubber Radius: Sets the size of dust removal.
- Buildings>SubsurfaceHeater Radius: ^ same... 50 wide = 700+ power :)
- Buildings>Maintenance Free Inside: Buildings inside domes don't build maintenance points (takes away instead of adding).
- Colonists>Traits: Block For Selected Building Type: No more idiots.
- Colonists>Traits: Restrict For Selected Building Type: Only idoits.
- Misc>Find Nearest Resource: Select an object and click this to display a list of resources (also added to cheat pane for Transports/Drones).
- Fixes>Toggle: Psychologist Resting Bonus: The Psychologist profile is supposed to give a +5 sanity bonus to colonists during rest (now it will).
- Fixes>Fire All ### Fixed: One click to apply all the single use fixes (likely safe to use, they all check for borked stuff so).
- Fixes>Remove Particles With Null Polylines: Found on a broken mystery (meteor crashed into mirror sphere power decoy thingy).
- Fixes>Remove Missing Class Objects: Probably from mods that were removed.
- Fixes>Mirror Sphere Stuck: If you have a mirror sphere stuck at the edge of the map, and it just won't die/move...
- Fixes>Stutter With High FPS: If your units are doing stutter movement, but your FPS is fine then you likely have a unit with borked pathing.
- Debug>Delete All Of Selected Object: It gives a confirmation beforehand.

### Changed:
- "Change Amount Of Drones In Hub": Default to adding drones.
- Double right-click mystery in Manage Mysteries to see all past messages.
- Manage Mysteries will just remove the selected mystery instead all of the same mystery.
- Research>Research Queue Size: You can pick how many now instead of just 25 (it'll only show queue numbers up to 8, I'll see about adding some indicator).
- Limited DebugGridSize to 150 (67951 objects, you can go somewhere above 300, but crashy tendentia kick in).
- Gave Object Cloner a menu item.
- Labeled all fixes that repeat as "Toggle:".

### Fixed:
- Manage Mysteries didn't work that well at skipping blackcube one (spawned 12K of them and lagged like mad).
- Powerless buildings: I think I finally found all the different ways now.
- Powerless ^ was resetting on selecting tribbies and subheaters (just their power not everything).
- Debug>Visible Path Markers: Stopped after first path (whoopsie).
- Random Object Colour: Broke at the same time as path markers...

## v4.3 (16 May 2018)
### Added:
- Misc>Change Terrain Type: Green or Icy mars? Coming right up!
- Fixes>Sort Command Center Dist: Each Sol goes through all buildings and sorts their cc list by nearest (takes less then a second on a map with 3616 buildings and 54 drone hubs).

### Changed:
- Debug>Change Map: Changes to a usable map instead of broken empty ones (custom disaster settings still a no go).

### Fixed:
- Skip Mysteries didn't work for all sequences.
- Drones Carry Amount Fix didn't work for black cubes.
- Powerless Buildings didn't work with some upgrades.

## v4.2 (16 May 2018)
### Added:
- Cheats>Manage Mysteries: You can skip the current step or remove mystery.
- Buildings>Defence Towers Attack DustDevils.
- Misc>Change Entity: What if I want my drones to be little green men?
- Misc>Change Entity Scale: What if I want my little green men to be big green men?
- Colonists>Traits/University Grad Remove Idiot: University grads aren't idiots after all...
- Buildings>Always Dusty: Buildings will never lose their dust (unless you turn this off, then it'll reset the dust amount).
- Combined Build/Pass hex grid: Shift-F1.
- Fixes>Drones Keep Trying Blocked Rocks: If you have drones that keep trying to get to certain rocks; this may help.

### Changed:
- If you enable the full traits list, it now hides all but three till mouseover.
- Build/Pass grid keys are now Shift-F*.
- Set UI Transparency is now Ctrl-F3.
- Build/Pass grid is more transparent.
- Visible Path Markers:
- Added object class/handle to last marker.
- Added spheres to start pos.
- Increased height difference between markers.
- Improved positioning of markers
- Random colours don't get repeated.
- If two markers are in same position it'll remove one (flickering was annoying).
- Added option to skip flags (helps a bit on larger maps).

### Fixed:
- Set Funding was always resetting funds instead of only resetting funds when using default option.

## v4.1 (12 May 2018)
### Added:
- Misc>Change Light Model: Changes the lighting mode (temporary or permanent).
- Misc>Change Light Model Custom: Specify custom lightmodel settings.

### Fixed:
- Spammy msgs in console log when deleting grid objects (pipes/cables).
- DroneResourceCarryAmountFix wasn't working properly.

## v4.0 (12 May 2018)
### Added:
- Debug>Visible Path Markers: Shows the selected unit path or show a list to add/remove paths for rovers, drones, colonists, or shuttles.
- Fixes>Idle Drones Won't Build When Resources Available: https://www.reddit.com/r/SurvivingMars/comments/8ignpc.
- Fixes>Align All Buildings To Hex Grid: If you have any buildings not aligned to the hex grid.
- Debug>Toggle Showing Anim Debug: Shows some text with info about the model animation.
- Debug>Toggle Hex Passability Grid Visibility.

### Changed:
- Make All Colonists Renegades is now Set Renegade Status (not sure why you'd want to turn it off).
- Made the "Dome Only" checkbox always show for the colonist options (ignored unless you have selected a colonist)
- Toggle Hex Grids: Now uses hex grids instead of those hard to see circles.
- You can edit CheatMenuModSettings.lua and change DebugGridSize if you want larger grids (build/passability).

- Delete Object now supports multiple objects: Use Editor Mode and mouse drag.
- Most of the files are now stored in Files.hpk (you can use HPK archiver to extract and use the files if you want, see readme for help).

### Fixed:
- Buildings>Use Last Orientation: May sometimes place buildings not aligned to the hex grid (thanks kajb139).

## v3.9 (10 May 2018)
### Added:
- Rovers>Set Charging Distance: How far from cable Rovers will charge (move rover to toggle).
- Fixes>Drone Carry Amount: Drones only pick up resources from buildings when the amount stored is equal or greater then their carry amount (this forces them to pick up whenever there's more then one resource).
- Buildings>Empty Mech Depot: Empties out selected/moused over mech depot into a small depot in front of it.
- Shift-F6/Ctrl-F6 to randomise colours of selected/moused over objects (F6 for manual colour).
- Mission>Instant Mission Goal: Completes the sponsor goal (pretty sure the only difference is preventing a msg).
- Fixes>Project Morpheus Radar Fell Down: https://www.reddit.com/r/SurvivingMars/comments/8hjt5t.

### Changed:
- Setting production uses a more reliable method (it works for all buildings now), but I had to remove the cheats pane button.
- Added a "Dome Only" to the "Set Colonist X" cheats: select a colonist then open the menu item to apply to colonists in that dome only.
- Added a checkbox to The Soylent Option for picking a random resource instead of food.
- Drone Carry Amount is no longer automagically enabled, you need to manually enable it with Fixes>Drone Carry Amount (for that day when devs fix it).
- ColourRandom will change basecolor if the palette colours (possibly) can't be changed.
- RC to Rovers.

### Fixed:
- Screenshot took upsampled screenshot.
- Toggling Remove Building Limits didn't reset all limits.
- Cheats Powerless didn't work for some buildings.

## v3.8 (08 May 2018)
### Added:
- Buildings>Protection Radius: Change threat protection coverage distance (MDSLaser/DefenceTower).
- Drones/Work Radius RC Rover/DroneHub: Set how far from controller drones will work.
- Buildings>Annoying Sounds: Toggle annoying sounds (Sensor Tower, Mirror Sphere).
- Colonists>The Soylent Option: Turns selected colonist into food (between 1-5), or shows a list with homeless/unemployed.
- Research>Breakthroughs From OmegaTelescope: Normally only finds three.
- Buildings>Unlock Locked Buildings.

### Changed:
- Enabled the DroneResourceCarryAmount fix for any amount above one (instead of ten).
- Trigger Disasters: Added option to remove broken meteors (if your meteors are stuck on the ground).
- Removed shortcut key from Debug/Change Map.
- Building Orientation now also uses last selected object.

### Removed:
- Buildings>Add Mystery & Breakthrough Buildings.

### Fixed:
- Powerless Buildings didn't work for certain upgraded buildings.

## v3.7 (06 May 2018)
### Added:
- Cheats>Research>Reset All Research.
- Misc>Set UI Transparency (Shift-F3): Change transparency of UI items (build menu, pins, side panel, etc).
- Misc>Set UI Transparency Mouseover: Toggle removing transparency on mouseover.

### Changed:
- Cheats menu toggle is now saved and defaults to showing.
- Buildings>Build limit/spire point/instant build can now be toggled without restarting.
- Combined Set Charge & Discharge Rates, and changed key to Ctrl-Shift-R.
- Added options to opacity for showing invisible stuff (buildings, units, and markers).
- re-added the Mod Editor menu item (with a warning to save your game beforehand).
- Object Manipulator is less buggy (made it do some type checking for less crashing).
- Add Prefabs is less confusing (select item and change value).
- Tidied up menus (and some more icons).

### Fixed:
- Buildings>Build Spires Outside of Spire Point (thanks TardosMor).

## v3.6 (02 May 2018)
### Added:
- Buildings>Powerless Building: Toggle electricity usage for selected building type (and info panel cheats).
- Buildings>Unlimited Connection Length: No more length limit on pipes, cables, and passages.
- Buildings>Set Charge/Discharge Rates for storage buildings (air/water/elec).
- Misc>Auto Unpin Objects: Block certain stuff from being added to the pinned list.
- Capacity>Storage Mechanized Depots Temp: Allow the temporary storage to hold 100 instead of 50 cubes.
- HideSigns in cheats panel (hides any signs above building till state is changed).

### Changed:
- Merged all the building settings into one (hopefully shouldn't make a difference to you, but if you lose capacity or something then send me your settings file please).
- Commander/Sponsor bonus lists now show enabled status.
- Alt-D is now Shift-D (since Alt-D is a built-in shortcut to rotate camera).
- Fill/Dismantle drones of dronehub is now "Change Amount Of Drones In Hub".
- Breakthroughs per game is now a list.

### Removed:
- 1000000 points per outsource (you can just add research points, or spam free outsourcing).

### Fixed:
- Issue with storage depots (thanks Pernicio).
- Some settings weren't being applied to mod buldings.
- Changing capacity of storage buildings (air/water/elec) wouldn't always result in correct "mode" msg.

## v3.5 (30 Apr 2018)
- Storage capacity of mechanized depots.
- Colonist/Drone/RC move speed.
- Drone rock to concrete speed.
- Set Worker Capacity, and WorkersDbl (to infopanel).
- Infopanel will show workers as a vertical list if you have more then 14.
- Fix All Objects/Clean All Objects.
- Debug>Close Dialogs (closes dialogs created by ECM).

### Changed:
- Change Colour: "All of type" now works with attachments, pipes, and cables.
- Change Colour: Added checkboxs to only change colours of that grid (air/water/elec).
- Object Manipulator: You can now add new entries, use nil to remove entries, edit tables, and enter refreshes list.
- Storage depot capacity change is back to being instant.
- Moved missiles into trigger disasters.
- List dialogs/change colour don't pause the game anymore.
- Min Comfort Birth is now a list choice.
- Change Colour: Double-click in the colour area to apply colours without closing dialog.

### Fixed:
- Re-setting some settings would freeze the menu.

## v3.4 (28 Apr 2018)
### Added:
- Object Manipulator: Easier way of editing object values instead of using console (access with F5 or Edit button in Object Examiner).
- CleanAndFix cheat to RCs/Drones.

### Changed:
- Change Colour now works with attachments (also moved the menu item to Misc, though you'll need to use F6 anyways for rocks/etc).
- Added a base color modifier to Change Colour (you can change the colour of more items, like rocks/signs).
- Esc just removes focus from text boxes now (just for windows ECM opens), Use Shift/Ctrl + Esc to close).
- Set Commander/Sponsor Bonus are lists with multiple selection.
- Set Commander Bonus works for modded ones now (Sponsor only checks cargo space/research points for now).
- More items in Disaster Occurrence list.
- Some menu item descriptions.

### Fixed:
- Research Stuff updated for Opportunity (and future-proofed) (thanks tarasque999).
- Infopanel hints weren't showing up.
- Changing gamespeed to default stops you from being able to use/change medium/fast speed.
- Change logo/sponsor/commander were broke in Opportunity.
- Change logo only changed one logo per object.
- Set Production default was setting to default * 1000.
- Disabling Fully Automated Buildings was making WorkAuto performance 0.
- Issue with changing production and updating grid production values (thanks JesseWV).

## v3.3 (26 Apr 2018)
### Added:
- ColourRandom/ColourDefault to infopanel cheats
- Buildings>Change Colour (F6): doesn't work on all buildings, use ColourRandom to quickly find out.
- Buildings>Use Last Orientation (F7): If you want toggle using the last placed building orientation.
- Misc>Set Opacity (F3): Change opacity of selected/moused over objects (works with random rocks).

### Fixed:
- Never Show Hints wasn't working till after restarting.

## v3.2 (25 Apr 2018)
### Added:
- Help>Reset ECM Settings (seems like it might be needed here and there).
- Larger notification msgs, cleaned up some msgs.

- Changed
- Tidied up the menus.
- Mouse Border Scrolling now a list, I think it's dependant on aspect ratio, so do what you wish, or 0 to disable scrolling.

### Fixed:
- Shadowmap Size wasn't going back to default.
- RC Transport Storage Capacity wasn't opening after commit/d50a20b80c2b724512b5f8c67a3f5ef3c3ff6e8a
- The fix in 3.0 for Certain researched items wouldn't be unlocked wasn't setting some stuff properly (thanks LBraden and Snuchums).
- Issue with certain items be set to a lower amount.
- Storage Capacity was toggling between default and max instead of custom.

## v3.1 (22 Apr 2018)
### Fixed:
- FullyAutomatedBuildings (menu item was missing)
- DroneCarryAmount (minor issue when it was disabled)

## v3.0 (22 Apr 2018)
### Added:
- Workaround for having more then 10 drone carry amount (you want giant stacks on small drones; have at it).
- Misc>Instant Colony Approval: I'm sure your colonists will be fine.
- Drones>Add 20 Drones to Selected DroneHub (removed alt-f from fill and stuck it here).
- Some more scanning/map options (and merged them all into Cheats>Map Exploration.
- Infopanel: Cheats,Residents,Traits are now height limited till mouseover (for those with large "lists").

### Changed:
- Camera Zoom and Higher Render Dist are now lists.
- Better hint popups for list choices.
- Object Examiner:
- Improved text handling in goto box.
- Moved button out of the way of the goto box.

### Removed:
- Colonists>Traits>Set Individual Traits (merged into Set Traits).

### Fixed:
- Certain researched items wouldn't be unlocked after restarting game (thanks LBraden).
- You will need to delete your ECM settings file for this to take effect (or toggle the correct menu item).

- CropFailThreshold was broken.
- Some stuff wasn't working properly till a restart.
- ECM was retrieving some defaults based on tech discovered not researched.
- Black screen on new game (thanks khuffsmp/northsidedown).

## v2.9 (20 Apr 2018)
### Added:
- Building Placement Orientation: Any object you place will have the same orientation as the last placed object.

### Fixed:
- Fixed some errors that could occur.

## v2.8 (19 Apr 2018)
### Added:
- Debug>Objects Stats (you can change the size/colour of stuff).
- Sets shuttle/drone settings whenever they spawn (instead of just at load).
- Debug>Object Spawner (not recommended to use this on a save you care about).
- Colonists>Set New Colonists Specialization; default, random, or all the same.
- Colonists>Traits>Trait Add/Remove: add/remove a single trait from all colonists.
- Option to make all colonists renegades (or single in cheat pane).
- Drones>DroneFactory Build Speed
- Fill Selected DroneHub With Drones (Alt-F).
- Dismantle All Drones Of Selected Hub (Alt-D).
- Option to add an amount of research points.

### Changed:
- Merged a lot of menu items into list dialogs, and added option for using custom values.
- Also merged all the unlock research menu items, as well as removed the original ones.
- Clone Object shortcut is now Shift-Q (forgot I used Ctrl-Shift-C for building capacity).

### Fixed:
- Added a bunch of limits to stuff (prevents crash/save game issues).
- set new age/gender/gravity wasn't working for colonists arriving from earth.
- Had to toggle twice to show cursor for free camera

## v2.7 (16 Apr 2018)
### Added:
- Object Cloner (Ctrl-Shift-C). You can clone almost anything, and place on uneven terrain (without martian ground viagra).
- Randomize all colonists (Age,Gender,Race,Specialization).
- Colonists>Stats>Fill All Stats Of All Colonists (Health,Sanity,Comfort,Morale).
- Set race of all colonists (Colonists>Race).
- RandomRace in colonist cheat pane.
- Examine: Dump object button.
- Added popup hints to most info pane cheats.

### Changed:
- Examine: Dump button just dumps the text now (and it's called Dump Text).

### Fixed:
- My cleanup function was deleting a file it shouldn't, and causing the mod to stop working after the first start.
- 5760*1080 wasn't setting new zoom till zooming to the map view.
- Attach Buildings To Nearest Dome didn't actually work (you can't demo a dome with buildings in it).

## v2.6 (14 Apr 2018)
### Added:
- Instantly start mysteries (Cheats>Start Mystery).
- Help>Interface>Never Show Hints (no need to see hints on a new game).

#### Colonists will now use inside buildings that are outside (you need to have at least one dome placed), colonists will still use the dome.
- > To get workplaces working; increase Outside Workplace Radius, and some of the buildings don't really work correctly (diner).
- > Expect bugs: this isn't how the game is supposed to work...

## v2.5 (14 Apr 2018)
### Added:
- Buildings/Cables & Pipes: No Chance Of Break (removes the chance of them ever breaking, without using instant upgrade).
- Infopane cheats for colonists (stats, age, gender, performance, random specialization)

### Changed:
- Re-added storage depot amounts (they only take effect after restarting), added limits to prevent save files being deleted.
- Ctrl-Shift-Space now works with deposits (concrete ones won't get filled).
- Fully Automated Buildings only does 100% perf instead of 150% (you can always boost production if you want it).
- Changing production/capacity on all types of a building on larger maps might be slightly faster.
- Build menu will now close if you press the same number as the category you have opened.
- Unlock all buildings now updates construction menu without having to re-open it.
- When you change a child to youth+ age, it kicks them out of the nursey, same for a youth+ to child.

### Fixed:
- Added production was being reset after toggling power (still resets for certain items, see Known issues).
- building storage capacity was ignoring the new values.
- Opening console with tilde no longer results in a grave accent being added.
- Add/Remove Negative Traits was backwards (thanks ClearanceClarence).
- RC Transport Storage Increase wasn't working correctly (numbers for newly placed still don't add up correctly as I'm adjusting the base amount, and lazy).
- ChoGGi.ReturnTechAmount() wasn't returning a proper percent.
- A few menu items weren't resetting to the upgraded default (just the default).
- Changing gender from male to female (or vice) wouldn't update the entity model.
- Set age to retiree stopped working last update.

## v2.4 (10 Apr 2018)
### Added:
- Option to disable texture compression (QoL/Render/Disable Texture Compression Toggle).
- Option to set shadow map size (QoL/Shadow Map), see https://www.nexusmods.com/survivingmars/mods/35 for comparison shots.

### Changed:
- Moved Debug>Render settings to QoL>Render

## v2.3 (10 Apr 2018)
### Added:
- Set death age to 250 for all colonists (Colonists>Age>Set Death Age To 250).
- Add 250 Applicants (Colonists>Add Applicants).
- Select build menu categories with numbers (shift-number for menus above 10).
- Select different Sponsor/Commander.
- Farm Shifts All On (Buildings>Farm Shifts All On).
- Add Sponsor/Commander bonuses to current Sponsor/Commander.
- Ctrl-Alt-Shift-D to delete object (selected or object under mouse).
- Toggle interface in screenshots, defaults to enabled (Help>Screenshot).
- Option to save showing full list of traits for school/sanatorium.
- AllShifts added to farms cheat pane.
- Option to fix black cube colonists (Colonists>Work>Fix Black Cubed Colonists).

### Fixed:
- Giving children a specialty makes them black cubes (same with making a child an adult then giving them a spec) (thanks ClearanceClarence).
- Maintenance Free Toggle wasn't working (toggle it off and on to update it) (thanks huldu).
- Menu items for school/sanatorium were backwards.
- Forgot to mention for 2.2: Colonists can be deleted.
- Having to press cursor toggle twice before it starts toggling.
- The border scroll width was too small for some people (it's 3 instead of 2 now).

## v2.2 (08 Apr 2018)
### Added:
- Added AutoWork/ManualWork to cheat pane.
- Option to change logo (QoL>Logo).
- Added Orbital Probes to Resources menu.
- Hide certain items in cheatpane (QoL>Infopanel Cheats Cleanup).
- Set occurrence level of disasters.

### Changed:
- Follow Camera distance is consistent now.
- Hides the console log when using Follow Camera (camera going through glass = spammy log).
- Higher render dist/shadows default to off, as higher zoom also defaults to off.
- Added option for minimal border scroll mouse activation area (QoL>Camera/Border Scrolling Area).
- Cleaned up some menu descriptions.

### Removed:
- Domes from Instant Build (use Alt-B for them).

### Fixed:
- Console stopped working after loading a different game.
- Remove Building Limits works properly.
- Using Instant Build would make domes not have the bottom texture till you placed an inside building somewhere.
- Restricted Delete Object from deleting domes (can freeze game).

## v2.1 (05 Apr 2018)
### Changed:
- Updated for Spirit update
- Using up/down history in console places cursor at end of text instead of start
- re-added the AddConsolePrompt function (not sure why they removed it...)
- Object Examiner now opens at the mouse cursor.
- You can examine objects under cursor without having to select them.

### Fixed:
- F5 dumps info from Examiner instead of dumpobject
- Screenshots are quicker.

## v2.0 (03 Apr 2018)
### Changed:
- Completely disabled depot storage cheats till I figure it out.
- Drone Repair Supply Leak Toggle: Changed time to 1 instead of 0, to stop drones from ignoring leaks.

## v0.9 (03 Apr 2018)
### Fixed:
- Universal/Other depots don't have to be emptied or be newly placed to take advantage of new size.
- FullyAutomatedBuildings wasn't working if you didn't have a building selected.

### Known issues:
- Doubling amount of placed waste rock storage adds rocks to it.
- Increasing amount of storage in waste depot is ignored in already placed ones.
- > Increase before placing or use CheatEmpty.

## v0.8 (02 Apr 2018)
### Added:
- Options for higher render/shadow distance (on by default):
- You can change HigherRenderDist from true to a number default is 120, I use 600
- Debug>Render to toggle

### Changed:
- Examine>Dump uses DumpedExamine.lua for name instead of DumpedText.html
- You can now move around in editor mode, and the statusbar shows what you have selected

### Fixed:
- Toggling editor mode no longer sometimes changes the texture resolution
- FillResource doesn't show msg when nothing selected
- Universal/Other storage don't change each others capacity
- Using Remove Building Limits and placing buildings will sometimes cause placement mode to stick.

### Known issues:
- Doubling amount of placed waste rock storage adds rocks to it.
- increase beforehand

## v0.7 (02 Apr 2018)
### Added:
- Added Gameplay>QoL>Follow Camera (Ctrl-Shift-F to toggle, Ctrl-Alt-F to toggle mouse cursor)
- Added Gameplay/Building/Production Amount + 25 (Ctrl-Shift-P, Works on any building that produces)
- Set Gravity for Colonists,Drones,RCs (bouncy time)
- Added a bunch of items to the cheat pane

### Fixed:
- Fixed Ctrl-Space/Ctrl-Shift-Space not working on some items
- Hopefully fixed the waste rock not emptying issue for good...
- No more html tags when using Examine>Dump button

## v0.6 (31 Mar 2018)
### Added:
- Ctrl-Alt-Shift-R: opens console and puts restart in it
- Ctrl-Space: Opens placement mode with the last placed item
- Ctrl-Shift-Space: Opens placement mode with the selected item
- Added the (useless) RC Desire Transport

### Changed:
- Put Gameplay/Qol when it should be Gameplay/QoL

## v0.5 (30 Mar 2018)
### Added:
- Gameplay/Colonists/
- Fire All Colonists
- Turn Off All Shifts
- Turn On All Shifts

#### Gameplay/Capacity/
- Increasable Capacity Colonist/Visitor/Battery/Air/Water

#### Gameplay/Buildings/
- Repair Pipes/Cables (instantly reapairs them all)
- Crop Fail Threshold Toggle (lower the thresholdto 0)
- Build Spires Outside of Spire Point
- Allow Dome Forbidden Buildings
- Allow Dome Required Buildings
- Allow Tall Buildings Under Pipes
- Instant Build
- Remove Building Limits:
- Buildings can be placed almost anywhere (no uneven terrain, it messes the buildings up)
- no tunnels in domes either I'm afraid, but unlimited tunnel length :)

#### Gameplay/Colonists/Stats/
- See Dead Sanity Damage Toggle
- No Home Comfort Damage Toggle

#### Gameplay/Drones/
- ShuttleHub Shuttles Increase

- Gameplay/Speed/Added more speeds: Octuple,Sexdecuple,Duotriguple,Quattuorsexaguple

- Gameplay/Resources/Add Funding/### Added: 100,000 M,1,000,000,000 M,and reset to 500 M

#### Debug/
- Toggle Editor (you can move stuff around (if you really want a bunch of colonists moving around inside a dome that isn't there anymore)
- Open In Ged Editor (lets you open some objects in the ged editor)
- Asteroids (single,multi,storm)

- Cheats/Start Mystery (the original ones didn't work, but they came like that so...)

### Changed:
- Limited height of colonist list in info pane (side effect: crops a bit of the head icon)

### Fixed:
- Hopefully fixed the waste storage blockage
- Fixed some more incorrect menus (should be all good now)

## v0.4 (27 Mar 2018)
### Added/Changed:
- Bumped the RC Transport storage capacity amount given to 256 (from 100)

#### WriteDebugLogs:
- Fixed some issues with WriteDebugLogs
- They get stored them in logs folder now
- Now stores console output, so if you type Consts, all that output is now saved

#### Examine:
- Added a Dump button to the Examine Dialog
- added console command for Examine
- examine(SelectedObj)
- or shortform ex(Consts)

#### Menus:
- Made the toggle msgs more useful
- option to increase colonists capacity in Arcology
- ExplorationQueueMaxSize default is now 10

- boosts capacity by 1024 each time
- Gameplay/Buildings/Capacity/Storage Waste Depot
- Gameplay/Buildings/Capacity/Storage Other Depot
- Gameplay/Buildings/Capacity/Storage Universal Depot

### Fixed:
- Fixed waste storage not storing waste

## v0.3 (26 Mar 2018)
### Fixed:
- Broke a bunch of menu toggles
- Possible freezing issue when opening menus

## v0.2 (26 Mar 2018)
#### Changed:
- Console now shows results along with history (typing Consts.DroneRechargeTime will show 40000, and 1+1 will show 2)
- Added further zoom toggle (see more area, and zoom in further, but it also speeds up scrolling)
- I've redone the menus, so they toggle now. The description will show if the cheat is enabled or disabled.
- If a menu has "+ num" then it'll increase it by that number each time

#### Menus:
- Gameplay>Colonists>New: Set sex/age of new colonits (births and new arrivals)
- Cheats>Research>Double Amount of Breakthroughs per game (allow 26 breakthroughs)
- Debug>Write Debug Logs: writes debug logs to AppData

#### Gameplay>Buildings:
- Add Mystery|Breakthrough Buildings: Show all the Mystery and Breakthrough buildings in the build menu
- Fully Automated Buildings: Adds an upgrade to factories, so you don't need colonists
- Show All Traits Toggle: Shows all appropriate traits in Sanatoriums/Schools
- Sanatoriums Cure All Toggle: Sanatoriums now cure all bad traits
- Schools Train All Toggle: Schools now can train all good traits
- Sanatoriums|Schools Show Full List Toggle: Toggle showing 16 traits in side pane

#### Toggle>Camera:
- Camera Zoom Speed (faster)
- Camera Zoom Distance (further, and closer)
- Border Scroll (stop scrolling with mouse on border)
- Also shrunk the size of the area at the border you need the mouse to be in to activate scrolling

## v0.1 (24 Mar 2018)
- Found some more menuitems to unhide
- Added icons to some menuitems

#### Keys:
- F2: Doesn't toggle Infopanel Cheats anymore (just menu)
- F4: Open object examiner for selected object
- F5: Dump info for selected object to file (AppData/DumpedText.txt)
- Ctrl+F: Fill resource of selected object

#### Toggles menu:
- Infopanel Cheats
- Block CheatEmpty (stop CheatEmpty from emptying resources)
- Storage Depot|Waste Rock Hold 1000
- Building_wonder (allow multi wonders)
- Building_hide_from_build_menu (show hidden stuff)

#### Debug menu:
- Debug>Destroy Selected Object
- Debug>Asteroid attack (single or bombardment)
- Debug>Examine selected object
- Debug>Dump info for selected object to file (AppData/DumpedText.txt)
- Debug>Toggle Hex Build Grid Visibility (works now)

#### Console:
- Can now open with tilde as well (but it adds a `` ` ``)
- Added option to toggle showing history on-screen
- Added option clear history
- Added restart cmd
- Added dump cmd: dump(obj,type,filename,ext)
