-- list of entities we're going to be adding
local entity_list = {
	"SignExampleMetalDeposit",
	"SignExampleConcreteDeposit",
}
-- getting called a bunch, so make them local
local path_loc_str = string.format("%sEntities/%s.ent",CurrentModPath,"%s")
local mod = Mods.ChoGGi_ExampleNewResIcon

-- no sense in making a new one for each entity
local EntityDataTableTemplate = {
	category_Decors = true,
	entity = {
		fade_category = "Never",
		material_type = "Metal",
	},
}

-- local instead of global is quicker
local EntityData = EntityData
local EntityLoadEntities = EntityLoadEntities
local SetEntityFadeDistances = SetEntityFadeDistances

-- pretty much using what happens when you use ModItemEntity
local function AddEntity(name)
	EntityData[name] = EntityDataTableTemplate
	EntityLoadEntities[#EntityLoadEntities + 1] = {
		mod,
		name,
		path_loc_str:format(name)
	}
	SetEntityFadeDistances(name, -1, -1)
end

for i = 1, #entity_list do
	AddEntity(entity_list[i])
end

-- newly revealed deposits get this entity
function SubsurfaceDepositMetals:GameInit()
	self:ChangeEntity("SignExampleMetalDeposit")
end
function TerrainDepositConcrete:GameInit()
	self:ChangeEntity("SignExampleConcreteDeposit")
end

-- replace existing ones (that haven't been replaced yet)
local function ChangeEntityLabel(label,cls,new)
	for i = 1, #label do
		if label[i].entity ~= new and label[i]:IsKindOf(cls) then
			label[i]:ChangeEntity(new)
		end
	end
end

local function StartupCode()
	local l = UICity.labels
	ChangeEntityLabel(l.SubsurfaceDeposit,"SubsurfaceDepositMetals","SignExampleMetalDeposit")
	ChangeEntityLabel(l.TerrainDeposit,"TerrainDepositConcrete","SignExampleConcreteDeposit")
end

function OnMsg.CityStart()
	StartupCode()
end

function OnMsg.LoadGame()
	StartupCode()
end

--[[
testing crap

	sign1 = PlaceObj("SignMetalsDeposit")
	sign1:SetPos(c()+point(4000,0))

	sign2 = PlaceObj("SignExampleMetalDeposit")
	sign2:SetPos(c()+point(2000,0))

	sign3 = PlaceObj("SignExampleConcreteDeposit")
	sign3:SetPos(c())
--]]
