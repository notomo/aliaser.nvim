local helper = require("aliaser.test.helper")
local aliaser = helper.require("aliaser")

describe("aliaser.register_factory()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("registers an alias factory", function()
    local called = false
    aliaser.register_factory("test", function(aliases)
      aliases:set("call", function()
        called = true
      end)
    end)

    local alias = aliaser.list()[1]
    alias:call()

    assert.is_true(called)
  end)

  it("overwrites the same key", function()
    local called = false
    aliaser.register_factory("test", function(aliases)
      aliases:set("call", function()
        called = true
      end)
    end)

    aliaser.register_factory("test", function(aliases)
      aliases:set("call", "normal! gg")
    end)

    local alias = aliaser.list()[1]
    alias:call()

    assert.is_false(called)
  end)

  it("registers alias factories", function()
    aliaser.register_factory("test1", function(aliases)
      aliases:set("1", "")
    end)
    aliaser.register_factory("test2", function(aliases)
      aliases:set("2", "")
    end)

    assert.length(aliaser.list(), 2)
  end)
end)

describe("aliaser.list()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("shows already exists error", function()
    aliaser.register_factory("test", function(aliases)
      aliases:set("a", "")
      aliases:set("a", "", { unique = true })
    end)

    local aliases = aliaser.list()

    assert.exists_message([[already exists: `test/a`]])
    assert.length(aliases, 1)
  end)

  it("has file_path and start_row with string alias", function()
    require("aliaser.test.data.string_in_2")

    local alias = aliaser.list()[1]

    assert.equal(2, alias.start_row)
    assert.equal(helper.root .. "/lua/aliaser/test/data/string_in_2.lua", alias.file_path)
  end)

  it("has file_path and start_row with function alias", function()
    require("aliaser.test.data.function_in_3")

    local alias = aliaser.list()[1]

    assert.equal(3, alias.start_row)
    assert.equal(helper.root .. "/lua/aliaser/test/data/function_in_3.lua", alias.file_path)
  end)
end)

describe("aliaser.call()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("calls an alias by name", function()
    aliaser.register_factory("test", function(aliases)
      aliases:set("call", function(arg)
        return 1, arg
      end)
    end)

    local res1, res2 = aliaser.call("test/call", 2)

    assert.is_same(1, res1)
    assert.is_same(2, res2)
  end)

  it("shows not found error", function()
    aliaser.call("test/not_found")
    assert.exists_message([[not found alias: `test/not_found`]])
  end)
end)

describe("aliaser.to_string()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("can return string for call() with no arguments", function()
    local called = false
    aliaser.register_factory("test", function(aliases)
      aliases:set("call", function()
        called = true
      end)
    end)

    local alias = aliaser.list()[1]
    local actual = aliaser.to_string(alias)

    assert.equal([[require("aliaser").call("test/call")]], actual)

    vim.fn.luaeval(actual)
    assert.is_true(called)
  end)

  it("can return string for call() with arguments", function()
    local called = false
    aliaser.register_factory("test", function(aliases)
      aliases:set("call", function()
        called = true
      end, { nargs_max = 2 })
    end)

    local alias = aliaser.list()[1]
    local actual = aliaser.to_string(alias)

    assert.equal([[require("aliaser").call("test/call", nil, nil)]], actual)

    vim.fn.luaeval(actual)
    assert.is_true(called)
  end)

  it("can return string for call() with default arguments", function()
    local arg1
    aliaser.register_factory("test", function(aliases)
      aliases:set("call", function(arg)
        arg1 = arg
      end, { nargs_max = 2, default_args = { "arg1" } })
    end)

    local alias = aliaser.list()[1]
    local actual = aliaser.to_string(alias)

    assert.equal([[require("aliaser").call("test/call", "arg1", nil)]], actual)

    vim.fn.luaeval(actual)
    assert.equal("arg1", arg1)
  end)
end)

describe("aliaser.clear_all()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("clears all aliases", function()
    aliaser.register_factory("test1", function(aliases)
      aliases:set("a", "")
      aliases:set("b", "")
    end)
    aliaser.register_factory("test2", function(aliases)
      aliases:set("c", "")
    end)

    aliaser.clear_all()

    local aliases = aliaser.list()
    assert.length(aliases, 0)
  end)
end)
