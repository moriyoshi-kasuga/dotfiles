return {
  {
    "mfussenegger/nvim-jdtls",
    opts = {
      jdtls = {
        -- cmd = {
        --   "java",
        --   "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        --   "-Dosgi.bundles.defaultStartLevel=4",
        --   "-Declipse.product=org.eclipse.jdt.ls.core.product",
        --   "-Dlog.protocol=true",
        --   "-Dlog.level=ALL",
        --   "-javaagent:" .. vim.fn.expand("$MASON/share/jdtls/lombok.jar"),
        --   "-Xms1G",
        --   "-Xmx2G",
        --   "--add-modules=ALL-SYSTEM",
        --   "--add-opens",
        --   "java.base/java.util=ALL-UNNAMED",
        --   "--add-opens",
        --   "java.base/java.lang=ALL-UNNAMED",
        --   "-jar",
        --   vim.fn.expand("$MASON/share/jdtls/plugins/org.eclipse.equinox.launcher.jar"),
        --   "-configuration",
        --   vim.fn.expand("$MASON/share/jdtls/config"),
        --   "-data",
        --   workspace_dir,
        -- },
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
