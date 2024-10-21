local Aliases = {}
Aliases.__index = Aliases

--- @param ns string
function Aliases.new(ns)
  local tbl = {
    _ns = ns,
    _aliases = require("aliaser.vendor.misclib.collection.ordered_dict").new(),
    _warnings = {},
  }
  return setmetatable(tbl, Aliases)
end

function Aliases.set(self, name, rhs, raw_opts)
  local opts = require("aliaser.core.option").new(raw_opts)

  local key = ("%s/%s"):format(self._ns, name)
  if opts.unique and self._aliases:has(key) then
    table.insert(self._warnings, ("already exists: `%s`"):format(key))
    return
  end

  local alias = require("aliaser.core.alias").new(key, rhs, opts)
  self._aliases[key] = alias
end

function Aliases.list(self)
  local all = {}
  for _, alias in self._aliases:iter() do
    table.insert(all, alias)
  end

  if #self._warnings > 0 then
    local err = table.concat(self._warnings, "\n")
    return all, err
  end

  return all, nil
end

return Aliases
