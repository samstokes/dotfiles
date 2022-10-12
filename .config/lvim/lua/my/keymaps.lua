vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', {})

local normal_mappings = {
  ["<A-h>"] = "<C-w>h",
  ["<A-j>"] = "<C-w>j",
  ["<A-k>"] = "<C-w>k",
  ["<A-l>"] = "<C-w>l",
}

for lhs, rhs in pairs(normal_mappings) do
  vim.keymap.set('n', lhs, rhs, {})
end
