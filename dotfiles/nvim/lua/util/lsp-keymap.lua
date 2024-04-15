local M = {}

local function get_clients(opts)
  local ret = {}
  if vim.lsp.get_clients then
    ret = vim.lsp.get_clients(opts)
  else
    ---@diagnostic disable-next-line: deprecated
    ret = vim.lsp.get_active_clients(opts)
    if opts and opts.method then
      ret = vim.tbl_filter(function(client)
        return client.supports_method(opts.method, { bufnr = opts.bufnr })
      end, ret)
    end
  end
  return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

M._keys = nil

function M.get()
  if M._keys then
    return M._keys
  end
  -- stylua: ignore
  M._keys = {
    { "gd",         function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end,      desc = "Goto Definition",            has = "definition" },
    { "gr",         "<cmd>Telescope lsp_references<cr>",                                                    desc = "References" },
    { "gD",         vim.lsp.buf.declaration,                                                                desc = "Goto Declaration" },
    { "gI",         function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end,  desc = "Goto Implementation" },
    { "gy",         function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, desc = "Goto T[y]pe Definition" },
    { "K",          vim.lsp.buf.hover,                                                                      desc = "Hover" },
    { "gK",         vim.lsp.buf.signature_help,                                                             desc = "Signature Help",             has = "signatureHelp" },
    { "<c-k>",      vim.lsp.buf.signature_help,                                                             mode = "i",                          desc = "Signature Help", has = "signatureHelp" },
    { "<leader>r",  function() vim.lsp.buf.format { async = true, timeout_ms = 2000 } end,                  desc = "Code Action",                mode = { "n", "v" },     has = "codeAction" },
    { "<leader>ca", "<cmd>Lspsaga code_action<cr>",                                                         desc = "Code Action",                mode = { "n", "v" },     has = "codeAction" },
    { "ga",         "<cmd>Lspsaga code_action<cr>",                                                         desc = "Code Action",                mode = { "n", "v" },     has = "codeAction" },
    { "<leader>cc", vim.lsp.codelens.run,                                                                   desc = "Run Codelens",               mode = { "n", "v" },     has = "codeLens" },
    { "<leader>cC", vim.lsp.codelens.refresh,                                                               desc = "Refresh & Display Codelens", mode = { "n" },          has = "codeLens" },
    {
      "<leader>cA",
      function()
        vim.lsp.buf.code_action({
          context = {
            only = {
              "source",
            },
            diagnostics = {},
          },
        })
      end,
      desc = "Source Action",
      has = "codeAction",
    }
  }
  M._keys[#M._keys + 1] = {
    "<leader>cr",
    function()
      local inc_rename = require("inc_rename")
      return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
    end,
    expr = true,
    desc = "Rename",
    has = "rename",
  }
  return M._keys
end

---@param method string
function M.has(buffer, method)
  method = method:find("/") and method or "textDocument/" .. method
  local clients = get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

function M.resolve(buffer)
  local Keys = require("lazy.core.handler.keys")
  if not Keys.resolve then
    return {}
  end
  local spec = M.get()
  local plugin = require("lazy.core.config").plugins["nvim-lspconfig"]
  local opts = {}
  if plugin then
    opts = require("lazy.core.plugin").values(plugin, "opts", false)
  end
  local clients = get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
    vim.list_extend(spec, maps)
  end
  return Keys.resolve(spec)
end

function M.on_attach(_, buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = M.resolve(buffer)

  for _, keys in pairs(keymaps) do
    if not keys.has or M.has(buffer, keys.has) then
      local opts = Keys.opts(keys)
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
    end
  end
end

return M
