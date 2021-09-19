--
require("aliaser").register_factory("test_string", function(aliases)
  aliases:set("a", function()
  end)
end)
