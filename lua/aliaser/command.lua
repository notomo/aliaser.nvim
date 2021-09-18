local AliasFactory = require("aliaser.core.alias_factory").AliasFactory
local messagelib = require("aliaser.lib.message")

local M = {}

local Command = {}
Command.__index = Command
M.Command = Command

function Command.new(name, ...)
  local args = vim.F.pack_len(...)
  local f = function()
    return Command[name](vim.F.unpack_len(args))
  end

  local packed = vim.F.pack_len(xpcall(f, debug.traceback))
  local ok = packed[1]
  if not ok then
    local err = packed[2]
    return messagelib.error(err)
  end
  return unpack(packed, 2, packed.n)
end

function Command.register_factory(ns, fn)
  vim.validate({ns = {ns, "string"}, fn = {fn, "function"}})
  AliasFactory.register(ns, fn)
end

function Command.list()
  local raw_aliases, err = AliasFactory.list_all()
  if err then
    messagelib.warn(err)
  end
  return raw_aliases
end

return M
