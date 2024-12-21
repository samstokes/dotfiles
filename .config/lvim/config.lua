require('my.gui')
require('my.options')
require('my.lvim-customisations') -- before keymaps, so keymaps can override
require('my.plugins')
require('my.keymaps') -- after plugins, so keymaps can invoke plugins
require('my.statusline') -- after plugins, so statusline can invoke plugins
require('my.treesitter')
require('my.telescope')
require('my.lsp')
require('my.vimwiki')

lvim.colorscheme = "solarized8_flat"
lvim.format_on_save.enabled = true
