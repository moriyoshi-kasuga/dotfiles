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

-- Setup lazy.nvim
require("lazy").setup({
  install = {
    missing = not require("config.util").is_in_simple_mode(),
  },
  spec = {
    { import = "plugins" },
    { import = "plugins.utils" },
    require("config.util").is_in_simple_mode() and {} or { import = "plugins.coding" },
    require("config.util").is_in_simple_mode() and {} or { import = "plugins.utils-great" },
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
      disabled_plugins = {
        "gzip",
        "matchparen",
        "netrwPlugin",
        "netrw",
        "tarPlugin",
        "tar",
        "tohtml",
        "tutor",
        "zipPlugin",
        "zip",
        "rplugin",
        "spellfile",
      },
    },
  },
})
