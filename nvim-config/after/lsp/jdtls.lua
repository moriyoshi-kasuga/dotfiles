return {
  settings = {
    java = {
      format = {
        enabled = false,
        settings = {
          url = "https://raw.githubusercontent.com/google/styleguide/refs/heads/gh-pages/eclipse-java-google-style.xml",
          profile = "GoogleStyle",
          -- url = "https://raw.githubusercontent.com/redhat-developer/vscode-java/refs/heads/master/formatters/eclipse-formatter.xml",
          -- profile = "Eclipse",
        },
      },
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
      },
      maven = {
        downloadSources = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = "all",
        },
      },
      implementationsCodeLens = {
        enabled = false,
      },
      referencesCodeLens = {
        enabled = false,
      },
      signatureHelp = {
        enabled = true,
      },
      contentProvider = { preferred = "fernflower" },
      completion = {
        favoriteStaticMembers = {
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
        },
      },
    },
  },
}
