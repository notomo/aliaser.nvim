local DefinedLocation = {}
DefinedLocation.__index = DefinedLocation

--- @param rhs string|function
--- @param depth integer
function DefinedLocation.new(rhs, depth)
  local info
  local start_row
  if type(rhs) == "function" then
    info = debug.getinfo(rhs)
    start_row = info.linedefined
  else
    info = debug.getinfo(depth)
    start_row = info.currentline
  end

  local file_path
  if vim.startswith(info.source, "@") then
    file_path = info.source:sub(2)
  end

  local tbl = { start_row = start_row, file_path = file_path }
  return setmetatable(tbl, DefinedLocation)
end

return DefinedLocation
