return {
  {
    "scalameta/nvim-metals",
    ft = { "scala", "sbt", "java", "mill" },
    opts = function()
      local metals_config = require("metals").bare_config()

      metals_config.init_options.statusBarProvider = "on"

      metals_config.on_attach = function(_, bufnr)
        vim.keymap.set("n", "<leader>cm", function()
          require("metals").new_scala_file()
        end, { buf = bufnr })

        require("metals").setup_dap()
      end

      metals_config.settings = {
        -- provided by nix
        useGlobalExecutable = true,

        serverVersion = "2.0.0-M2",
        serverProperties = { "-Xmx4g" },
        showImplicitArguments = true,
        showImplicitConversionsAndClasses = true,
        showInferredType = true,
        excludedPackages = {
          "akka.actor.typed.javadsl",
          "com.github.swagger.akka.javadsl",
        },
      }

      return metals_config
    end,
    dependencies = { "mfussenegger/nvim-dap" },
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function()
          -- Only attach metals when build.sbt or build.mill exists (Scala project)
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
