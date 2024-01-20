return {
  -- tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "black",
        "prettier",
        "stylua",
        "selene",
        "luacheck",
        "shellcheck",
        "shfmt",
        "tailwindcss-language-server",
        "typescript-language-server",
        "html-lsp",
        "css-lsp",
        "bash-language-server",
        "hadolint",
        "flake8",
        "djlint",
      })
    end,
  },

  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = true },
    },
  },

  -- formatters
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        djlint = {
          prepend_args = { "--indent", "2" },
        },
        black = {
          prepend_args = { "--fast" },
        },
        flake8 = {
          prepend_args = { "--max-line-length", "88" },
        },
      },
      formatters_by_ft = {
        ["htmldjango"] = { "djlint" },
      },
    },
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "js-everts/cmp-tailwind-colors", opts = {} },
    },
    opts = function(_, opts)
      local format_kinds = opts.formatting.format
      opts.formatting.format = function(entry, item)
        if item.kind == "Color" then
          item = require("cmp-tailwind-colors").format(entry, item)
          if item.kind == "Color" then
            return format_kinds(entry, item)
          end
          return item
        end
        return format_kinds(entry, item)
      end
    end,
  },
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
    ft = { "scala", "sbt" },
    init = function()
      local metals_config = require("metals").bare_config()
      metals_config.init_options.statusBarProvider = "on"
      metals_config.settings = {
        showImplicitArguments = true,
        superMethodLensesEnabled = true,
        showInferredType = true,
        showImplicitConversionsAndClasses = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
      }
      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        -- NOTE: You may or may not want java included here. You will need it if you
        -- want basic Java support but it may also conflict if you are using
        -- something like nvim-jdtls which also works on a java filetype autocmd.
        pattern = { "scala", "sbt" },
        callback = function(args)
          local wk = require("which-key")
          wk.register({
            ["gs"] = { require("metals").goto_super_method, "Goto Super" },
            ["gS"] = { require("metals").super_method_hierarchy, "Super Method Hierarchy" },
            ["<leader>cu"] = { require("metals").show_cfr, "Show Cfr" },
            ["<leader>cn"] = { require("metals").new_scala_file, "New Scala File" },
            ["<leader>cN"] = { require("metals").new_java_file, "New Java File" },
            ["<leader>co"] = { require("metals").organize_imports, "Organize Imports" },
          }, { mode = "n", buffer = args.buf })
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end,
  },
}
