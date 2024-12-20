local M = {}

local AliasFactory = require("aliaser.core.alias_factory")

function M.register_factory(ns, fn)
  AliasFactory.register(ns, fn)
end

function M.list()
  local raw_aliases, err = AliasFactory.list_all()
  if err then
    -- no return
    vim.notify("[aliaser] " .. err, vim.log.levels.WARN)
  end
  return raw_aliases
end

function M.call(name, ...)
  local alias = AliasFactory.find(name)
  if type(alias) == "string" then
    local err = alias
    error("[aliaser] " .. err, 0)
  end
  return alias:call(...)
end

function M.to_string(alias)
  local call = ([[require("aliaser").call(%q]]):format(alias.name)
  if not alias:need_args() then
    return ([[%s)]]):format(call)
  end
  return ([[%s, %s)]]):format(call, alias:args_string())
end

function M.clear_all()
  AliasFactory.clear_all()
end

return M
