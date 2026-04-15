-- ここに置いたのは simplenvim でローディングされないように分離するため
return {
  "olimorris/persisted.nvim",
  event = "BufReadPre",
  opts = {},
}
