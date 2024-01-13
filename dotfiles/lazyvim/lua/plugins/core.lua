return {
  -- Configure LazyVim to load gruvbox
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
    "folke/noice.nvim",
    keys = {
      { "<S-Enter>", false },
      { "<c-f>", false },
      { "<c-b>", false },
    },
    opts = {
      lsp = {
        progress = {
          enabled = false,
        },
        hover = {
          enabled = false,
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
          ["vim.lsp.util.stylize_markdown"] = false,
          ["cmp.entry.get_documentation"] = false,
        },
      },
    },
  },

  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },
  {
    "unblevable/quick-scope",
    lazy = false,
  },

  {
    "phaazon/hop.nvim",
    event = "User AstroFile",
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
    end,
    keys = {
      { ".w", "<cmd>HopWord<cr>", desc = "HopWord" },
      { ".W", "<cmd>HopWordMW<cr>", desc = "HopWordMW" },
      { ".m", "<cmd>HopAnywhere<cr>", desc = "HopAnywhere" },
      { ".M", "<cmd>HopAnywhereMW<cr>", desc = "HopAnywhereMW" },
      { ".f", "<cmd>HopChar1<cr>", desc = "HopChar1" },
      { ".F", "<cmd>HopChar1MW<cr>", desc = "HopChar1MW" },
      { ".k", "<cmd>HopChar2<cr>", desc = "HopChar2" },
      { ".K", "<cmd>HopChar2MW<cr>", desc = "HopChar2MW" },
    },
  },

  {
    "folke/flash.nvim",
    ---@type Flash.Config
    opts = {
      modes = {
        search = {
          enabled = false,
        },
        char = {
          enabled = false,
        },
      },
    },
    -- keys = {
    --   {
    --     "s",
    --     mode = { "n", "x", "o" },
    --     function()
    --       require("flash").jump()
    --     end,
    --     desc = "Flash",
    --   },
    --   {
    --     "S",
    --     mode = { "n", "o", "x" },
    --     function()
    --       require("flash").treesitter()
    --     end,
    --     desc = "Flash Treesitter",
    --   },
    --   { "r", false },
    --   { "R", false },
    -- },
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
    "folke/noice.nvim",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
    end,
  },
}
