local Option = require("aliaser.core.option").Option
local OrderedDict = require("aliaser.lib.ordered_dict").OrderedDict
local validatelib = require("aliaser.lib.validate")

local M = {}

local Alias = {}
Alias.__index = Alias
M.Alias = Alias

local Aliases = {}
Aliases.__index = Aliases
M.Aliases = Aliases

function Aliases.new(ns)
  vim.validate({ns = {ns, "string"}})
  local tbl = {_ns = ns, _aliases = OrderedDict.new(), _warnings = {}}
  return setmetatable(tbl, Aliases)
end

function Aliases.set(self, name, rhs, raw_opts)
  vim.validate({name = {name, "string"}, opts = {raw_opts, "table", true}})
  local opts = Option.new(raw_opts)

  local key = ("%s/%s"):format(self._ns, name)
  if opts.unique and self._aliases:has(key) then
    table.insert(self._warnings, ("`%s` is already exists"):format(key))
    return
  end

  local alias, err = Alias.new(key, rhs)
  if err then
    table.insert(self._warnings, err)
    return
  end

  self._aliases[key] = alias
end

function Aliases.list(self)
  local all = {}
  for _, alias in self._aliases:iter() do
    table.insert(all, alias)
  end

  local err = table.concat(self._warnings, "\n")
  if err ~= "" then
    return all, err
  end

  return all, nil
end

function Alias.new(name, rhs)
  vim.validate({rhs = validatelib.type(rhs, "function", "string")})

  local fn
  local typ = type(rhs)
  if typ == "function" then
    fn = rhs
  elseif typ == "string" then
    fn = function()
      vim.cmd(rhs)
    end
  end

  local tbl = {name = name, _fn = fn}
  return setmetatable(tbl, Alias), nil
end

function Alias.call(self)
  -- TODO: handle error?
  return self._fn()
end

return M
