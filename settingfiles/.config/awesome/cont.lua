local eff = require('eff')
local perform, handler, inst = eff.perform, eff.handler, eff.inst

local Cont = inst()
local cont = function(f)
  return perform(Cont(f))
end

local run = function(body, kglobal)
  return handler {
    val = kglobal,
    [Cont] = function(k, f)
      return f(k)
    end
  }(body)
end

local do_ = function(body)
  return run(body, function(x) return x end)
end

return {
  cont = cont,
  run = run,
  do_ = do_
}
