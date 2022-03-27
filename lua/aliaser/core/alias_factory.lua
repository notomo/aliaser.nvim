local AliasFactory = {}
AliasFactory.__index = AliasFactory

function AliasFactory.new(ns, fn)
  vim.validate({ ns = { ns, "string" }, fn = { fn, "function" } })
  local tbl = { _ns = ns, _fn = fn }
  return setmetatable(tbl, AliasFactory)
end

function AliasFactory.create(self)
  local aliases = require("aliaser.core.aliases").new(self._ns)
  self._fn(aliases)
  return aliases:list()
end

local factories = require("aliaser.vendor.misclib.collection.ordered_dict").new()
function AliasFactory.register(ns, fn)
  factories[ns] = AliasFactory.new(ns, fn)
end

function AliasFactory.list_all()
  local all = {}
  local errs = {}
  for _, factory in factories:iter() do
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

function AliasFactory.find(name)
  vim.validate({ name = { name, "string" } })
  for _, alias in ipairs(AliasFactory.list_all()) do
    if alias.name == name then
      return alias, nil
    end
  end
  return nil, ("not found alias: `%s`"):format(name)
end

return AliasFactory
