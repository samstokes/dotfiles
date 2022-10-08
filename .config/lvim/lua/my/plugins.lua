-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
-- TODO auto reload on saving this file

lvim.plugins = {
  {
    "ellisonleao/gruvbox.nvim",
    config = function()
      require("gruvbox").setup({})
    end,
  },
  { "tpope/vim-surround" },
  -- vimwiki and vim-notes are added in vimwiki.lua
  { "chaoren/vim-wordmotion" },
  { "tpope/vim-unimpaired" },
  { "kiyoon/telescope-insert-path.nvim" },
  {
    "ggandor/leap.nvim",
    config = function()
      require('leap')

      -- based on set_default_keymaps in leap:lua/leap/user.lua
      -- but omitting gs (cross-window search) to avoid conflict with LSP bindings
      local keymaps = {
        { "n", "s", "<Plug>(leap-forward)" },
        { "n", "S", "<Plug>(leap-backward)" },
        { "x", "s", "<Plug>(leap-forward)" },
        { "x", "S", "<Plug>(leap-backward)" }, { "o", "z", "<Plug>(leap-forward)" },
        { "o", "Z", "<Plug>(leap-backward)" },
        { "o", "x", "<Plug>(leap-forward-x)" },
        { "o", "X", "<Plug>(leap-backward-x)" },
      }
      for _, keymap in ipairs(keymaps) do
        local mode = keymap[1]
        local lhs = keymap[2]
        local rhs = keymap[3]
        vim.keymap.set(mode, lhs, rhs, { silent = true })
      end
    end,
  },
}
