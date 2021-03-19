### Adding hidden Milestones:

```lua
-- Change this when it gets completed (GlobalVar is stored in the game save)
GlobalVar("SomeUniqueID_WubbaLubbaDubDub", false)

-- check if it's already been enabled
if not SomeUniqueID_WubbaLubbaDubDub then
	SomeUniqueID_WubbaLubbaDubDub = true
	Msg("SomethingUnique_WubbaLubbaDubDub_OnMsg")
	Msg("SomethingUnique_WubbaLubbaDubDub")
end
```

```lua
-- this will fire when you Msg("SomethingUnique_WubbaLubbaDubDub_OnMsg")
function OnMsg.SomethingUnique_WubbaLubbaDubDub_OnMsg()
	-- temp milestone that's used till restart/load
	PlaceObj("Milestone", {
		-- you can just remove this if you don't want a notification popup (give 'em a little surprise)
		Complete = function(self)
			WaitMsg("SomethingUnique_WubbaLubbaDubDub")
			return true
		end,

		SortKey = 0, -- doesn't seem to matter, always adds to the end
		base_score = -100, -- MulDivRound(base_score, ChallengeRating, 100)
		bonus_score = -1000, -- if past sols then does nothing otherwise bonus based on time left
		bonus_score_expiration = 15, -- timeout in sols
		display_name = "Turned 100 colonists into goo: WubbaLubbaDubDub",
		group = "Default", -- ?
		id = "SomethingUnique_WubbaLubbaDubDub"
	})
	-- shows the green checkmark in milestone dialog, and the date next to it
	local mc = MilestoneCompleted
	if not mc.SomethingUnique_WubbaLubbaDubDub then
		mc.SomethingUnique_WubbaLubbaDubDub = 479000000 -- sol 666
	end
end
```

```lua
-- this one is used after milestone is unlocked and the game loads
function OnMsg.LoadGame()
	if SomeUniqueID_WubbaLubbaDubDub then
		PlaceObj("Milestone", {
			-- no need for "Complete" as it's already done
			base_score = -100,
			bonus_score = -1000,
			bonus_score_expiration = 15,
			display_name = "Turned 100 colonists into goo: WubbaLubbaDubDub",
			group = "Default",
			id = "SomethingUnique_WubbaLubbaDubDub"
		})
		-- it doesn't hurt
		local mc = MilestoneCompleted
		if not mc.SomethingUnique_WubbaLubbaDubDub then
			mc.SomethingUnique_WubbaLubbaDubDub = 479000000
		end
	end
end
```

#### To show user completed milestone
```lua
-- if you do want a little notification popup then call it like this instead
local Msg = Msg
Msg("SomethingUnique_WubbaLubbaDubDub_OnMsg")
Msg("SomethingUnique_WubbaLubbaDubDub")
local MilestoneThreads = MilestoneThreads
CreateRealTimeThread(function()
	local id = "SomethingUnique_WubbaLubbaDubDub"
	DeleteThread(MilestoneThreads[id])
	local milestone = Presets.Milestone.Default[id]
	local res = milestone:Complete(UICity)
	MilestoneThreads[id] = nil
	if milestone then
		MilestoneCompleted[id] = res and GameTime() or false
		if res then
			AddOnScreenNotification("MilestoneComplete", function()
				OpenXDialog("Milestones")
			end, {
				display_name = milestone.display_name,
				score = milestone:GetScore()
			})
		end
		ObjModified(MilestoneCompleted)
	end
end)
```
