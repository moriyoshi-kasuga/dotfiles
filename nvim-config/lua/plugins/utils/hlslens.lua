return {
  "kevinhwang91/nvim-hlslens",
  main = "hlslens",
  event = { "BufReadPost", "BufNewFile", "BufWritePost" },
  opts = {},
  keys = {
    {
      mode = "n",
      "n",
      [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
    },
    {
      mode = "n",
      "N",
      [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
    },
  },
}
