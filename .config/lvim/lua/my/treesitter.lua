vim.o.foldexpr = 'nvim_treesitter#foldexpr()'

require 'nvim-treesitter.configs'.setup {
  incremental_selection = { enable = true },
}
