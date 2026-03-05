local function open_or_attach(fn)
  local bufnr = vim.api.nvim_get_current_buf()
  local hover_win = vim.b[bufnr].hover_preview
  -- ref: https://github.com/lewis6991/hover.nvim/blob/99e4636cfa2778841ed127cfeadf912662bb8bfe/lua/hover/actions.lua#L367
  if hover_win and vim.api.nvim_win_is_valid(hover_win) then
    -- window is open
    vim.api.nvim_set_current_win(hover_win)
  else
    -- window is closed
    fn()
  end
end

return {
  "lewis6991/hover.nvim",
  event = "LspAttach",
  opts = {
    providers = {
      "config.hover-providers.lsp-docs",
      "config.hover-providers.word",
    },
    preview_opts = {
      border = "rounded",
      max_height = 25,
      max_width = 120,
      wrap = true,
    },
    preview_window = false,
    title = false,
  },
  keys = {
    {
      "K",
      function()
        -- to work properly redirect in help
        if vim.bo.filetype == "help" then
          vim.api.nvim_feedkeys("K", "ni", true)
        else
          open_or_attach(function()
            require("hover").open({
              providers = { "config.hover-providers.lsp-docs" },
            })
          end)
        end
      end,
      desc = "hover",
    },
    {
      "<C-'>",
      function()
        open_or_attach(function()
          require("hover").open({
            providers = { "config.hover-providers.word" },
          })
        end)
      end,
      desc = "lookup word",
    },
  },
}
