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
}
