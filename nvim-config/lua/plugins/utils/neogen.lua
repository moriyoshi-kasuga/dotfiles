return {
  "danymat/neogen",
  dependencies = "nvim-treesitter/nvim-treesitter",
  keys = {
    {
      "<leader>d",
      function()
        require("neogen").generate()
      end,
      desc = "Generate Annotations",
    },
  },
  opts = {
    snippet_engine = "nvim",
    languages = {
      lua = { template = { annotation_convention = "ldoc" } },
      typescript = { template = { annotation_convention = "jsdoc" } },
      rust = { template = { annotation_convention = "rustdoc" } },
    },
  },
}
