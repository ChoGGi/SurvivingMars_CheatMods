-- it seems the devs didn't remove all traces of the old PreciousMetalsExtractor sounds, or didn't add them all?
-- anyways this'll fix it
if LuaRevision <= 233467 then
  local function RestoreSounds()
    PlaceObj('Sound', {'name', "Object PreciousExtractor Select",'type', "ObjectOperation",'volume', 150,'mindistance', 2500,}, {PlaceObj('Sample', {'file', "Sounds/Objects/ExtractorPrecious/extractorUniversal_select1",'frequency', 50,}),PlaceObj('Sample', {'file', "Sounds/Objects/ExtractorPrecious/extractorUniversal_select2",'frequency', 50,}),})
    PlaceObj('Sound', {'name', "Object PreciousExtractor SelectIncomplete",'type', "ObjectOperation",'volume', 60,'mindistance', 1500,}, {PlaceObj('Sample', {'file', "Sounds/Objects/_ObjectSelection/object_incomplete1",'frequency', 50,}),PlaceObj('Sample', {'file', "Sounds/Objects/_ObjectSelection/object_incomplete2",'frequency', 50,}),})
    PlaceObj('Sound', {'name', "Object PreciousExtractor Complete",'type', "ObjectPhase",})
    PlaceObj('Sound', {'name', "Object PreciousExtractor LoopStart",'type', "ObjectOneshot",'mindistance', 1300,}, {PlaceObj('Sample', {'file', "Sounds/Objects/ExtractorPrecious/extractorUniversal_workstart1",'frequency', 50,}),PlaceObj('Sample', {'file', "Sounds/Objects/ExtractorPrecious/extractorUniversal_workstart2",'frequency', 50,}),})
    PlaceObj('Sound', {'name', "Object PreciousExtractor LoopStop",'type', "ObjectOneshot",'mindistance', 1300,}, {PlaceObj('Sample', {'file', "Sounds/Objects/ExtractorPrecious/extractorUniversal_workstop1",'frequency', 50,}),PlaceObj('Sample', {'file', "Sounds/Objects/ExtractorPrecious/extractorUniversal_workstop2",'frequency', 50,}),})
    PlaceObj('Sound', {'name', "Object PreciousExtractor LoopSmoke",'type', "ObjectOneshot",'mindistance', 1300,}, {PlaceObj('Sample', {'file', "Sounds/Objects/ExtractorPrecious/extractorUniversal_worksmoke2",'frequency', 50,}),PlaceObj('Sample', {'file', "Sounds/Objects/ExtractorPrecious/extractorUniversal_worksmoke1",'frequency', 50,}),})
    PlaceObj('Sound', {'name', "Object PreciousExtractor LoopPeaks",'type', "ObjectOneshot",'volume', 90,'mindistance', 1300,}, {PlaceObj('Sample', {'file', "Sounds/Objects/ExtractorPrecious/extractorUniversal_workpeak5",}),})
    PlaceObj('Sound', {'name', "Object PreciousExtractor Loop",'type', "ObjectLoop",'looping', true,'volume', 110,'mindistance', 1400,}, {PlaceObj('Sample', {'file', "Sounds/Objects/ExtractorPrecious/extractorUniversal_work1",}),})
    PlaceObj('Sound', {'name', "Object PreciousExtractor Demolition",'type', "ObjectDestruction",'mindistance', 2000,}, {PlaceObj('Sample', {'file', "Sounds/Objects/_ObjectDestruction/object_destruction1",'frequency', 15,}),PlaceObj('Sample', {'file', "Sounds/Objects/_ObjectDestruction/object_destruction2",'frequency', 15,}),PlaceObj('Sample', {'file', "Sounds/Objects/_ObjectDestruction/object_destruction3",'frequency', 15,}),PlaceObj('Sample', {'file', "Sounds/Objects/_ObjectDestruction/object_destruction4",'frequency', 15,}),PlaceObj('Sample', {'file', "Sounds/Objects/_ObjectDestruction/object_destruction5",'frequency', 15,}),PlaceObj('Sample', {'file', "Sounds/Objects/_ObjectDestruction/object_destruction6",'frequency', 15,}),PlaceObj('Sample', {'file', "Sounds/Objects/_ObjectDestruction/object_destruction7",'frequency', 15,}),PlaceObj('Sample', {'file', "Sounds/Objects/_ObjectDestruction/object_destruction8",'frequency', 15,}),})
    PlaceObj('Sound', {'name', "Object PreciousExtractor Fail",'type', "ObjectPhase",'volume', 120,'mindistance', 3000,}, {PlaceObj('Sample', {'file', "Sounds/Objects/ExtractorPrecious/extractorUniversal_fail2",'frequency', 50,}),PlaceObj('Sample', {'file', "Sounds/Objects/ExtractorPrecious/extractorUniversal_fail1",'frequency', 50,}),})

    -- and load up all the new sounds
    LoadSoundBanks(DataInstances.Sound)
    DataInstances.Sound = nil
  end

  function OnMsg.LoadGame()
    RestoreSounds()
  end
  function OnMsg.CityStart()
    RestoreSounds()
  end

end
