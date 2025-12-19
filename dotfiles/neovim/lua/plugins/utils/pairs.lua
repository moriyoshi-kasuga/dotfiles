return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {},
  config = function(_, plugin_opts)
    local npairs = require("nvim-autopairs")
    npairs.setup(plugin_opts)

    local Rule = require("nvim-autopairs.rule")
    local cond = require("nvim-autopairs.conds")

    npairs.add_rule(Rule("<", ">", {
      "rust",
      "cpp",
      "c",
    }):with_pair(
      -- regex will make it so that it will auto-pair on
      -- `a<` but not `a <`
      -- The `:?:?` part makes it also
      -- work on Rust generics like `some_func::<T>()`
      cond.before_regex("%a+:?:?$", 3)
    ):with_move(function(opts)
      return opts.char == ">"
    end))
  end,
}
