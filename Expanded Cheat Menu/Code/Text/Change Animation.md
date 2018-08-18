### How to change (built-in) animations (not permanent)

```
--get a list of animations for object
Obj:GetStates()
Obj:GetStatesTextTable() --same as above, but not arranged alphabetically.

--change to animation
Obj:SetStateText("deployIdle")

--numbered state (not sure how to translate numbers to text)
Obj:GetState()

--?
Obj:GetStateMoments()
```
