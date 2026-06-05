return {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      codeLens = {
        enable = true,
      },
      completion = {
        callSnippet = "Replace",
        showWord = "Disable",
      },
      doc = {
        privateName = { "^_" },
      },
      hint = {
        enable = true,
        setType = false,
        paramType = true,
        paramName = "Disable",
        semicolon = "Disable",
        arrayIndex = "Disable",
      },
      workspace = {
        checkThirdParty = false,
      },
      format = {
        enable = false,
      },
    },
  },
}
