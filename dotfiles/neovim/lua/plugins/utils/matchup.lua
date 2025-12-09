return {
  "andymass/vim-matchup",
  event = "BufReadPost",
  init = function()
    -- NOTE: disable markdown because so lag
    -- ref: https://github.com/andymass/vim-matchup/issues/416
    vim.g.matchup_treesitter_disabled = { "markdown" }
  end,
}
