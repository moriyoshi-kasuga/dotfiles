return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = function()
    return {
      menu = { width = vim.api.nvim_win_get_width(0) - 4 },
      settings = {
        save_on_toggle = true,
      },
    }
  end,
  keys = function()
    local harpoon = require("harpoon")
    local keys = {
      {
        "<leader>m",
        function()
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon Quick Menu",
      },
      {
        "<leader>k",
        function()
          harpoon:list():select(1)
        end,
      },
      {
        "<leader>K",
        function()
          harpoon:list():replace_at(1)
        end,
      },
    }

    local targets = { "m", "n", "p", "s" }

    for base_i, target in ipairs(targets) do
      local i = base_i + 1
      table.insert(keys, {
        "<C-" .. target .. ">",
        function()
          harpoon:list():select(i)
        end,
        desc = "Harpoon Select " .. i,
      })
      table.insert(keys, {
        "," .. target,
        function()
          harpoon:list():replace_at(i)
        end,
        desc = "Harpoon Write to " .. i,
      })
    end

    return keys
  end,
}
