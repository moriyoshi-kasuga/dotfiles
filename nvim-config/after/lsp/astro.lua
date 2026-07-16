-- astro-language-server has no bundled TypeScript and, under Nix, no global
-- install to discover. Hand it the SDK path exported via TSDK_PATH.
local tsdk = vim.env.TSDK_PATH

if not tsdk or tsdk == "" then
  return {}
end

return {
  init_options = { typescript = { tsdk = tsdk } },
}
