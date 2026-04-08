local sources_default = { "lazydev", "lsp", "path", "snippets", "buffer" }
if require("config.util").is_in_simple_mode() then
  table.remove(sources_default, 1)
end

return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdLineEnter" },

    opts = {
      keymap = {
        -- set to 'none' to disable the 'default' preset
        preset = "none",

        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "cancel", "fallback" },
        ["<C-y>"] = { "select_and_accept", "fallback" },
        ["<S-CR>"] = { "fallback" },
        ["<C-CR>"] = { "fallback" },
        ["<CR>"] = { "accept", "fallback" },

        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },

        ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
        ["<C-n>"] = { "select_next", "fallback_to_mappings" },

        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      },

      appearance = {
        use_nvim_cmp_as_default = false,
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },

      cmdline = {
        keymap = {
          ["<Tab>"] = { "show", "accept" },
        },
        completion = { menu = { auto_show = false } },
      },

      completion = {
        menu = {
          border = "single",
          scrolloff = 1,
          scrollbar = false,
        },

        ghost_text = {
          enabled = false,
          show_with_menu = false,
        },

        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,

          window = {
            border = "single",
          },
        },
      },

      signature = {
        window = { border = "single" },
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = sources_default,
        providers = {
          buffer = {
            max_items = 5,
            score_offset = 10,
          },
          lsp = {
            score_offset = 25,
          },
          path = {
            score_offset = 100,
          },
          snippets = {
            score_offset = 10,
            min_keyword_length = 2,
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 50,
          },
        },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
