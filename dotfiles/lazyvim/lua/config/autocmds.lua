-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.cmd([[
highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
]])

local ac = vim.api.nvim_create_autocmd
local ag = vim.api.nvim_create_augroup

-- next/prev heading on markdown
ac("FileType", {
  pattern = "markdown",
  callback = function()
    vim.keymap.set({ "n", "x" }, "]#", [[/^#\+ .*<CR>]], { desc = "Next Heading", buffer = true })
    vim.keymap.set({ "n", "x" }, "[#", [[?^#\+ .*<CR>]], { desc = "Prev Heading", buffer = true })
  end,
})

-- Disable diagnostics in a .env file
ac("BufRead", {
  pattern = ".env",
  callback = function()
    vim.diagnostic.disable(0)
  end,
})

-- Disable eslint on node_modules
ac({ "BufNewFile", "BufRead" }, {
  group = ag("DisableEslintOnNodeModules", { clear = true }),
  pattern = { "**/node_modules/**", "node_modules", "/node_modules/*" },
  callback = function()
    vim.diagnostic.disable(0)
  end,
})
--
-- ac({ "TextChangedI", "TextChangedP" }, {
--   callback = function()
--     if vim.bo.filetype ~= vim.fn.expand("%:e") then
--       return
--     end
--     local line = vim.api.nvim_get_current_line()
--     if not line or line == "" then
--       require("cmp").close()
--       return
--     end
--     local cursor = vim.api.nvim_win_get_cursor(0)[2]
--
--     local current = string.sub(line, cursor, cursor + 1)
--     if current == "." or current == "," or current == ";" or current == " " then
--       require("cmp").close()
--     end
--
--     local before_line = string.sub(line, 1, cursor + 1)
--     local after_line = string.sub(line, cursor + 1, -1)
--     if not string.match(before_line, "^%s+$") then
--       if after_line == "" or string.match(before_line, " $") or string.match(before_line, "%.$") then
--         require("cmp").complete()
--       end
--     end
--   end,
--   pattern = "*",
-- })
