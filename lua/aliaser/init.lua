local M = {}

--- @class Alias
--- @field name string
--- @field file_path string alias function defined file path
--- @field start_row integer alias function defined positon row
--- @field call fun(self:Alias,...):any call alias function.
--- @field need_args fun(self:Alias):boolean returns true if alias function needs arguments.

--- @class AliasOption
--- @field unique boolean if true, aliaser.list() shows warnings
--- @field nargs_max integer alias function max number of argument
--- @field default_args string[]

--- @class Aliases
--- @field set fun(self:Aliases,name:string,rhs:string|fun(),opts:AliasOption?)

--- Register an alias factory function.
--- @param ns string: namespace for aliases
--- @param fn fun(aliases:Aliases) register aliases in this function. ref: |aliaser.Aliases|
function M.register_factory(ns, fn)
  require("aliaser.command").register_factory(ns, fn)
end

--- Gets registered aliases.
--- @return Alias[]: ref: |aliaser.Alias|
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
--- @param alias Alias: |aliaser.Alias|
--- @return string: lua expression to call the alias
function M.to_string(alias)
  return require("aliaser.command").to_string(alias)
end

--- Clear all registered aliases.
function M.clear_all()
  require("aliaser.command").clear_all()
end

return M
