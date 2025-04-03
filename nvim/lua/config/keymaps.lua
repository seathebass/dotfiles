-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<space>n", "<Cmd>Neotree toggle<CR>")
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "r" },
  group = vim.api.nvim_create_augroup("r_keymaps", { clear = true }),
  callback = function()
    vim.keymap.set("i", "<C-a>", "<Space><-<Space>")
    vim.keymap.set("i", "<C-p>", "<Space>|><Enter>")
  end,
})
