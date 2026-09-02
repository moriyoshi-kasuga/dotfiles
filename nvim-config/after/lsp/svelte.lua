-- svelte-language-server has no bundled TypeScript and, under Nix, no global
-- install to discover. Hand it the SDK path exported via TSDK_PATH.
local tsdk = vim.env.TSDK_PATH

if not tsdk or tsdk == "" then
  return {}
end

return {
  init_options = { typescript = { tsdk = tsdk } },
  on_attach = function(_, bufnr)
    vim.keymap.set("n", "gR", function()
      require("config.util").lsp_locations_to_fzf(bufnr, "$/getFileReferences", vim.uri_from_bufnr(bufnr))
    end, { silent = true, desc = "File References", buffer = bufnr })
  end,
}
