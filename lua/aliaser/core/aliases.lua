local Aliases = {}
Aliases.__index = Aliases

function Aliases.new(ns)
  vim.validate({ ns = { ns, "string" } })
  local tbl = { _ns = ns, _aliases = require("aliaser.vendor.collection.ordered_dict").new(), _warnings = {} }
  return setmetatable(tbl, Aliases)
end

function Aliases.set(self, name, rhs, raw_opts)
  vim.validate({ name = { name, "string" }, opts = { raw_opts, "table", true } })
  local opts = require("aliaser.core.option").new(raw_opts)

  local key = ("%s/%s"):format(self._ns, name)
  if opts.unique and self._aliases:has(key) then
    table.insert(self._warnings, ("already exists: `%s`"):format(key))
    return
  end

  local alias, err = require("aliaser.core.alias").new(key, rhs, opts)
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

return Aliases
