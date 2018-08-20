### Return a random number

AsyncRand() has slightly more variation then Random(), and possibly more than UICity:Random() (never bothered to test).
It's also faster (though the ifs I added may make this function slower).

Random() -- returns number between 0 and max_int
Random(10) -- returns number between 0 - 10
Random(-50,10) -- returns number between -50 - 10

```
do
  local AsyncRand = AsyncRand
  function Random(m, n)

    -- m = min, n = max
    if n then

      -- return nil instead of just returning max without any randomness
      if n-m < 0 then
        return
      end

      return AsyncRand(n - m + 1) + m

    else
      -- m = max, min = 0 OR number between 0 and max_int
      return m and AsyncRand(m) or AsyncRand()
    end

  end
end
```

#### If you're sure you won't send n-m < 0 then you can skip that
```
do
  local AsyncRand = AsyncRand
  function Random(m, n)
    if n then
      -- m = min, n = max
      return AsyncRand(n - m + 1) + m
    else
      -- m = max, min = 0 OR number between 0 and max_int
      return m and AsyncRand(m) or AsyncRand()
    end
  end
end
```
