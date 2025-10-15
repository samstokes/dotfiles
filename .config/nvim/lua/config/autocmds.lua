-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- for Markdown, <Leader>rp to do :w !pandoc | browser-preview
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    local map = LazyVim.safe_keymap_set
    map("n", "<Leader>rp", "<Cmd>w !pandoc | browser-preview<CR>", { desc = "Pandoc to Browser Preview" })
  end,
})
