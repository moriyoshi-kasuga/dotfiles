return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "BufReadPost",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        terraform = false,
        sh = function()
          if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), ".*\\.env.*") then
            -- disable for .env files
            return false
          end
          return true
        end,
      },
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = { "fang2hou/blink-copilot" },
    opts = {
      sources = {
        default = { "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 0,
            async = true,
          },
        },
      },
    },
  },
}
