local Command = require("aliaser.command").Command

local M = {}

function M.register_factory(ns, fn)
  Command.new("register_factory", ns, fn)
end

function M.list()
  return Command.new("list")
end

return M
