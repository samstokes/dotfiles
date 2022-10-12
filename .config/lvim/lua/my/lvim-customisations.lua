-- General overrides to LunarVim defaults.

vim.o.wrap = true
vim.o.whichwrap = 'b,s' -- Don't want Left/Right wrapping to next line. Restore vim default.

lvim.builtin.autopairs.active = false
lvim.builtin.project.silent_chdir = false
lvim.builtin.terminal.insert_mappings = false -- don't clobber <C-t> in insert mode
lvim.builtin.dap.active = true

-- Even smarter find_project_files (cf lvim:lua/lvim/core/telescope/custom-finders.lua)
local find_project_files = function()
  local builtin = require("telescope.builtin")

  -- trust project plugin to set CWD appropriately, so don't need to search up tree for .git
  ---@diagnostic disable-next-line:missing-parameter
  if vim.fn.glob('.git') == '.git' then
    builtin.git_files()
  else
    builtin.find_files()
  end
end

-- overwrite builtin <Leader>f mapping
lvim.builtin.which_key.mappings.f = { find_project_files, "Find File" }

-- unmap lvim mappings I don't want
local unwanted_mappings = {
  i = { "jk", "kj", "jj" },
  n = { "<A-j>", "<A-k>" },
}
for mode, mappings in pairs(unwanted_mappings) do
  for _, lhs in ipairs(mappings) do
    vim.keymap.del(mode, lhs, {})
  end
end
