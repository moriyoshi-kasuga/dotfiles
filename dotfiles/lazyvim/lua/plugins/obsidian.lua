local path = vim.fn.expand("~/Desktop/Obsidian/Main")
local leader = "<leader>O"

return {
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    event = {
      "BufReadPre " .. path .. "/**.md",
      "BufNewFile " .. path .. "/**.md",
    },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",

      -- see below for full list of optional dependencies 👇
    },
    opts = {
      pen_notes_in = "current",
      sort_by = "modified",
      sort_reversed = true,
      workspaces = {
        {
          name = "Main",
          path = path,
        },
      },

      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- Toggle check-boxes.
        ["<leader>ch"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        ["<leader><space>"] = {
          action = function()
            return "<cmd>ObsidianSearch<cr>"
          end,
          opts = { buffer = true, expr = true },
        },
        [leader .. "b"] = {
          action = function()
            return "<cmd>ObsidianBacklinks<cr>"
          end,
          opts = { buffer = true, expr = true },
        },
        [leader .. "d"] = {
          action = function()
            return "<cmd>ObsidianDailies<cr>"
          end,
          opts = { buffer = true, expr = true },
        },
        [leader .. "n"] = {
          action = function()
            return "<cmd>ObsidianNew<cr>"
          end,
          opts = { buffer = true, expr = true },
        },
      },

      -- see below for full list of options 👇
      notes_subdir = "000_Inbox",
      new_notes_location = "notes_subdir",
      templates = {
        subdir = "999_Templates",
        date_format = "%Y年%m月%d日",
      },
      -- Default save location for newly daily notes
      daily_notes = {
        folder = "001_DailyNotes",
        date_format = "%Y年%m月%d日",
        template = "TemplateDaily.md",
      },
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
    },
  },
}
