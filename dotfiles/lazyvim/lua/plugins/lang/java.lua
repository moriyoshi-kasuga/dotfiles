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
              enabled = false,
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
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        java = { "google-java-format" },
      },
    },
  },
}
