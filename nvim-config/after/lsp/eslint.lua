-- Helps eslint find the right config when it lives in a subfolder instead of
-- the resolved workspace root (monorepos with per-package eslintrc/flat config).
return {
  settings = {
    workingDirectory = { mode = "auto" },
  },
}
