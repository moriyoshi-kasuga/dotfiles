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
  },
}
