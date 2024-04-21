return {
  "echasnovski/mini.indentscope",
  version = false,
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  opts = {
    symbol = "│",
    options = { try_as_border = true },
    mappings = {
      object_scope = "ii",
      object_scope_with_border = "ai",

      goto_left = "[i",
      goto_right = "]i",
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "trouble",
        "lazy",
        "mason",
        "notify",
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
}
