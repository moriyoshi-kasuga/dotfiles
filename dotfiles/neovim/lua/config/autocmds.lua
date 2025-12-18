local is_simple_mode = require("config.util").is_in_simple_mode()

local function augroup(name)
  return vim.api.nvim_create_augroup("mori_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

-- Skip these autocmds in simple mode
if not is_simple_mode then
  -- go to last loc when opening a buffer
  vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup("last_loc"),
    callback = function(event)
      local exclude = { "gitcommit" }
      local buf = event.buf
      if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
        return
      end
      vim.b[buf].last_loc = true
      local mark = vim.api.nvim_buf_get_mark(buf, '"')
      local lcount = vim.api.nvim_buf_line_count(buf)
      if mark[1] > 0 and mark[1] <= lcount then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "rust" },
    callback = function()
      vim.keymap.set("i", "'", "'", { buffer = true })
    end,
  })
end
