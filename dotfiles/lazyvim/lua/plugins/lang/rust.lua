return {
  {
    "mrcjkb/rustaceanvim",
    opts = {
      tools = {
        hover_actions = {
          replace_builtin_hover = false,
        },
      },
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set(
            "n",
            "<leader>cx",
            "<cmd>RustLsp openDocs<cr>",
            { silent = true, desc = "Open docs", buffer = bufnr }
          )
          vim.keymap.set(
            "n",
            "<leader>co",
            "<cmd>RustLsp expandMacro<cr>",
            { silent = true, desc = "Expand Macro", buffer = bufnr }
          )
        end,
      },
    },
  },
}
