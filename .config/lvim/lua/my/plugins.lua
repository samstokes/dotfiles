lvim.plugins = {
  { "lifepillar/vim-solarized8" },
  { "tpope/vim-surround" },
  -- vimwiki and vim-notes are added in vimwiki.lua
  { "chaoren/vim-wordmotion" },
  { "tpope/vim-unimpaired" },
  { "ggandor/leap.nvim" },
  { "ggandor/leap-ast.nvim" },
  { "kiyoon/telescope-insert-path.nvim" },
  {
    "ruifm/gitlinker.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require 'gitlinker'.setup()
    end,
  },
  {
    "samstokes/telescope-todo",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "zbirenbaum/copilot.lua",
    config = function()
      require('copilot').setup({
        filetypes = { vimwiki = false },
        -- disable UI since we're using copilot-cmp
        suggestion = { enabled = false },
        panel = { enabled = false },
        copilot_node_command = 'nvm-node',
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "hrsh7th/nvim-cmp", "zbirenbaum/copilot.lua" },
    config = function()
      require('copilot_cmp').setup()
    end,
  },
  -- add metals but don't actually load it yet, see lsp.lua
  {
    'scalameta/nvim-metals',
    tag = "v0.9.x",
    dependencies = { 'nvim-lua/plenary.nvim' },
  }
}
