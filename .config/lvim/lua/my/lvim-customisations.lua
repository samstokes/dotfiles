vim.o.wrap = true
vim.o.whichwrap = 'b,s' -- Don't want Left/Right wrapping to next line. Restore vim default.
vim.o.clipboard = '' -- don't clobber clipboard except when I explicitly mean to

lvim.builtin.autopairs.active = false
lvim.builtin.project.silent_chdir = false

-- hlsearch is off so instead of disabling, toggle it
lvim.builtin.which_key.mappings.h = { "<cmd>set invhlsearch<CR>", "Toggle Highlight" }

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
  n = { "<A-j>", "<A-k>" },
}
for mode, mappings in pairs(unwanted_mappings) do
  for _, lhs in ipairs(mappings) do
    vim.keymap.del(mode, lhs, {})
  end
end

local lsp_extra_mappings = {
    ["gy"] = { vim.lsp.buf.type_definition, "Goto Type Definition" },
}

for lhs, rhs in pairs(lsp_extra_mappings) do
  lvim.lsp.buffer_mappings.normal_mode[lhs] = rhs
end

-- add vsplit versions of LSP 'g' mappings
for lhs, _ in pairs(lvim.lsp.buffer_mappings.normal_mode) do
  if lhs:find('g') == 1 then
    local split_lhs = '<C-w>' .. lhs
    local split_rhs = '<cmd>vsplit|normal ' .. lhs .. '<CR>'
    vim.keymap.set('n', split_lhs, split_rhs, {})
  end
end
