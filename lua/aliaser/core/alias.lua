local M = {}

local Alias = {}
Alias.__index = Alias
M.Alias = Alias

local Aliases = {}
Aliases.__index = Aliases
M.Aliases = Aliases

function Aliases.new(ns)
  vim.validate({ns = {ns, "string"}})
  local tbl = {_ns = ns, _aliases = {}}
  return setmetatable(tbl, Aliases)
end

function Aliases.set(self, name, rhs)
  local key = ("%s/%s"):format(self._ns, name)
  -- TODO: rhs type switch
  -- TODO: use ordered dict
  self._aliases[key] = Alias.new(key, rhs)
end

function Aliases.raw(self)
  local raw_aliases = {}
  for _, alias in pairs(self._aliases) do
    table.insert(raw_aliases, alias)
  end
  return raw_aliases
end

function Alias.new(name, rhs)
  -- TODO: validate rhs
  vim.validate({name = {name, "string"}})

  local fn
  local typ = type(rhs)
  if typ == "function" then
    fn = rhs
  elseif typ == "string" then
    fn = function()
      vim.cmd(rhs)
    end
  else
    -- TODO: return err
    error("unexpected rhs type: " .. typ)
  end

  local tbl = {name = name, _fn = fn}
  return setmetatable(tbl, Alias)
end

function Alias.call(self)
  -- TODO: handle error?
  return self._fn()
end

return M
