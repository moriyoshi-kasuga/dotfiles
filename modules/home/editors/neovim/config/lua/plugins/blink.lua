return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdLineEnter" },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
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

        ["gk"] = { "show_signature", "hide_signature", "fallback" },
      },

      appearance = {
        use_nvim_cmp_as_default = false,
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },

      completion = {
        keyword = { range = "full" },

        menu = {
          border = "rounded",
          scrolloff = 1,
          scrollbar = false,
        },

        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },

        ghost_text = {
          enabled = false,
          show_with_menu = false,
        },

        accept = { auto_brackets = { enabled = true } },

        documentation = {
          auto_show = true,
          auto_show_delay_ms = 100,
          update_delay_ms = 50,

          window = {
            border = "rounded",
          },
        },
      },

      signature = { window = { border = "rounded" } },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { "lsp", "lazydev", "path", "snippets", "buffer" },
        providers = {
          snippets = {
            min_keyword_length = 2,
          },
          buffer = {
            max_items = 5,
          },
          lsp = {
            async = true,
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            fallbacks = { "lsp" },
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
