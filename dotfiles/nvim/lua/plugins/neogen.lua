return {
  "danymat/neogen",
  opts = {
    snippet_engine = "luasnip",
    languages = {
      lua = { template = { annotation_convention = "emmylua" } },
      typescript = { template = { annotation_convention = "tsdoc" } },
      typescriptreact = { template = { annotation_convention = "tsdoc" } },
      python = { template = { annotation_convention = "google_docstrings" } },
    },
  },
  config = function(opts)
    require("neogen").setup(opts)
    require("which-key").register({
      ["<leader>a"] = {
        name = "+annotation",
        ["<cr>"] = { function() require("neogen").generate({}) end, "Current" },
        c = { function() require("neogen").generate({ type = "class" }) end, "Class" },
        f = { function() require("neogen").generate({ type = "func" }) end, "Function" },
        t = { function() require("neogen").generate({ type = "type" }) end, "Type" },
        F = { function() require("neogen").generate({ type = "file" }) end, "File" },
      }
    })
  end
}
