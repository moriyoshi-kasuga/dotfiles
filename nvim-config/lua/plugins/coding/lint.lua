---@type LazySpec[]
return {
  {
    "mfussenegger/nvim-lint",
    -- Loading on BufReadPost would replay that event for the first buffer
    -- before its filetype is detected, so that buffer would never be linted.
    event = { "BufReadPre", "BufNewFile", "BufWritePost" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        dockerfile = { "hadolint" },
      }

      -- Each host only has the linters of the lang.* modules it imports, so
      -- skip linters whose command is not on PATH, as lsp.lua does for servers.
      local function installed(linter)
        local cmd = linter.cmd
        if type(cmd) == "function" then
          cmd = cmd()
        end
        return vim.fn.executable(cmd) == 1
      end

      local function try_lint()
        -- GitHub Actions workflows keep the plain yaml filetype, so actionlint
        -- is picked by path rather than through linters_by_ft.
        local path = vim.api.nvim_buf_get_name(0)
        if vim.bo.filetype == "yaml" and path:match("/%.github/workflows/[^/]+%.ya?ml$") then
          lint.try_lint("actionlint", { filter = installed })
          return
        end

        -- Only lint if linter is configured for this filetype
        local linters = lint.linters_by_ft[vim.bo.filetype]
        if linters and #linters > 0 then
          lint.try_lint(nil, { filter = installed })
        end
      end

      -- Auto-lint on these events
      local lint_augroup = vim.api.nvim_create_augroup("nvim-lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = lint_augroup,
        callback = try_lint,
      })

      -- Create a command to manually trigger linting
      vim.api.nvim_create_user_command("Lint", try_lint, {
        desc = "Trigger linting for current file",
      })
    end,
  },
}
