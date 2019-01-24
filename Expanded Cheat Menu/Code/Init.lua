function PDX_Upload(ged_socket, mod, params)
ex(mod)
ex(params)
  local err
  local pack_file_size = io.getsize(params.os_pack_path, true)
  if pack_file_size > 104857600 then
    local in_mb = pack_file_size / 1048576
    return false, T({
      1000796,
      "Packed mod file size must be up to 100MB (current one is <filesize>MB)",
      filesize = in_mb
    })
  end
  local file_timeout
  if io.exists(params.os_pack_path) then
    err = AsyncOpWait(file_timeout, nil, "AsyncPopsModsUploadContent", mod[params.uuid_property], params.os_pack_path)
  end
  if err then
    return false, T({
      1000797,
      "Failed uploading mod content package (<err>)",
      err = Untranslated(err)
    })
  end
  local max_image_size = 1048576
  local os_thumbnail_path = mod.image ~= "" and ConvertToOSPath(mod.image)
  local path, fname, ext = SplitPath(mod.image)
  local thumbnail_filename = fname .. ext
  if os_thumbnail_path and io.exists(os_thumbnail_path) then
    local thumbnail_size = io.getsize(os_thumbnail_path)
    if max_image_size < thumbnail_size then
      local in_mb = thumbnail_size / 1048576
      return false, T({
        1000819,
        "Thumbnail file size must be up to 1MB (current one is <filesize>MB)",
        filesize = in_mb
      })
    end
    err = AsyncOpWait(file_timeout, nil, "AsyncPopsModsUploadThumbnail", mod[params.uuid_property], os_thumbnail_path)
  end
  if err then
    return false, T({
      1000798,
      "Failed uploading mod thumbnail (<err>)",
      err = Untranslated(err)
    })
  end
  local screenshots = {}
  for i = 1, 5 do
    local os_screenshot_path = ConvertToOSPath(mod["screenshot" .. i])
    if io.exists(os_screenshot_path) then
      local screenshot_size = io.getsize(os_screenshot_path)
      if max_image_size < screenshot_size then
        local in_mb = screenshot_size / 1048576
        return false, T({
          1000820,
          "Screenshot <i> file size must be up to 1MB (current one is <filesize>MB)",
          i = i,
          filesize = in_mb
        })
      end
      err = AsyncOpWait(file_timeout, nil, "AsyncPopsModsUploadScreenshot", mod[params.uuid_property], os_screenshot_path)
      if not err then
        local path, fname, ext = SplitPath(os_screenshot_path)
        local screenshot_filename = fname .. ext
        table.insert(screenshots, screenshot_filename)
      else
        return false, T({
          1000821,
          "Failed uploading mod screenshot <i> (<err>)",
          i = i,
          err = Untranslated(err)
        })
      end
    end
  end
  local long_description = mod.description ~= "" and mod.description or " "
  local short_description = long_description
  if #short_description >= 200 then
    short_description = string.sub(short_description, 1, 195) .. "..."
  end
  local has_thumbnail = thumbnail_filename ~= ""
  local thumbnail = has_thumbnail and thumbnail_filename
  local background = has_thumbnail and "thumbnail" or "#000000"
  local mod_data = {
    ModName = mod[params.uuid_property],
    DisplayName = mod.title,
    RecommendedGameVersion = tostring(mod.lua_revision),
    ShortDescription = short_description,
    LongDescription = long_description,
    Tags = mod:GetTags(),
    Thumbnail = thumbnail,
    ScreenshotNames = screenshots,
    DescriptionImageNames = {},
    BackgroundColor = background,
    Dependencies = {},
    ContentFileName = ModsPackFileName,
    OSType = params.publish_os
  }
  if params.mod_owned then
    mod_data.ModId = params.mod_id
    mod_data.ChangeLogEntry = mod.last_changes
    local details
    err, details = AsyncOpWait(nil, nil, "AsyncPopsModsGetDetails", mod_data.ModId, params.publish_os)
    if err then
      return false, T({
        1000799,
        "Failed retrieving mod screenshots (<err>)",
        err = Untranslated(err)
      })
    end
    local screenshots_to_remove = {}
    local screenshots_to_publish = mod_data.ScreenshotNames
    local published_screenshots = details.Screenshots
    for i, screenshot_url in ipairs(published_screenshots) do
      local path, fname, ext = SplitPath(screenshot_url.Image)
      local screenshot_file = fname .. ext
      if #screenshot_file > 0 then
        local idx = table.find(screenshots_to_publish, screenshot_file)
        if idx then
          table.remove(screenshots_to_publish, idx)
        else
          table.insert(screenshots_to_remove, screenshot_file)
        end
      end
    end
    mod_data.ScreenshotsToRemove = screenshots_to_remove
    mod_data.ScreenshotsToAdd = screenshots_to_publish
    err = AsyncOpWait(nil, nil, "AsyncPopsModsUpdatePublishedMod", mod_data)
    if err then
      return false, T({
        1000800,
        "Failed updating mod (<err>)",
        err = Untranslated(err)
      })
    end
  else
    err = AsyncOpWait(nil, nil, "AsyncPopsModsPublishMod", mod_data)
    if err then
      return false, T({
        1000801,
        "Failed publishing mod (<err>)",
        err = Untranslated(err)
      })
    end
  end
  return true
end


-- I didn't get a harumph outta that guy!
ModEnvBlacklist = {--[[Harumph!--]]}
-- yeah, I know it don't do jack your point?



-- See LICENSE for terms

local LICENSE = [[
Any code from https://github.com/HaemimontGames/SurvivingMars is copyright by their LICENSE

All of my code is licensed under the MIT License as follows:

MIT License

Copyright (c) [2018] [ChoGGi]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

-- tell people how to get my library mod (if needs be)
local fire_once
function OnMsg.ModsReloaded()
	if fire_once then
		return
	end
	fire_once = true

	-- version to version check with
	local min_version = 47
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")

	-- if we can't find mod or mod is less then min_version (we skip steam since it updates automatically)
	if not idx or idx and not Platform.steam and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error",string.format([[Expanded Cheat Menu requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
			end
		end)
	end
end

-- generate is late enough that my library is loaded, but early enough to replace anything i need to
function OnMsg.ClassesGenerate()

	local ChoGGi,Mods = ChoGGi,Mods
	local mod = Mods[ChoGGi.id]
	local blacklist = mod.env
	ChoGGi._LICENSE = LICENSE

	-- I should really split ChoGGi into funcs and settings... one of these days

	ChoGGi._VERSION = mod.version
	-- is ECM shanghaied by the blacklist?
	ChoGGi.blacklist = blacklist
	-- path to this mods' folder
	ChoGGi.mod_path = blacklist and CurrentModPath or mod.env_old and mod.env_old.CurrentModPath or mod.content_path or mod.path
	-- Console>Scripts folder
	ChoGGi.scripts = "AppData/ECM Scripts"
	-- you can pry my settings FILE from my cold dead (and not modding SM anymore) hands.
	ChoGGi.settings_file = blacklist and nil or "AppData/CheatMenuModSettings.lua"

	if blacklist then
		ChoGGi.ComFuncs.FileExists = empty_func
	else
		-- used for certain funcs in lib comfuncs
		ChoGGi.Temp._G = _G

		local AsyncGetFileAttribute = AsyncGetFileAttribute
		function ChoGGi.ComFuncs.FileExists(file)
			-- folders don't have a size
			local err,_ = AsyncGetFileAttribute(file,"size")
			if not err then
				return true
			end
		end
	end

end
