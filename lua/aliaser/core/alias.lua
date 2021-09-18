local M = {}

local Alias = {}
Alias.__index = Alias
M.Alias = Alias

local Aliases = {}
Aliases.__index = Aliases
M.Aliases = Aliases

function Aliases.new(ns)
  vim.validate({ns = {ns, "string"}})
  local tbl = {_ns = ns, _aliases = {}, _warnings = {}}
  return setmetatable(tbl, Aliases)
end

function Aliases.set(self, name, rhs)
  local key = ("%s/%s"):format(self._ns, name)

  local alias, err = Alias.new(key, rhs)
  if err then
    table.insert(self._warnings, err)
    return
  end

  -- TODO: use ordered dict
  self._aliases[key] = alias
end

function Aliases.list(self)
  local all = {}
  for _, alias in pairs(self._aliases) do
    table.insert(all, alias)
  end

  local err = table.concat(self._warnings, "\n")
  if err ~= "" then
    return all, err
  end

  return all, nil
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
    return nil, ("%s: unexpected type: %s"):format(name, typ)
  end

  local tbl = {name = name, _fn = fn}
  return setmetatable(tbl, Alias), nil
end

function Alias.call(self)
  -- TODO: handle error?
  return self._fn()
end

return M
