
-- newly revealed deposits get this entity
function SubsurfaceDepositMetals:GameInit()
	self:ChangeEntity("SignExampleMetalDeposit")
end
function TerrainDepositConcrete:GameInit()
	self:ChangeEntity("SignExampleConcreteDeposit")
end

-- some research tech may replace the objects, so this will make sure they use our entity
SubsurfaceDepositMetals.entity = "SignExampleMetalDeposit"
TerrainDepositConcrete.entity = "SignExampleConcreteDeposit"

-- replace existing ones (that haven't been replaced yet)
local function ChangeEntityLabel(label, cls, new)
	for i = 1, #(label or "") do
		if label[i].entity ~= new and label[i]:IsKindOf(cls) then
			label[i]:ChangeEntity(new)
		end
	end
end

local function StartupCode()
	-- this way it'll only fire once per save instead of every load (or use GlobalVar() )
	if not UIColony.ChangedEntitiesExample then
		local l = UIColony.city_labels.labels
		ChangeEntityLabel(l.SubsurfaceDeposit, "SubsurfaceDepositMetals", "SignExampleMetalDeposit")
		ChangeEntityLabel(l.TerrainDeposit, "TerrainDepositConcrete", "SignExampleConcreteDeposit")
		UIColony.ChangedEntitiesExample = true
	end
end

-- for any added in the revealed map sector
OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

--[[
testing

	sign1 = PlaceObj("SignMetalsDeposit")
	sign1:SetPos(c()+point(4000, 0))

	sign2 = PlaceObj("SignExampleMetalDeposit")
	sign2:SetPos(c()+point(2000, 0))

	sign3 = PlaceObj("SignExampleConcreteDeposit")
	sign3:SetPos(c())
]]
