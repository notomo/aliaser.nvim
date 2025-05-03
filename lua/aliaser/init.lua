local M = {}

--- @class AliaserAlias
--- @field name string
--- @field module_name string
--- @field file_path string alias function defined file path
--- @field start_row integer alias function defined positon row
--- @field params_count integer alias function parameter count
--- @field call fun(...):any call alias function.

--- Gets aliases.
--- @param module_names string[]: names to require module
--- @return AliaserAlias[] # |AliaserAlias|
function M.list(module_names)
  return require("aliaser.command").list(module_names)
end

--- Converts an alias to string.
--- @param alias AliaserAlias: |AliaserAlias|
--- @return string # lua expression to call the alias
function M.to_string(alias)
  return require("aliaser.command").to_string(alias)
end

return M
