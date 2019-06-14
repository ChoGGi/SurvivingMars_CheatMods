
--~ -- They don't use palettes, so we can just skip this (just leaving it here as an example, also see my change rocket skin mod)
--~ local palettes = {
--~ 	Object.palette,
--~ }

-- No sense in creating a table each time we select one
local metals = {"SignMetalsDeposit", "SignExampleMetalDeposit"}
local concrete = {"SignConcreteDeposit", "SignExampleConcreteDeposit"}

-- make the paintbrush show up
function SubsurfaceDepositMetals:GetSkins()
--~ 	return metals, palettes
	return metals
end
function TerrainDepositConcrete:GetSkins()
--~ 	return concrete, palettes
	return concrete
end

-- they normally can't change skins so we need to make them able to (skip this for buildings)
function OnMsg.ClassesPreprocess()
	SubsurfaceDepositMetals.__parents[#SubsurfaceDepositMetals.__parents+1] = "SkinChangeable"
	TerrainDepositConcrete.__parents[#TerrainDepositConcrete.__parents+1] = "SkinChangeable"
end
