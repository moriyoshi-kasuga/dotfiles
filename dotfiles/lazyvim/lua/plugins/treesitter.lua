return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      indent = {
        enable = false,
      },
      auto_install = true,
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      },

      playground = {
        enable = true,
        disable = {},
        updatetime = 25,
        persist_queries = true,
        keybindings = {
          toggle_query_editor = "o",
          toggle_hl_groups = "i",
          toggle_injected_languages = "t",
          toggle_anonymous_nodes = "a",
          toggle_language_display = "I",
          focus_language = "f",
          unfocus_language = "F",
          update = "R",
          goto_node = "<cr>",
          show_help = "?",
        },
      },
    },
  },
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "LazyFile", "VeryLazy" },
    opts = {
      use_default_keymaps = false,
      max_join_length = 1200,
    },
    config = function(_, opts)
      require("treesj").setup(opts)
      vim.keymap.set("n", "<leader>j", require("treesj").toggle, { desc = "Toggle split" })
      vim.keymap.set("n", "<leader>J", function()
        require("treesj").toggle({ split = { recursive = true } })
      end, { desc = "Toggle split (recursive)" })
    end,
  },
}
