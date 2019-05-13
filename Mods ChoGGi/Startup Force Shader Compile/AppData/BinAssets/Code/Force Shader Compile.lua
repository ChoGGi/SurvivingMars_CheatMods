-- override function so we can pass blank path
local orig_InitRenderEngine = InitRenderEngine

-- path is normally "Packs/ShaderCache%s.hpk", %s being either d3d11, opengl, or gnm (ps4)
-- passing nil or "" crashes it, but a space seems good enough that it skips the precompiled shaders
--~ function InitRenderEngine(path)
function InitRenderEngine()
	return orig_InitRenderEngine(" ")
end
