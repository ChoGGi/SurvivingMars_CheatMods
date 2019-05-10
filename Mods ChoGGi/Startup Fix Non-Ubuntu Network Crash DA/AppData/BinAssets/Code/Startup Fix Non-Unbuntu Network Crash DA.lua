CreateRealTimeThread(function()
  -- wait till mods are loaded
  WaitMsg("ModDefsLoaded")

-- seems to be something to do with the ParadoxFeedLoaded

  function StartPops()
    -- the thread removes the delay of waiting for login so we can just load the damned game
    CreateRealTimeThread(function()
      -- don't wait to bork uploading mods
      if Platform.steam then
        local appId, ticket
        if IsSteamAvailable() then
          appId = tostring(SteamGetAppId())
          ticket = SteamGetAuthSessionTicket()
          if ticket then
            ticket = Encode16(ticket):upper()
            AsyncOpWait(PopsAsyncOpTimeout, nil, "AsyncPopsAccountLoginSteamTicket", appId, ticket)
          end
        end
      end

      g_PopsAttemptingLogin = false
      WaitGetParadoxAccountData()
      local err, token = PopsTokenRetrieveCurrent()
      if not err and token then
        LocalStorage.ParadoxAuthToken = token
        SaveLocalStorage()
      end
      Msg("PopsLogin", "auto")
    end)
  end

end)
