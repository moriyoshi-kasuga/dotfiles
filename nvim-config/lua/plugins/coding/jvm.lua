return {
  {
    "scalameta/nvim-metals",
    ft = { "scala", "sbt", "java", "mill" },
    dependencies = {
      "mfussenegger/nvim-dap",
      "saghen/blink.cmp",
    },
    config = function(self)
      local metals_config = require("metals").bare_config()

      local ok, blink = pcall(require, "blink.cmp")
      if ok then
        metals_config.capabilities = blink.get_lsp_capabilities()
      else
        metals_config.capabilities = vim.lsp.protocol.make_client_capabilities()
      end

      local debugging_provider = pcall(require, "dap")

      metals_config.init_options = {
        compilerOptions = {},
        debuggingProvider = debugging_provider,
        testExplorerProvider = debugging_provider,
        disableColorOutput = true,
        doctorProvider = "json",
        doctorVisibilityProvider = true,
        executeClientCommandProvider = true,
        inputBoxProvider = true,
        quickPickProvider = true,
        statusBarProvider = "off",
        bspStatusBarProvider = "off",
        treeViewProvider = true,
      }

      metals_config.on_attach = function(_, bufnr)
        local map = function(keys, fn, desc)
          vim.keymap.set("n", keys, fn, { buffer = bufnr, desc = desc })
        end

        map("<leader>mm", require("metals").new_scala_file, "New Scala File")
        map("<leader>mc", require("metals").commands, "Metals Commands")
        map("<leader>mi", require("metals").import_build, "Import Build")
        map("<leader>mh", require("metals").hover_worksheet, "Hover Worksheet")
        map("<leader>mo", require("metals").organize_imports, "Organize Imports")

        require("metals").setup_dap()
      end

      metals_config.settings = {
        -- provided by nix
        useGlobalExecutable = true,

        verboseCompilation = false,
        serverProperties = { "-Xms1g", "-Xmx8g" },
        superMethodLensesEnabled = true,
        showImplicitArguments = false,
        showImplicitConversionsAndClasses = false,
        showInferredType = false,
        enableSemanticHighlighting = true,
        excludedPackages = {
          "akka.actor.typed.javadsl",
          "com.github.swagger.akka.javadsl",
        },
      }

      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function()
          if vim.fs.root(vim.api.nvim_buf_get_name(0), { "build.sbt", "build.mill" }) then
            require("metals").initialize_or_attach(metals_config)
          end
        end,
        group = nvim_metals_group,
      })
    end,
  },

  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
      local workspace_base = vim.env.HOME .. "/.local/share/jdtls/workspaces"

      local group = vim.api.nvim_create_augroup("nvim-jdtls", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        group = group,
        callback = function()
          local fname = vim.api.nvim_buf_get_name(0)

          -- Defer to metals when this is a Scala project
          if vim.fs.root(fname, { "build.sbt", "build.mill" }) then
            return
          end

          local root_dir = vim.fs.root(fname, {
            "build.xml",
            "pom.xml",
            "settings.gradle",
            "settings.gradle.kts",
            "gradlew",
            "mvnw",
            ".git",
          })

          if not root_dir then
            return
          end

          local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
          local workspace_dir = workspace_base .. "/" .. project_name

          local ok, blink = pcall(require, "blink.cmp")
          local capabilities = ok and blink.get_lsp_capabilities() or vim.lsp.protocol.make_client_capabilities()

          require("jdtls").start_or_attach({
            cmd = { "jdtls", "-data", workspace_dir },
            root_dir = root_dir,
            capabilities = capabilities,

            init_options = {
              jvm_args = vim.env.LOMBOK_JAR and { "-javaagent:" .. vim.env.LOMBOK_JAR } or {},
            },

            on_attach = function(_, bufnr)
              local map = function(mode, keys, fn, desc)
                vim.keymap.set(mode, keys, fn, { buffer = bufnr, desc = desc, silent = true })
              end

              map("n", "<leader>jo", require("jdtls").organize_imports, "Organize Imports")
            end,

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
          })
        end,
      })
    end,
  },
}
