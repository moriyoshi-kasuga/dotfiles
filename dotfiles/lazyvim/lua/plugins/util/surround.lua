return {
  "kylechui/nvim-surround",
  version = "*",
  event = "VeryLazy",
  config = function()
    require("nvim-surround").setup({
      surrounds = {
        ["I"] = {
          add = function()
            local both_delimiter = require("nvim-surround.input").get_input("Enter the bot hdelimiter: ")
            if both_delimiter then
              return { { both_delimiter }, { both_delimiter } }
            end
          end,
          find = function() end,
          delete = function() end,
        },
      },
    })
  end,
}
