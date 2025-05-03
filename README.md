# aliaser.nvim

A plugin to put command/function without mapping.
Mainly use as a finder plugin's source.

## Example

### ./lua/aliaser/test/example.lua

```lua
local M = {}

function M.clear_messages()
  vim.cmd.message("clear")
end

return M
```

### usage

```lua
local aliaser = require("aliaser")

local alias = aliaser.list({ "aliaser.test.example" })[1]
alias.call()
```