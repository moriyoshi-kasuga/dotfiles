return {
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = {
          skip = true,
        },
      })
      table.insert(opts.routes, {
        filter = {
          event = "msg_show",
          any = {
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
        {},
      })
      table.insert(opts.routes, {
        filter = {
          any = {
            { find = "%d+L, %d+B" },
            { find = "No information available" },
            { find = "jdtls" },
          },
        },
        opts = {
          skip = true,
        },
      })
    end,
  },
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        inc_rename = true,
        lsp_doc_border = true,
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        signature = { enabled = true },
        hover = { enabled = true },
        documentation = {
          view = "hover",
          ---@type NoiceViewOptions
          opts = {
            border = { style = "rounded" },
            relative = "cursor",
            position = {
              row = 2,
            },
            win_options = {
              concealcursor = "n",
              conceallevel = 3,
              winhighlight = {
                Normal = "LspFloat",
                FloatBorder = "LspFloatBorder",
              },
            },
          },
        },
      },
    },
  },
}
