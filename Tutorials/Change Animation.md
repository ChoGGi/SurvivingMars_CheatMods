### How to change (built-in) animations (not permanent)

```lua
-- get a list of animations for object
obj:GetStates()
obj:GetStatesTextTable() --same as above, but not arranged alphabetically.

-- change to animation
obj:SetStateText("deployIdle")
obj:SetState("deployIdle")

-- numbered state
obj:GetState()
-- string state
obj:GetStateText()

-- ?
obj:GetStateMoments()
```
