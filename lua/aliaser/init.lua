local Command = require("aliaser.command").Command

local M = {}

function M.register_factory(ns, fn)
  Command.new("register_factory", ns, fn)
end

function M.list()
  return Command.new("list")
end

function M.call(name, ...)
  return Command.new("call", name, ...)
end

function M.to_string(alias)
  return Command.new("to_string", alias)
end

return M
