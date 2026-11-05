return {
  "kylechui/nvim-surround",
  version = "^4.0.0",
  event = "VeryLazy",
  config = function()
    local config = require("nvim-surround.config")
    local opts = {
      surrounds = {
        ["g"] = {
          add = function()
            local result = config.get_input("Enter the Type name: ")
            if result then
              return { { result .. "<" }, { ">" } }
            end
          end,
          find = function()
            if vim.g.loaded_nvim_treesitter then
              local selection = config.get_selection({
                query = {
                  capture = "@call.outer",
                  type = "textobjects",
                },
              })
              if selection then
                return selection
              end
            end
            return config.get_selection({ pattern = "[^=%s%<%>{}]+%b<>" })
          end,
          delete = "^(.-%<)().-(%>)()$",
          change = {
            target = "^.-([%w_]+)()%<.-%>()()$",
            replacement = function()
              local result = config.get_input("Enter the Type name: ")
              if result then
                return { { result }, { "" } }
              end
            end,
          },
        },
      },
    }
    require("nvim-surround").setup(opts)
  end,
}
