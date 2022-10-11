-- call :PackerSync after changing this
-- TODO auto reload on saving this file

lvim.plugins = {
  {
    "ellisonleao/gruvbox.nvim",
    config = function()
      require("gruvbox").setup({})
    end,
  },
  {
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({})
    end,
  },
  -- vimwiki is added in vimwiki.lua
  { "chaoren/vim-wordmotion" },
  { "tpope/vim-unimpaired" },
}
