---@type LazySpec
return {
  "ibhagwan/fzf-lua",
  dependencies = {
    "nvim-mini/mini.icons",
  },
  cmd = "FzfLua",
  opts = function()
    local fzf = require("fzf-lua")

    fzf.register_ui_select()

    local keymap = fzf.config.defaults.keymap
    keymap.fzf["ctrl-u"] = "half-page-up"
    keymap.fzf["ctrl-d"] = "half-page-down"
    keymap.fzf["ctrl-f"] = "preview-page-down"
    keymap.fzf["ctrl-b"] = "preview-page-up"
    keymap.builtin["<c-f>"] = "preview-page-down"
    keymap.builtin["<c-b>"] = "preview-page-up"

    local actions = fzf.actions

    ---@type fzf-lua.config
    ---@diagnostic disable-next-line: missing-fields
    return {
      winopts = {
        height = 0.85,
        width = 0.75,
        row = 0.5,
        col = 0.5,
        border = "single",
        preview = {
          default = "bat",
          border = "single",
          wrap = "nowrap",
          hidden = "nohidden",
          vertical = "down:60%",
          horizontal = "right:60%",
          layout = "vertical",
        },
      },
      fzf_colors = true,
      defaults = {
        formatter = "path.filename_first",
      },
      fzf_opts = {
        ["--no-scrollbar"] = true,
        ["--layout"] = "reverse",
        ["--info"] = "inline",
        ["--ansi"] = "",
        ["--multi"] = "",
      },
      files = {
        prompt = "Files> ",
        fd_opts = [[--color=never --type f --hidden --follow --exclude .git]],
        actions = {
          ["default"] = actions.file_edit,
        },
      },
      grep = {
        prompt = "Grep> ",
        input_prompt = "Grep For> ",
        rg_opts = [[--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden -g "!.git"]],
        actions = {
          ["default"] = actions.file_edit,
        },
      },
      buffers = {
        prompt = "Buffers> ",
        actions = {
          ["default"] = actions.buf_edit,
          ["ctrl-d"] = { fn = actions.buf_del, reload = true },
        },
      },
      lsp = {
        prompt_postfix = "> ",
        cwd_only = false,
        async_or_timeout = 5000,
        file_icons = true,
        git_icons = false,
        lsp_icons = true,
      },
      diagnostics = {
        prompt = "Diagnostics> ",
        file_icons = true,
        git_icons = false,
        diag_icons = true,
      },
    }
  end,
  keys = {
    { ",", desc = "FzfLua" },
    {
      ",s",
      function()
        require("fzf-lua").files()
      end,
      desc = "Find Files",
    },
    {
      ",r",
      function()
        require("fzf-lua").live_grep()
      end,
      desc = "Grep",
    },
    {
      ",B",
      function()
        require("fzf-lua").lgrep_curbuf()
      end,
      desc = "Grep Buffers",
    },
    {
      ",w",
      function()
        require("fzf-lua").grep_cword()
      end,
      desc = "Grep String",
      mode = "n",
    },
    {
      ",w",
      function()
        require("fzf-lua").grep_visual()
      end,
      desc = "Grep String",
      mode = "x",
    },
    {
      ",b",
      function()
        require("fzf-lua").buffers()
      end,
      desc = "Buffers",
    },
    {
      ",c",
      function()
        require("fzf-lua").colorschemes()
      end,
      desc = "Colorscheme",
    },
    {
      ",f",
      function()
        local fzf = require("fzf-lua")
        fzf.fzf_exec("fd -H -E .git -t d", {
          prompt = "Folders> ",
          actions = {
            ["default"] = function(selected)
              if selected and selected[1] then
                require("oil").open(selected[1])
              end
            end,
          },
        })
      end,
      desc = "Open Folder by Oil",
    },
    {
      ",h",
      function()
        require("fzf-lua").help_tags()
      end,
      desc = "Help Pages",
    },
    {
      ",j",
      function()
        require("fzf-lua").jumps()
      end,
      desc = "Jumplist",
    },
    {
      ",k",
      function()
        require("fzf-lua").keymaps()
      end,
      desc = "Jumplist",
    },
    {
      ",m",
      function()
        require("fzf-lua").marks()
      end,
      desc = "Marks",
    },
    {
      ",p",
      function()
        require("fzf-lua").commands()
      end,
      desc = "Commands",
    },
    {
      ",q",
      function()
        require("fzf-lua").quickfix()
      end,
      desc = "Quickfix",
    },
    {
      ",R",
      function()
        require("fzf-lua").resume()
      end,
      desc = "Resume",
    },
    {
      ",d",
      function()
        require("fzf-lua").diagnostics_document()
      end,
      desc = "Diagnostics (Buffer)",
    },
    {
      ",D",
      function()
        require("fzf-lua").diagnostics_workspace()
      end,
      desc = "Diagnostics (Workspace)",
    },
    {
      ",e",
      function()
        require("fzf-lua").diagnostics_document({ severity_only = "ERROR" })
      end,
      desc = "Error (Buffer)",
    },
    {
      ",E",
      function()
        require("fzf-lua").diagnostics_workspace({ severity_only = "ERROR" })
      end,
      desc = "Error (Workspace)",
    },
    {
      ",gs",
      function()
        require("fzf-lua").git_status()
      end,
      desc = "Git Status",
    },
    {
      ",t",
      function()
        require("todo-comments.fzf").todo()
      end,
      desc = "Todo",
    },
    {
      ",T",
      function()
        require("todo-comments.fzf").todo({ keywords = { "TODO", "FIX", "FIXME" } })
      end,
      desc = "Todo/Fix/Fixme",
    },
  },
}
