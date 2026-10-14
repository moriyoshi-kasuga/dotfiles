return {
  "nvim-mini/mini.ai",
  event = "VeryLazy",
  opts = {
    n_lines = 500,
    -- move "next" off an/in so Neovim's treesitter incremental selection (v_an, v_in) stays usable
    mappings = {
      around_next = "aN",
      inside_next = "iN",
    },
  },
}
