local Option = require("aliaser.core.option").Option
local DefinedLocation = require("aliaser.core.defined_location").DefinedLocation
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
    table.insert(self._warnings, ("already exists: `%s`"):format(key))
    return
  end

  local alias, err = Alias.new(key, rhs, opts)
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

-- TODO: alias doc

function Alias.new(name, rhs, opts)
  vim.validate({rhs = validatelib.type(rhs, "function", "string"), opts = {opts, "table"}})

  local fn
  local typ = type(rhs)
  if typ == "function" then
    fn = rhs
  elseif typ == "string" then
    fn = function()
      vim.cmd(rhs)
    end
  end

  local defined_location = DefinedLocation.new(rhs, 4)
  local tbl = {
    name = name,
    start_row = defined_location.start_row,
    file_path = defined_location.file_path,
    _fn = fn,
    _opts = opts,
  }
  return setmetatable(tbl, Alias), nil
end

function Alias.call(self, ...)
  return self._fn(...)
end

function Alias.need_args(self)
  return self._opts:need_args()
end

function Alias.args_string(self)
  return self._opts:args_string()
end

return M
