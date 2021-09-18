local M = {}

function M.type(value, ...)
  local types = {...}
  return {
    value,
    function(x)
      return vim.tbl_contains(types, type(x))
    end,
    ("in [%s]"):format(table.concat(types, ", ")),
  }
end

return M
