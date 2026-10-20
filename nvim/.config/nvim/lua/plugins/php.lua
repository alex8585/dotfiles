return {
  -- Extra parsers (html, js, json, lua are already installed by LazyVim)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "php", "css" } },
  },

  -- Intelephense settings
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        intelephense = {
          settings = {
            intelephense = {
              diagnostics = {
                undefinedFunctions = false, -- WP/Laravel use many magic functions
                undefinedTypes = false, -- WP/Laravel use many magic classes
                undefinedConstants = true,
                undefinedVariables = true,
              },
            },
          },
        },
      },
    },
  },

  -- php-cs-fixer with PSR-12
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { php = { "php_cs_fixer" } },
      formatters = {
        php_cs_fixer = { append_args = { "--rules=@PSR12" } },
      },
    },
  },
}
