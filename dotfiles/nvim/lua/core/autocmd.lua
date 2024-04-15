vim.cmd([[
highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
]])

local ac = vim.api.nvim_create_autocmd
local function ag(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

-- next/prev heading on markdown
ac("FileType", {
  pattern = "markdown",
  group = ag("MarkdownMoveHead"),
  callback = function()
    vim.keymap.set({ "n", "x" }, "]#", [[/^#\+ .*<cr>]], { desc = "Next Heading", buffer = true })
    vim.keymap.set({ "n", "x" }, "[#", [[?^#\+ .*<cr>]], { desc = "Prev Heading", buffer = true })
  end,
})

-- Disable diagnostics in a .env file
ac("BufRead", {
  pattern = { "**/node_modules/**", "node_modules", "/node_modules/*", ".env" },
  group = ag("DisableDiagnostic"),
  callback = function()
    vim.diagnostic.disable(0)
  end,
})

-- tmp以下はundoファイルを作らない
ac("BufWritePre", {
  group = ag("dont_create_undo"),
  pattern = { "/tmp/*" },
  command = "setlocal noundofile",
})

-- ヤンク時にハイライト
ac("TextYankPost", {
  group = ag("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- qでヘルプを抜ける
ac("FileType", {
  group = ag("close_with_q"),
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
ac("VimResized", {
  group = ag("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- ディレクトリが存在しない場合に自動生成する
ac("BufWritePre", {
  group = ag("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
--
-- Fix conceallevel for json files
ac({ "FileType" }, {
  group = ag("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})
