local Command = require("aliaser.command").Command

local M = {}

--- Register an alias factory function.
--- @param ns string: namespace for aliases
--- @param fn function: register aliases in this function
function M.register_factory(ns, fn)
  Command.new("register_factory", ns, fn)
end

--- Gets registered aliases.
--- @return table: {name = (string), file_path = (string), start_row = (number)}[]
function M.list()
  return Command.new("list")
end

--- Call an alias by name.
--- @param name string: alias name
--- @vararg any: alias function arguments
--- @return any: alias function result
function M.call(name, ...)
  return Command.new("call", name, ...)
end

--- Converts an alias to string.
--- @param alias table: alias object
--- @return string: lua expression to call the alias
function M.to_string(alias)
  return Command.new("to_string", alias)
end

return M
