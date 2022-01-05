local M = {}

local Option = {}
Option.__index = Option
M.Option = Option

function Option.new(opts)
  vim.validate({ opts = { opts, "table", true } })
  opts = opts or {}
  local tbl = {
    unique = opts.unique or false,
    _nargs_max = opts.nargs_max or 0,
    _default_args = opts.default_args or {},
  }
  return setmetatable(tbl, Option)
end

function Option.need_args(self)
  return self._nargs_max > 0
end

function Option.args_string(self)
  local args = vim.fn["repeat"]({ "nil" }, self._nargs_max)
  for i, v in ipairs(self._default_args) do
    args[i] = vim.inspect(v, { newline = " ", indent = "" })
  end
  return table.concat(args, ", ")
end

return M
