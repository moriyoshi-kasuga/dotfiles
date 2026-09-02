---@diagnostic disable: assign-type-mismatch

-- vtsls does not enable inlay hints on its own; turn them on so the
-- LspAttach hook (which only toggles visibility) actually has hints to show.
local ts_inlay_hints = {
  parameterNames = { enabled = "literals", suppressWhenArgumentMatchesName = true },
  parameterTypes = { enabled = true },
  variableTypes = { enabled = true, suppressWhenTypeMatchesName = true },
  propertyDeclarationTypes = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
  enumMemberValues = { enabled = true },
}

local global_plugins = {}

-- Let vtsls see through .astro imports from plain .ts/.js files.
-- The plugin ships inside astro-language-server; its path is exported via ASTRO_TS_PLUGIN_PATH.
local astro_ts_plugin = vim.env.ASTRO_TS_PLUGIN_PATH
if astro_ts_plugin and astro_ts_plugin ~= "" then
  table.insert(global_plugins, {
    name = "@astrojs/ts-plugin",
    location = astro_ts_plugin,
    enableForWorkspaceTypeScriptVersions = true,
  })
end

-- Let vtsls see through .svelte imports from plain .ts/.js files, so e.g.
-- `gr` on an exported symbol also finds usages inside .svelte components.
-- The plugin ships inside svelte-language-server; its path is exported via SVELTE_TS_PLUGIN_PATH.
local svelte_ts_plugin = vim.env.SVELTE_TS_PLUGIN_PATH
if svelte_ts_plugin and svelte_ts_plugin ~= "" then
  table.insert(global_plugins, {
    name = "typescript-svelte-plugin",
    location = svelte_ts_plugin,
    enableForWorkspaceTypeScriptVersions = true,
  })
end

local ts_settings = {
  inlayHints = ts_inlay_hints,
  updateImportsOnFileMove = { enabled = "always" },
  suggest = { completeFunctionCalls = true },
}

return {
  settings = {
    typescript = ts_settings,
    javascript = ts_settings,
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        maxInlayHintLength = 30,
        completion = { enableServerSideFuzzyMatch = true },
      },
      tsserver = { globalPlugins = global_plugins },
    },
  },
  on_attach = function(_, bufnr)
    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc, buffer = bufnr })
    end

    map("gR", function()
      require("config.util").lsp_locations_to_fzf(bufnr, "workspace/executeCommand", {
        command = "typescript.findAllFileReferences",
        arguments = { vim.uri_from_bufnr(bufnr) },
      })
    end, "File References")
  end,
}
