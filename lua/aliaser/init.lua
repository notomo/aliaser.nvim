local M = {}

--- @class aliser_alias
--- @field name string
--- @field file_path string alias function defined file path
--- @field start_row integer alias function defined positon row
--- @field call fun(self:aliser_alias,...):any call alias function.
--- @field need_args fun(self:aliser_alias):boolean returns true if alias function needs arguments.

--- @class aliaser_alias_option
--- @field unique boolean aliaser.list() shows warnings if alias name is not unique.
--- @field nargs_max integer alias function max number of argument
--- @field default_args string[] alias function defualt arguments

--- @class aliaser_aliases
--- @field set fun(self:aliaser_aliases,name:string,rhs:string|fun(),opts:aliaser_alias_option?)

--- Register an alias factory function.
--- @param ns string: namespace for aliases
--- @param fn fun(aliases:aliaser_aliases) register aliases in this function. |aliaser_aliases|
function M.register_factory(ns, fn)
  require("aliaser.command").register_factory(ns, fn)
end

--- Gets registered aliases.
--- @return aliser_alias[]: |aliaser_alias|
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
--- @param alias aliser_alias: |aliaser_alias|
--- @return string: lua expression to call the alias
function M.to_string(alias)
  return require("aliaser.command").to_string(alias)
end

--- Clear all registered aliases.
function M.clear_all()
  require("aliaser.command").clear_all()
end

return M
