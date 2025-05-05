local helper = require("aliaser.test.helper")
local aliaser = helper.require("aliaser")
local assert = require("assertlib").typed(assert)

describe("aliaser.list()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("has file_path, start_row, module_name, name", function()
    local alias = aliaser.list({ "aliaser.test.data.function_in_3" })[1]

    assert.equal(3, alias.start_row)
    assert.equal(0, alias.params_count)
    assert.equal("aliaser.test.data.function_in_3", alias.module_name)
    assert.equal("hoge", alias.name)
    assert.equal(helper.root .. "/lua/aliaser/test/data/function_in_3.lua", alias.file_path)
  end)

  it("has params_count", function()
    local alias = aliaser.list({ "aliaser.test.data.function_with_arg_in_3" })[1]

    assert.equal(2, alias.params_count)
  end)

  it("has call", function()
    local alias = aliaser.list({ "aliaser.test.data.function_increment_in_3" })[1]

    assert.equal(3, alias.call(2))
  end)
end)

describe("aliaser.to_string()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("can return string to call with no arguments", function()
    local alias = aliaser.list({ "aliaser.test.data.function_in_3" })[1]
    local actual = aliaser.to_string(alias)

    assert.equal([[require("aliaser.test.data.function_in_3").hoge()]], actual)

    loadstring(actual)()
  end)

  it("can return string for call() with arguments", function()
    local alias = aliaser.list({ "aliaser.test.data.function_with_arg_in_3" })[1]
    local actual = aliaser.to_string(alias)

    assert.equal([[require("aliaser.test.data.function_with_arg_in_3").hoge(nil, nil)]], actual)

    loadstring(actual)()
  end)
end)
