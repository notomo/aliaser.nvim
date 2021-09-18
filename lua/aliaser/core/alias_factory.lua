local Aliases = require("aliaser.core.alias").Aliases

local M = {}

local AliasFactory = {}
AliasFactory.__index = AliasFactory
M.AliasFactory = AliasFactory

function AliasFactory.new(ns, fn)
  vim.validate({ns = {ns, "string"}, fn = {fn, "function"}})
  local tbl = {_ns = ns, _fn = fn}
  return setmetatable(tbl, AliasFactory)
end

function AliasFactory.create(self)
  local aliases = Aliases.new(self._ns)
  self._fn(aliases)
  return aliases:list()
end

local factories = {}
function AliasFactory.register(ns, fn)
  -- TODO: use ordered dict
  factories[ns] = AliasFactory.new(ns, fn)
end

function AliasFactory.list_all()
  local all = {}
  local errs = {}
  for _, factory in pairs(factories) do
    local raw_aliases, err = factory:create()
    if err then
      table.insert(errs, err)
    end
    vim.list_extend(all, raw_aliases)
  end

  local err = table.concat(errs, "\n")
  if err ~= "" then
    return all, err
  end

  return all, nil
end

return M
