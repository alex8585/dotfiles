return {
  -- Blade syntax for Laravel
  {
    "jwalton512/vim-blade",
    ft = "blade",
    init = function()
      vim.filetype.add({ pattern = { [".*%.blade%.php"] = "blade" } })
    end,
  },

  -- Classic surround mappings (cs, ds, ys); coexists with the bundled mini.surround (gs*)
  { "tpope/vim-surround", event = "VeryLazy" },

  -- File manager as a buffer
  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {},
    keys = { { "-", "<cmd>Oil<cr>", desc = "Open parent directory" } },
  },

  -- Inline git blame
  {
    "lewis6991/gitsigns.nvim",
    opts = { current_line_blame = true },
  },
}
