--DebugPrint

Platform.developer = true

local __run = function(...)
  if count_params(...) == 0 then
    return
  end
  if count_params(...) == 1 then
    local f = (...)
    if type(f) == "function" then
      return f()
    end
  end
  return ...
end
local load_match = function(line, rules, env)
  for i = 1, #rules do
    local capture1, capture2, capture3 = string.match(line, rules[i][1])
    if capture1 then
      local func, err = load(string.format(rules[i][2], capture1, capture2, capture3), nil, nil, env)
      if not err then
        return nil, func
      end
    end
  end
  return "not understood"
end
local console_fenv = setmetatable({__run = __run}, {
  __index = function(_, key)
    return rawget(_G, key)
  end,
  __newindex = function(_, key, value)
    rawset(_G, key, value)
  end
})
function ConsoleExec(input, rules)
  local err, func = load_match(input, rules, console_fenv)
  if err then
    return err
  end
  return nil, func()
end

UserActions.InitConsole()
Platform.developer = false
