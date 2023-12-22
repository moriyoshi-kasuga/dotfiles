-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
-- if true then return {} end

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  -- Configure LazyVim to load gruvbox
  {
    "craftzdog/solarized-osaka.nvim",
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "solarized-osaka",
    },
  },
  {
    'Exafunction/codeium.vim',
    event = 'BufEnter',
  },
  -- NeoTree
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<leader>e", mode = "n", "<cmd>Neotree focus<cr>", desc = "Neotree focus." },
      { "<leader>o", mode = "n", "<cmd>Neotree close<cr>", desc = "Neotree close." },
    },
    opts = {
      commands = {
        parent_or_close = function(state)
          local node = state.tree:get_node()
          if (node.type == "directory" or node:has_children()) and node:is_expanded() then
            state.commands.toggle_node(state)
          else
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end
        end,
        child_or_open = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" or node:has_children() then
            if not node:is_expanded() then -- if unexpanded, expand
              state.commands.toggle_node(state)
            else                           -- if expanded and has children, seleect the next child
              require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
            end
          else -- if not a directory just open it
            state.commands.open(state)
          end
        end,
      },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignore = true,
          hide_hidden = true,
          hiden_by_name = {
            "node_modules",
          },
          never_show = {
            ".DS_Store",
          }
        }
      },
      window = {
        mappings = {
          h = "parent_or_close",
          l = "child_or_open",
        }
      }
    }

  },
  {
    "folke/noice.nvim",
    keys = {
      { "<S-Enter>", false }, { "<c-f>", false }, { "<c-b>", false },
    }
  },
  {
    "unblevable/quick-scope",
    event = "VeryLazy",
  },
  -- disable trouble
  { "folke/trouble.nvim", enabled = false },
  {
    "folke/flash.nvim",
    ---@type Flash.Config
    opts = {
      modes = {
        search = {
          enabled = false
        },
        char = {
          enabled = false,
        }
      }
    },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", false },
      { "R", false },
    },
  },

  -- add symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },

  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },

  {
    "telescope.nvim",
    dependencies = {
      -- project management
      {
        "ahmedkhalf/project.nvim",
        opts = {
          manual_mode = true,
        },
        event = "VeryLazy",
        config = function(_, opts)
          require("project_nvim").setup(opts)
          require("lazyvim.util").on_load("telescope.nvim", function()
            require("telescope").load_extension("projects")
          end)
        end,
        keys = {
          { "<leader>fp", "<Cmd>Telescope projects<CR>", desc = "Projects" },
        },
      },
    },
  },

  -- add telescope-fzf-native
  {
    "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },

  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
    },
  },

  -- add any tools you want to have installed below
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
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
      { "<leader>te", mode = { "n", "v", }, "<cmd>Translate en<cr>", desc = "Translate English" },
      { "<leader>tj", mode = { "n", "v", }, "<cmd>Translate ja<cr>", desc = "Translate Japanese" },
      {
        "<leader>tE",
        mode = { "n", "v", },
        "<cmd>Translate en -output=replace<cr>",
        desc = "translate to en of replace",
      },
      {
        "<leader>tJ",
        mode = { "n", "v", },
        "<cmd>Translate ja -output=replace<cr>",
        desc = "translate to ja of replace",
      }
    }
  },
  {
    "mbbill/undotree",
    lazy = false,
  },
}
