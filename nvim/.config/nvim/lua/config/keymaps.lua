-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

-- Leave insert mode quickly
map("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Resize splits by 5 (LazyVim default step is 2)
map("n", "<C-Up>", "<cmd>resize +5<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -5<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -5<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +5<cr>", { desc = "Increase window width" })
map("n", "<M-Left>", "<cmd>vertical resize +5<cr>", { desc = "Increase window width" })
map("n", "<M-Right>", "<cmd>vertical resize -5<cr>", { desc = "Decrease window width" })

-- Live grep (the default <leader>fg is git files in LazyVim)
map("n", "<leader>fg", function()
  Snacks.picker.grep()
end, { desc = "Live grep" })

-- Rename symbol
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
