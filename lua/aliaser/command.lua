local ReturnValue = require("aliaser.vendor.error_handler").for_return_value()
local ReturnPackedValue = require("aliaser.vendor.error_handler").for_return_packed_value()
local ShowError = require("aliaser.vendor.error_handler").for_show_error()

local AliasFactory = require("aliaser.core.alias_factory")

function ShowError.register_factory(ns, fn)
  vim.validate({ ns = { ns, "string" }, fn = { fn, "function" } })
  return AliasFactory.register(ns, fn)
end

function ReturnValue.list()
  local raw_aliases, err = AliasFactory.list_all()
  if err then
    -- no return
    require("aliaser.vendor.message").warn(err)
  end
  return raw_aliases
end

function ReturnPackedValue.call(name, ...)
  local alias, err = AliasFactory.find(name)
  if err then
    return nil, err
  end
  return vim.F.pack_len(alias:call(...))
end

function ReturnValue.to_string(alias)
  local call = ([[require("aliaser").call(%q]]):format(alias.name)
  if not alias:need_args() then
    return ([[%s)]]):format(call)
  end
  return ([[%s, %s)]]):format(call, alias:args_string())
end

return vim.tbl_extend("force", ReturnValue:methods(), ReturnPackedValue:methods(), ShowError:methods())
