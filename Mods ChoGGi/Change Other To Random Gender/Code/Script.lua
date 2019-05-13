local AsyncRand = AsyncRand
local genders = {"Male", "Female"}

local function ChangeGender(c)
	if c.gender == "OtherGender" then
		c:RemoveTrait("OtherGender")
		local gender = genders[AsyncRand(2 - 1 + 1) + 1]

		c:AddTrait(gender)
		c.gender = gender
		c.entity_gender = gender
		c:ChooseEntity()
	end
end

OnMsg.ColonistArrived = ChangeGender
OnMsg.ColonistBorn = ChangeGender
