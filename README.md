# aliaser.nvim

A plugin to put command/function without mapping.
Mainly use as a finder plugin's source.

## Example

```lua
local aliaser = require("aliaser")

aliaser.register_factory("example", function(aliases)
  aliases:set("clear_messages", "messages clear")
  aliases:set("rename", function()
    vim.fn.feedkeys(":file ", "n")
  end)
end)

local alias = aliaser.list()[1]
alias:call() -- messages clear
```