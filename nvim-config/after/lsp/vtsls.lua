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

return {
  settings = {
    typescript = { inlayHints = ts_inlay_hints },
    javascript = { inlayHints = ts_inlay_hints },
  },
}
