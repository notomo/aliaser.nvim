local Alias = {}
Alias.__index = Alias

--- @param name string
--- @param rhs string|function
--- @param opts table
function Alias.new(name, rhs, opts)
  local fn
  local typ = type(rhs)
  if typ == "function" then
    fn = rhs
  elseif typ == "string" then
    fn = function()
      vim.cmd(rhs)
    end
  end

  local defined_location = require("aliaser.core.defined_location").new(rhs, 4)
  local tbl = {
    name = name,
    start_row = defined_location.start_row,
    file_path = defined_location.file_path,
    _fn = fn,
    _opts = opts,
  }
  return setmetatable(tbl, Alias)
end

function Alias.call(self, ...)
  return self._fn(...)
end

function Alias.need_args(self)
  return self._opts:need_args()
end

function Alias.args_string(self)
  return self._opts:args_string()
end

return Alias
