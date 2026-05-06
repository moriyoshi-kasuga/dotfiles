return {
  root_dir = function(fname)
    -- Defer to metals when this is a Scala project
    if vim.fs.root(fname, { "build.sbt" }) then
      return nil
    end
    return vim.fs.root(fname, {
      "build.xml",
      "pom.xml",
      "settings.gradle",
      "settings.gradle.kts",
      ".git",
    })
  end,

  init_options = {
    jvm_args = vim.env.LOMBOK_JAR and { "-javaagent:" .. vim.env.LOMBOK_JAR } or {},
  },

  settings = {
    java = {
      format = {
        enabled = false,
        settings = {
          url = "https://raw.githubusercontent.com/google/styleguide/refs/heads/gh-pages/eclipse-java-google-style.xml",
          profile = "GoogleStyle",
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
