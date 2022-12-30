local M = {}

--- Register an alias factory function.
--- @param ns string: namespace for aliases
--- @param fn function: register aliases in this function
function M.register_factory(ns, fn)
  require("aliaser.command").register_factory(ns, fn)
end

--- Gets registered aliases.
--- @return table: {name = (string), file_path = (string), start_row = (number)}[]
function M.list()
  return require("aliaser.command").list()
end

--- Call an alias by name.
--- @param name string: alias name
--- @vararg any: alias function arguments
--- @return any: alias function result
function M.call(name, ...)
  return require("aliaser.command").call(name, ...)
end

--- Converts an alias to string.
--- @param alias table: alias object
--- @return string: lua expression to call the alias
function M.to_string(alias)
  return require("aliaser.command").to_string(alias)
end

--- Clear all registered aliases.
function M.clear_all()
  require("aliaser.command").clear_all()
end

return M
