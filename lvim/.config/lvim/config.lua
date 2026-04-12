-- =========================================
-- 🧠 LUNARVIM CONFIG (PHP / Laravel Optimized)
-- ~/.config/lvim/config.lua
-- =========================================

-- =========================================
-- 📝 EDITOR UI
-- =========================================

vim.opt.wrap        = true
vim.opt.linebreak   = true
vim.opt.breakindent = true
vim.opt.showbreak   = "↳ "

-- =========================================
-- ⌨️  KEYMAPS
-- =========================================

-- ⚡ Быстрый выход из Insert mode
vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = true })

-- 🔄 Навигация по буферам (H=назад, L=вперёд — логично как < и >)
vim.keymap.set('n', 'H', ':bprevious<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'L', ':bnext<CR>', { noremap = true, silent = true })

-- 📐 Изменение размеров сплитов (стрелки — безопасно, не перекрывают Vim)
vim.keymap.set("n", "<C-Up>", ":resize +5<CR>", { silent = true })
vim.keymap.set("n", "<C-Down>", ":resize -5<CR>", { silent = true })
vim.keymap.set("n", "<C-Left>", ":vertical resize -5<CR>", { silent = true })
vim.keymap.set("n", "<C-Right>", ":vertical resize +5<CR>", { silent = true })

-- 💾 Форматировать + сохранить (курсор не прыгает)
vim.keymap.set("n", "<C-s>", function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.lsp.buf.format({ async = false })
  vim.cmd("w")
  vim.api.nvim_win_set_cursor(0, cursor)
end, { silent = true })

-- 🔍 Telescope
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")

-- =========================================
-- 📦 PLUGINS
-- (только то, чего нет в LunarVim по умолчанию)
-- =========================================

lvim.plugins = {

  -- Blade-синтаксис для Laravel
  { "jwalton512/vim-blade" },

  -- Удобная работа со скобками/тегами
  { "tpope/vim-surround" },

  -- Автозакрытие HTML-тегов (нужен setup)
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  -- Файловый менеджер Oil
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup()
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { silent = true })
    end,
  },

  -- Список ошибок / диагностики
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup()
      vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<CR>", { silent = true })
      vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", { silent = true })
      vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>", { silent = true })
    end,
  },

}

-- =========================================
-- 🌳 TREESITTER
-- (через lvim, не напрямую — иначе конфликт)
-- =========================================

lvim.builtin.treesitter.ensure_installed = {
  "php", "html", "css", "javascript", "json", "lua",
}
lvim.builtin.treesitter.highlight.enable = true

-- Blade → правильный filetype для vim-blade
vim.filetype.add({
  pattern = {
    [".*%.blade%.php"] = "blade",
  },
})

-- =========================================
-- 🧠 LSP: INTELEPHENSE
-- =========================================

require("lvim.lsp.manager").setup("intelephense", {
  settings = {
    intelephense = {
      diagnostics = {
        undefinedFunctions = false,  -- WP/Laravel: много магических функций
        undefinedTypes     = false,  -- WP/Laravel: много магических классов
        undefinedConstants = true,   -- полезно держать включённым
        undefinedVariables = true,   -- полезно держать включённым
      },
    },
  },
})

-- =========================================
-- 🎨 ФОРМАТТЕР PHP (php-cs-fixer)
-- Установка: composer global require friendsofphp/php-cs-fixer
-- Для Laravel Pint: composer require --dev laravel/pint
-- =========================================


local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
  {
    name = "phpcsfixer",
    args = { "--rules=@PSR12" },
  },
})

-- =========================================
-- ⚠️ DIAGNOSTICS UI
-- =========================================

vim.diagnostic.config({
  virtual_text     = true,
  signs            = true,
  underline        = true,
  update_in_insert = false,
})

-- =========================================
-- 🧠 LSP KEYBINDS
-- =========================================

lvim.lsp.on_attach_callback = function(client, bufnr)
  local opts = { buffer = bufnr, silent = true }

  -- Навигация
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

  -- Рефакторинг
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

  -- Диагностика
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
end

-- =========================================
-- 🎨 GITSIGNS (встроен в LunarVim, только настройки)
-- =========================================

lvim.builtin.gitsigns.opts.current_line_blame = true -- inline git blame

-- =========================================
-- 🧠 AUTOCMD: ПОДСВЕТКА ССЫЛОК ПОД КУРСОРОМ
-- (buffer-local, без глобального дубля)
-- =========================================

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client and client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd("CursorHold", {
        buffer   = args.buf,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd("CursorMoved", {
        buffer   = args.buf, -- ← buffer-local, не глобальный
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})


vim.keymap.set("n", "<M-Left>", ":vertical resize +5<CR>", { silent = true })
vim.keymap.set("n", "<M-Right>", ":vertical resize -5<CR>", { silent = true })
