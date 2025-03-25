return {
  {
    "mfussenegger/nvim-jdtls",
    opts = {
      jdtls = {
        root_dir = vim.fs.root(0, {
          "build.gradle",
          "build.gradle.kts",
          "build.xml", -- Ant
          "pom.xml", -- Maven
          "settings.gradle", -- Gradle
          "settings.gradle.kts", -- Gradle
        }),
        settings = {
          java = {
            format = {
              enabled = true,
              settings = {
                url = "https://github.com/google/styleguide/blob/gh-pages/eclipse-java-google-style.xml",
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
    },
  },
}
