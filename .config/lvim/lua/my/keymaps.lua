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

local success, _ = pcall(require, 'leap')
if success then
  -- based on set_default_keymaps in leap:lua/leap/user.lua
  -- but omitting gs (cross-window search) to avoid conflict with LSP bindings
  -- and replacing visual and operator-pending s/S with z/Z to avoid conflict with vim-surround
  local leap_keymaps = {
    {{"n"}, "s", "<Plug>(leap-forward-to)", "Leap forward to"},
    {{"n"}, "S", "<Plug>(leap-backward-to)", "Leap backward to"},
    {{"x", "o"}, "z", "<Plug>(leap-forward-to)", "Leap forward to"},
    {{"x", "o"}, "Z", "<Plug>(leap-backward-to)", "Leap backward to"},
    {{"x", "o"}, "x", "<Plug>(leap-forward-till)", "Leap forward till"},
    {{"x", "o"}, "X", "<Plug>(leap-backward-till)", "Leap backward till"},
  }

  for _, keymap in ipairs(leap_keymaps) do
    local modes = keymap[1]
    local lhs = keymap[2]
    local rhs = keymap[3]
    local desc = keymap[4]
    for _, mode in ipairs(modes) do
      vim.keymap.set(mode, lhs, rhs, {silent = true, desc = desc})
    end
  end
end
