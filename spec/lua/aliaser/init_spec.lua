local helper = require("aliaser.test.helper")
local aliaser = helper.require("aliaser")
local assert = require("assertlib").typed(assert)

describe("aliaser.list()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("has file_path, start_row, module_name, name", function()
    helper.test_data:create_file(
      "lua/test/data/func.lua",
      [[
local M = {}

function M.hoge()
end

return M
]]
    )

    local alias = aliaser.list({ "test.data.func" })[1]

    assert.equal(3, alias.start_row)
    assert.equal(0, alias.params_count)
    assert.equal("test.data.func", alias.module_name)
    assert.equal("hoge", alias.name)
    assert.match("/lua/test/data/func.lua$", alias.file_path)
  end)

  it("has params_count", function()
    helper.test_data:create_file(
      "lua/test/data/param.lua",
      [[
local M = {}

function M.hoge(a, b)
end

return M
]]
    )

    local alias = aliaser.list({ "test.data.param" })[1]

    assert.equal(2, alias.params_count)
  end)

  it("has call", function()
    helper.test_data:create_file(
      "lua/test/data/increment.lua",
      [[
local M = {}

function M.hoge(n)
  return n + 1
end

return M
]]
    )

    local alias = aliaser.list({ "test.data.increment" })[1]

    assert.equal(3, alias.call(2))
  end)
end)

describe("aliaser.to_string()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("can return string to call with no arguments", function()
    helper.test_data:create_file(
      "lua/test/data/func.lua",
      [[
local M = {}

function M.hoge()
end

return M
]]
    )

    local alias = aliaser.list({ "test.data.func" })[1]
    local actual = aliaser.to_string(alias)

    assert.equal([[require("test.data.func").hoge()]], actual)

    loadstring(actual)()
  end)

  it("can return string for call() with arguments", function()
    helper.test_data:create_file(
      "lua/test/data/param.lua",
      [[
local M = {}

function M.hoge(a, b)
end

return M
]]
    )

    local alias = aliaser.list({ "test.data.param" })[1]
    local actual = aliaser.to_string(alias)

    assert.equal([[require("test.data.param").hoge(nil, nil)]], actual)

    loadstring(actual)()
  end)
end)
