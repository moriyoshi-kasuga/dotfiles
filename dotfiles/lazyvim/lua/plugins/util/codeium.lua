return {

  -- codeium
  {
    "Exafunction/codeium.nvim",
    cmd = "Codeium",
    build = ":Codeium Auth",
    opts = {
      enable_cmp_source = vim.g.ai_cmp,
      virtual_text = {
        enabled = not vim.g.ai_cmp,
        key_bindings = {
          accept = false,
          next = "<C-]>",
          prev = "<C-[>",
        },
      },
    },
  },

  -- add ai_accept action
  {
    "Exafunction/codeium.nvim",
    opts = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      LazyVim.cmp.actions.ai_accept = function()
        if require("codeium.virtual_text").get_current_completion_item() then
          LazyVim.create_undo()
          vim.api.nvim_input(require("codeium.virtual_text").accept())
          return true
        end
      end
    end,
  },

  -- codeium cmp source
  {
    "nvim-cmp",
    dependencies = { "codeium.nvim" },
    opts = function(_, opts)
      table.insert(opts.sources, 1, {
        name = "codeium",
        group_index = 1,
        priority = -1,
      })
    end,
  },
}
