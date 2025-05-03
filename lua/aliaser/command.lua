local M = {}

function M.list(module_names)
  local all_aliases = {}
  for _, module_name in ipairs(module_names) do
    local aliases = M._collect(module_name)
    vim.list_extend(all_aliases, aliases)
  end
  return all_aliases
end

function M.to_string(alias)
  local call = ([[require(%q).%s(]]):format(alias.module_name, alias.name)
  if alias.params_count == 0 then
    return ([[%s)]]):format(call)
  end
  return ([[%s%s)]]):format(call, table.concat(vim.fn["repeat"]({ "nil" }, alias.params_count), ", "))
end

function M._collect(module_name)
  local aliases = {}
  for name, f in pairs(require(module_name) or {}) do
    if type(f) == "function" then
      local defined = M._defined(f)
      table.insert(aliases, {
        module_name = module_name,
        name = name,
        start_row = defined.start_row,
        file_path = defined.file_path,
        params_count = defined.params_count,
        call = f,
      })
    end
  end
  return aliases
end

function M._defined(f)
  local info = debug.getinfo(f)

  local file_path
  if vim.startswith(info.source, "@") then
    file_path = info.source:sub(2)
  end

  return {
    start_row = info.linedefined,
    file_path = file_path,
    params_count = info.nparams,
  }
end

return M
