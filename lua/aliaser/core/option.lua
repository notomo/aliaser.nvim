local M = {}

local Option = {}
Option.__index = Option
M.Option = Option

function Option.new(opts)
  vim.validate({opts = {opts, "table", true}})
  opts = opts or {}
  local tbl = {unique = opts.unique or false}
  return setmetatable(tbl, Option)
end

return M
