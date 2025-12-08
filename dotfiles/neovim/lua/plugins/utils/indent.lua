return {
  "echasnovski/mini.indentscope",
  event = "VeryLazy",
  opts = {
    symbol = "│",
    options = { try_as_border = true },
    draw = {
      delay = 0,
      animation = function()
        return 0
      end,
    },
    mappings = {
      -- Textobjects
      object_scope = "ii",
      object_scope_with_border = "ai",

      -- Motions (jump to respective border line; if not present - body line)
      goto_top = "[i",
      goto_bottom = "]i",
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "markdown",
        "aerial",
        "help",
        "lazy",
        "mason",
        "notify",
        "oil",
        "snacks_dashboard",
        "snacks_notif",
        "snacks_terminal",
        "snacks_win",
        "toggleterm",
        "Trouble",
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
}
