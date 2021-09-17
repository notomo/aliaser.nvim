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
  return aliases:raw()
end

local factories = {}
function AliasFactory.register(ns, fn)
  -- TODO: use ordered dict
  factories[ns] = AliasFactory.new(ns, fn)
end

function AliasFactory.list()
  local raw_aliases = {}
  for _, factory in pairs(factories) do
    vim.list_extend(raw_aliases, factory:create())
  end
  return raw_aliases
end

return M
