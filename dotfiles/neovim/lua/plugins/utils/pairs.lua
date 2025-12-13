return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {},
  config = function(_, plugin_opts)
    local npairs = require("nvim-autopairs")
    npairs.setup(plugin_opts)

    local bracket = require("nvim-autopairs.rules.basic").bracket_creator(npairs.config)
    npairs.add_rule(bracket("<", ">", { "rust", "cpp", "c" }))
  end,
}
