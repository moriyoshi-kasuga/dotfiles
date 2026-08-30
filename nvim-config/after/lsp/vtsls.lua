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

return {
  settings = {
    typescript = { inlayHints = ts_inlay_hints },
    javascript = { inlayHints = ts_inlay_hints },
    vtsls = {
      tsserver = { globalPlugins = global_plugins },
    },
  },
}
