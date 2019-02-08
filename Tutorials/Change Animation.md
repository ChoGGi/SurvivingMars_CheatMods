### How to change (built-in) animations (not permanent)

##### You can also use ECM: Select an object and press F4 then go to Object menu>Anim State Set

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
