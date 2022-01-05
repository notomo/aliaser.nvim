local example_path = "./spec/lua/aliaser/example.lua"

require("genvdoc").generate("aliaser.nvim", {
  chapters = {
    {
      name = function(group)
        return "Lua module: " .. group
      end,
      group = function(node)
        if not node.declaration then
          return nil
        end
        return node.declaration.module
      end,
    },
    {
      name = "EXAMPLES",
      body = function()
        return require("genvdoc.util").help_code_block_from_file(example_path)
      end,
    },
  },
})

local gen_readme = function()
  local f = io.open(example_path, "r")
  local exmaple = f:read("*a")
  f:close()

  local content = ([[
# aliaser.nvim

A plugin to put command/function without mapping.
Mainly use as a finder plugin's source.

## Example

```lua
%s```]]):format(exmaple)

  local readme = io.open("README.md", "w")
  readme:write(content)
  readme:close()
end
gen_readme()