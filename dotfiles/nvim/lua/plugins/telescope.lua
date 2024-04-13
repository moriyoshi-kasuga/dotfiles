return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = vim.fn.executable("make") == 1 and "make"
          or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        enabled = vim.fn.executable("make") == 1 or vim.fn.executable("cmake") == 1,
        config = function()
        end,
      },
    },
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = "cycle_history_next",
            ["<C-k>"] = "cycle_history_prev",
          },
        },
        file_ignore_patterns = {
          "node_modules",
        },
        pickers = {
          find_files = {
            hidden = false,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      },
    },
    keys = {
      {
        "<leader>,",
        "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
        desc = "Switch Buffer",
      },
      { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
      { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      -- find
      { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find Files (git-files)" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
      -- { "<leader>fR", LazyVim.telescope("oldfiles", { cwd = vim.uv.cwd() }), desc = "Recent (cwd)" },
      -- git
      -- { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Commits" },
      -- { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Status" },
      -- search
      { '<leader>sp', "<cmd>Telescope registers<cr>", desc = "Registers" },
      { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
      {
        "<leader>sS",
        function()
          require("telescope.builtin").lsp_dynamic_workspace_symbols({
            symbols = require("lazyvim.config").get_kind_filter(),
          })
        end,
        desc = "Goto Symbol (Workspace)",
      },
      { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
      { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
      { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
      { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
      { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
      {
        "<leader>ss",
        function()
          require("telescope.builtin").lsp_document_symbols({ })
        end,
        desc = "Goto Symbol",
      },
    },
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = function()
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("ui-select")
    end,
  }
}
