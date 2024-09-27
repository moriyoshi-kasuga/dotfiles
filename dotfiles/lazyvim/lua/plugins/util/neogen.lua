local prefix = "<leader>a"
return {
  "danymat/neogen",
  cmd = "Neogen",
  opts = {
    languages = {
      lua = { template = { annotation_convention = "emmylua" } },
      typescript = { template = { annotation_convention = "tsdoc" } },
      typescriptreact = { template = { annotation_convention = "tsdoc" } },
      python = { template = { annotation_convention = "google_docstrings" } },
    },
  },
  keys = {
    { prefix, desc = "Annotation" },
    {
      prefix .. "<cr>",
      function()
        require("neogen").generate({})
      end,
      desc = "Current",
    },
    {
      prefix .. "c",
      function()
        require("neogen").generate({ type = "class" })
      end,
      desc = "Class",
    },
    {
      prefix .. "f",
      function()
        require("neogen").generate({ type = "func" })
      end,
      desc = "Function",
    },
    {
      prefix .. "t",
      function()
        require("neogen").generate({ type = "type" })
      end,
      desc = "Type",
    },
    {
      prefix .. "F",
      function()
        require("neogen").generate({ type = "file" })
      end,
      desc = "File",
    },
  },
}
