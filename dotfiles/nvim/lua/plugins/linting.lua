return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    linters_by_ft = {

    }
  },
  config = function(opts)
    local lint = require("lint")

    lint.linters_by_ft = opts.linters_by_ft
  end,
}
