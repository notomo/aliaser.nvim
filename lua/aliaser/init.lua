local M = {}

--- @class AliserAlias
--- @field name string
--- @field file_path string alias function defined file path
--- @field start_row integer alias function defined positon row
--- @field call fun(self:AliserAlias,...):any call alias function.
--- @field need_args fun(self:AliserAlias):boolean returns true if alias function needs arguments.

--- @class AliaserAliasOption
--- @field unique boolean aliaser.list() shows warnings if alias name is not unique.
--- @field nargs_max integer alias function max number of argument
--- @field default_args string[] alias function defualt arguments

--- @class AliaserAliases
--- @field set fun(self:AliaserAliases,name:string,rhs:string|fun(),opts:AliaserAliasOption?) |AliaserAliasOption|

--- Register an alias factory function.
--- @param ns string: namespace for aliases
--- @param fn fun(aliases:AliaserAliases) register aliases in this function. |AliaserAliases|
function M.register_factory(ns, fn)
  require("aliaser.command").register_factory(ns, fn)
end

--- Gets registered aliases.
--- @return AliserAlias[]: |AliserAlias|
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
--- @param alias AliserAlias: |AliserAlias|
--- @return string: lua expression to call the alias
function M.to_string(alias)
  return require("aliaser.command").to_string(alias)
end

--- Clear all registered aliases.
function M.clear_all()
  require("aliaser.command").clear_all()
end

return M
