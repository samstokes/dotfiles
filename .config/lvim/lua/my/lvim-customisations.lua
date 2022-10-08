-- General overrides to LunarVim defaults.

vim.o.wrap = true
vim.o.whichwrap = 'b,s' -- Don't want Left/Right wrapping to next line. Restore vim default.

lvim.builtin.project.silent_chdir = false
lvim.builtin.terminal.insert_mappings = false -- don't clobber <C-t> in insert mode
