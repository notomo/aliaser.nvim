local Option = {}
Option.__index = Option

Option.default = {
  unique = false,
  nargs_max = 0,
  default_args = {},
}

function Option.new(raw_opts)
  vim.validate({ raw_opts = { raw_opts, "table", true } })
  raw_opts = raw_opts or {}
  local tbl = vim.tbl_deep_extend("force", Option.default, raw_opts)
  return setmetatable(tbl, Option)
end

function Option.need_args(self)
  return self.nargs_max > 0
end

function Option.args_string(self)
  local args = vim.fn["repeat"]({ "nil" }, self.nargs_max)
  for i, v in ipairs(self.default_args) do
    args[i] = vim.inspect(v, { newline = " ", indent = "" })
  end
  return table.concat(args, ", ")
end

return Option
