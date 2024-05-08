return {
  {
    "hrsh7th/nvim-cmp",
    opts = {
      formatting = {
        format = function(_, item)
          local icons = require("lazyvim.config").icons.kinds
          if icons[item.kind] then
            item.kind = icons[item.kind] .. item.kind
          end
          local m = item.menu and item.menu or ""
          if #m > 20 then
            item.menu = string.sub(m, 1, 20) .. "..."
          end
          return item
        end,
      },
      window = {
        completion = require("cmp").config.window.bordered({
          border = "single",
        }),
        documentation = require("cmp").config.window.bordered({
          border = "single",
        }),
      },
    },
  },
}
