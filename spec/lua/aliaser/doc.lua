local util = require("genvdoc.util")
local plugin_name = vim.env.PLUGIN_NAME
local full_plugin_name = plugin_name .. ".nvim"

local example_target
local example_target_path = "./lua/aliaser/test/example.lua"
do
  local f = io.open(example_target_path, "r")
  assert(f)
  example_target = f:read("a")
end

local example_path = ("./spec/lua/%s/example.lua"):format(plugin_name)

require("genvdoc").generate(full_plugin_name, {
  source = { patterns = { ("lua/%s/init.lua"):format(plugin_name) } },
  chapters = {
    {
      name = function(group)
        return "Lua module: " .. group
      end,
      group = function(node)
        if node.declaration == nil or node.declaration.type ~= "function" then
          return nil
        end
        return node.declaration.module
      end,
    },
    {
      name = "STRUCTURE",
      group = function(node)
        if node.declaration == nil or node.declaration.type ~= "class" then
          return nil
        end
        return "STRUCTURE"
      end,
    },
    {
      name = "EXAMPLES",
      body = function()
        local target = util.help_code_block_from_file(example_target_path, { language = "lua" })
        local usage = util.help_code_block_from_file(example_path, { language = "lua" })
        return ([[
%s:
%s

usage:
%s]]):format(example_target_path, target, usage)
      end,
    },
  },
})

local gen_readme = function()
  local exmaple = util.read_all(example_path)

  local content = ([[
# %s

A plugin to put command/function without mapping.
Mainly use as a finder plugin's source.

## Example

### %s

```lua
%s```

### usage

```lua
%s```]]):format(full_plugin_name, example_target_path, example_target, exmaple)

  util.write("README.md", content)
end
gen_readme()
