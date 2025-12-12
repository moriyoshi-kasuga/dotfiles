---@type LazySpec[]
return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile", "BufWritePost" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        nix = { "statix" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        python = { "ruff" },
        dockerfile = { "hadolint" },
      }

      -- Auto-lint on these events
      local lint_augroup = vim.api.nvim_create_augroup("nvim-lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          -- Only lint if linter is configured for this filetype
          local linters = lint.linters_by_ft[vim.bo.filetype]
          if linters and #linters > 0 then
            lint.try_lint()
          end
        end,
      })

      -- Create a command to manually trigger linting
      vim.api.nvim_create_user_command("Lint", function()
        lint.try_lint()
      end, {
        desc = "Trigger linting for current file",
      })
    end,
  },
}
