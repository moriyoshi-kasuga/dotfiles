return {

  "stevearc/aerial.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = { "LspAttach" },
  opts = {
    layout = { min_width = 40 },
    attach_mode = "global",
    backends = { "lsp", "treesitter", "markdown", "man" },
    autojump = true,
    post_jump_cmd = "normal! zz",
    filter_kind = false,
    show_guides = true,
  },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "aerial",
      callback = function(ev)
        vim.schedule(function()
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_win_get_buf(win) == ev.buf then
              vim.api.nvim_set_current_win(win)
              return
            end
          end
        end)
      end,
    })
  end,
  keys = {
    { "gsa", "<cmd>AerialToggle!<CR>", desc = "Aerial Outline" },
    { "[s", "<cmd>AerialPrev<CR>", desc = "Aerial: Previous symbol" },
    { "]s", "<cmd>AerialNext<CR>", desc = "Aerial: Next symbol" },
  },
}
