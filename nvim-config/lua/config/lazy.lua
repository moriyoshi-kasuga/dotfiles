-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- lazy-lock.json is owned by the dotfiles repo: lazy only follows it.
-- It is written only by `nvim-lazy-update` (NVIM_LAZY_LOCK_UPDATE=1).
local lock_writable = vim.env.NVIM_LAZY_LOCK_UPDATE == "1"
if not lock_writable then
  require("lazy.manage.lock").update = function() end
end

-- Setup lazy.nvim
local is_simple_mode = require("config.util").is_in_simple_mode()
require("lazy").setup({
  install = {
    missing = not is_simple_mode,
  },
  spec = {
    { import = "plugins" },
    is_simple_mode and {} or { import = "plugins.full" },
  },
  change_detection = { enabled = false },
  checker = { enabled = false },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      paths = vim.tbl_filter(function(p)
        return p ~= ""
      end, {
        vim.env.TREESITTER_PATH or "",
        vim.env.TREESITTER_GRAMMARS or "",
      }),
      disabled_plugins = vim.list_extend({
        "gzip",
        "tarPlugin",
        "tar",
        "tohtml",
        "tutor",
        "zipPlugin",
        "zip",
        "rplugin",
        "spellfile",
      }, is_simple_mode and {} or {
        -- oil.nvim replaces netrw, but it is not installed in simple mode
        "netrwPlugin",
        "netrw",
      }),
    },
  },
})

-- Restore plugins when lazy-lock.json changed since the last restore/update
-- (e.g. after pulling dotfiles). Skipped in simple mode, which loads only a
-- subset of the spec.
local lockfile = require("lazy.core.config").options.lockfile
local stamp = vim.fn.stdpath("state") .. "/lazy-lock.sha256"
local function lock_hash()
  return vim.fn.sha256(table.concat(vim.fn.readfile(lockfile, "b"), "\n"))
end
local function write_stamp()
  vim.fn.mkdir(vim.fn.fnamemodify(stamp, ":h"), "p")
  vim.fn.writefile({ lock_hash() }, stamp)
end

if lock_writable then
  vim.api.nvim_create_autocmd("VimLeavePre", { callback = write_stamp })
elseif not is_simple_mode and vim.fn.filereadable(lockfile) == 1 then
  local current = vim.fn.filereadable(stamp) == 1 and vim.fn.readfile(stamp)[1] or nil
  if lock_hash() ~= current then
    require("lazy").restore({ wait = true })
    write_stamp()
  end
end
