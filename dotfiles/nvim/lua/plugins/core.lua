return {
  {
    --undotree
    "mbbill/undotree",
    event = "BufEnter",
    keys = {
      { "<leader>i", "<cmd>UndotreeToggle<cr>", desc = "Undotree" },
    },
  },
  {
    "uga-rosa/translate.nvim",
    lazy = false,
    opts = {
      preset = {
        output = {
          split = {
            append = true,
          },
        },
      },
    },
    keys = {
      { "<leader>te", mode = { "n", "v" }, "<cmd>Translate en<cr>", desc = "Translate English" },
      { "<leader>tj", mode = { "n", "v" }, "<cmd>Translate ja<cr>", desc = "Translate Japanese" },
      {
        "<leader>tE",
        mode = { "n", "v" },
        "<cmd>Translate en -output=replace<cr>",
        desc = "translate to en of replace",
      },
      {
        "<leader>tJ",
        mode = { "n", "v" },
        "<cmd>Translate ja -output=replace<cr>",
        desc = "translate to ja of replace",
      },
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },
  {
    "unblevable/quick-scope",
    lazy = false,
  },

  -- add symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        user_default_options = {
          RGB = true, -- #RGB hex codes
          RRGGBB = true, -- #RRGGBB hex codes
          names = true, -- "Name" codes like Blue or blue
          RRGGBBAA = true, -- #RRGGBBAA hex codes
          AARRGGBB = true, -- 0xAARRGGBB hex codes
          rgb_fn = true, -- CSS rgb() and rgba() functions
          hsl_fn = true, -- CSS hsl() and hsla() functions
          css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
          -- Available modes for `mode`: foreground, background,  virtualtext
          mode = "background", -- Set the display mode.
          -- Available methods are false / true / "normal" / "lsp" / "both"
          -- True is same as normal
          tailwind = true, -- Enable tailwind colors
          -- parsers can contain values used in |user_default_options|
          -- he
          sass = { enable = true, parsers = { "css" } }, -- Enable sass colors
          virtualtext = "■",
          -- update color values even if buffer is not focused
          -- example use: cmp_menu, cmp_docs
          always_update = false,
        },
        -- all the sub-options of filetypes apply to buftypes
        buftypes = {},
      })
    end,
  },
  {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup()
      vim.keymap.set("n", "gR", ":IncRename ", { desc = "Inc Rename" })
    end,
  },
  {
    "numToStr/Comment.nvim",
    -- event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      -- import comment plugin safely
      local comment = require("Comment")

      local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

      -- enable comment
      ---@diagnostic disable-next-line: missing-fields
      comment.setup({
        -- for commenting tsx and jsx files
        pre_hook = ts_context_commentstring.create_pre_hook(),
      })
    end,
  },
  {
    "kevinhwang91/nvim-hlslens",
    config = function()
      require("hlslens").setup()
    end,
  },
  {
    "phaazon/hop.nvim",
    config = function()
      require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
      vim.keymap.set({ "n", "v" }, "s", function()
        require("hop").hint_words()
      end)
    end,
  },
}

