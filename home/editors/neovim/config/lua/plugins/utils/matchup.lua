return {
  "andymass/vim-matchup",
  event = { "BufReadPost", "BufNewFile", "BufWritePost" },
  init = function()
    vim.g.matchup_treesitter_disabled = {
      -- highlight is noisy
      "haskell",
    }
    vim.g.matchup_matchparen_status_offscreen = 0
  end,
}
