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
    vim.keymap.set({ "n", "x" }, "]#", [[/^#\+ .*<cr>]], { desc = "Next Heading", buffer = true })
    vim.keymap.set({ "n", "x" }, "[#", [[?^#\+ .*<cr>]], { desc = "Prev Heading", buffer = true })
  end,
})

-- Disable diagnostics in a .env file
ac("BufRead", {
  pattern = { "**/node_modules/**", "node_modules", "/node_modules/*", ".env" },
  group = ag("DisableDiagnostic", { clear = true }),
  callback = function()
    vim.diagnostic.disable(0)
  end,
})

-- tmp以下はundoファイルを作らない
ac( "BufWritePre" , {
  group = vim.api.nvim_create_augroup("dont_create_undo", { clear = true }),
  pattern = { "/tmp/*" },
  command = "setlocal noundofile",
})

-- ヤンク時にハイライト
ac("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- qでヘルプを抜ける
ac("FileType", {
  group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
  pattern = {
    "qf",
    "help",
    "man",
    "lspinfo",
    "checkhealth",
    "startuptime",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- リサイズ時の調整
ac( "VimResized" , {
  group = vim.api.nvim_create_augroup("resize_splits", { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- ファイルを開いた時に、カーソルの場所を復元する
ac("BufReadPost", {
  group = vim.api.nvim_create_augroup("restore_cursor", { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ディレクトリが存在しない場合に自動生成する
ac( "BufWritePre" , {
  group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- 改行時のコメントアウトを無効
ac("FileType", {
  pattern = "*",
  group = vim.api.nvim_create_augroup("disable_comment", { clear = true }),
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
    vim.opt_local.formatoptions:append({ "M", "j" })
  end,
})

