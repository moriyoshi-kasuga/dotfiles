---@diagnostic disable: undefined-global
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    zen = { enabled = true },
    words = { enabled = true },
    notifier = {
      enabled = true,
    },

    terminal = {
      win = {
        style = "terminal",
        wo = {
          winblend = 0,
        },
      },
    },

    explorer = { enabled = false },
    picker = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.dim():map("<leader>uD")
      end,
    })

    ---@type table<number, { token:lsp.ProgressToken, msg:string, done:boolean }[]>
    local progress = vim.defaulttable()

    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

    ---@param client vim.lsp.Client
    ---@param value table
    local function should_skip(client, value)
      if client.name ~= "metals" then
        return false
      end

      -- metals の高頻度 report を完全に無視
      if value.kind == "report" then
        return true
      end

      local text = table.concat({
        value.title or "",
        value.message or "",
      }, " ")

      -- dependency compile spam
      if text:find("%.metals/readonly/dependencies") then
        return true
      end

      if text:find("^Compiled ") then
        return true
      end

      if text:find("Indexing complete!") then
        return true
      end

      return false
    end

    vim.api.nvim_create_autocmd("LspProgress", {
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local value = ev.data.params.value

        if not client or type(value) ~= "table" then
          return
        end

        if should_skip(client, value) then
          return
        end

        local p = progress[client.id]

        local msg = ("%s%s"):format(value.title or "", value.message and (" %s"):format(value.message) or "")

        if value.percentage then
          msg = ("[%3d%%] %s"):format(value.percentage, msg)
        end

        for i = 1, #p + 1 do
          if i == #p + 1 or p[i].token == ev.data.params.token then
            p[i] = {
              token = ev.data.params.token,
              msg = msg,
              done = value.kind == "end",
            }
            break
          end
        end

        local messages = {}

        progress[client.id] = vim.tbl_filter(function(v)
          table.insert(messages, v.msg)
          return not v.done
        end, p)

        if #messages == 0 then
          Snacks.notifier.hide("lsp_progress_" .. client.id)
          return
        end

        Snacks.notifier.notify(table.concat(messages, "\n"), "info", {
          id = "lsp_progress_" .. client.id,
          title = "LSP • " .. client.name,
          timeout = false,
          keep = function()
            return #progress[client.id] > 0
          end,
          icon = spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1],
        })
      end,
    })
  end,
  keys = {
    {
      "<leader>cR",
      function()
        Snacks.rename.rename_file()
      end,
      desc = "Rename File",
    },
    {
      "<leader>gB",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git Browse",
      mode = { "n", "v" },
    },
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<c-/>",
      function()
        Snacks.terminal()
      end,
      desc = "Toggle Terminal",
    },
    {
      "[w",
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = "Previous word",
    },
    {
      "]w",
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = "Next word",
    },
    {
      "<leader>z",
      function()
        Snacks.zen()
      end,
      desc = "Toggle Zen Mode",
    },
    {
      "<leader>wm",
      function()
        Snacks.zen.zoom()
      end,
      desc = "Toggle Zoom",
    },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    },
    {
      "<leader>sna",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification All",
    },
    {
      "<leader>snd",
      function()
        Snacks.notifier.hide()
      end,
      desc = "Dismiss All Notification",
    },
  },
}
