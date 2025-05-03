local M = {}

function M.clear_messages()
  vim.cmd.message("clear")
end

return M
