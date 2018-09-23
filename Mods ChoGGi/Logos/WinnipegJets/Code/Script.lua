local DelayedLoadEntity = DelayedLoadEntity
local PlaceObj = PlaceObj
local StringFormat = string.format

-- Mars Marx, eh close enough
local mod = Mods.ChoGGi_Logos_WinnipegJets
local ent_path = StringFormat("%sEntities/%s.ent",mod.env.CurrentModPath,"%s")

local function LoadDecal(name)
	pcall(function()
		-- needs to happen before the decal object is placed
		DelayedLoadEntity(mod,name,ent_path:format(name))

		PlaceObj("Decal", {
			"name",name,
			"entity_name",name,
		})
	end)
end
LoadDecal("WinnipegJets2011")
LoadDecal("WinnipegJets2018")

local logo_path = StringFormat("%sUI/%s.png",mod.env.CurrentModPath,"%s")
local function LoadLogo(name,display)
	PlaceObj("MissionLogoPreset", {
		display_name = display,
		decal_entity = name,
		entity_name = name,
		id = StringFormat("ChoGGi.Logos.%s",name),
		image = logo_path:format(name),
	})
end

function OnMsg.ClassesPostprocess()
	LoadLogo("WinnipegJets2011","Winnipeg Jets 2011")
	LoadLogo("WinnipegJets2018","Winnipeg Jets 2018")
end
