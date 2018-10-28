### How to change (built-in) animations (not permanent)

```
-- get a list of animations for object
obj:GetStates()
obj:GetStatesTextTable() --same as above, but not arranged alphabetically.

-- change to animation
obj:SetStateText("deployIdle")

-- numbered state
obj:GetState()
-- string state
obj:GetStateText()

-- ?
obj:GetStateMoments()
```
