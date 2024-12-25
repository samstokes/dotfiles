vim.g.maplocalleader = ';'
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', {})

-- rebind illuminate mappings since <A-n> won't work on Mac
local illuminate_mappings = {
  ["]r"] = { "goto_next_reference", "Move to next reference" },
  ["[r"] = { "goto_prev_reference", "Move to previous reference" },
}
for lhs, rhs in pairs(illuminate_mappings) do
  local func, desc = rhs[1], rhs[2]
  vim.keymap.set('n', lhs, "<cmd>lua require('illuminate')['" .. func .. "']()<CR>",
    { noremap = true, silent = true, desc = desc })
end

lvim.builtin.which_key.mappings["t"] = {
  "<cmd>Telescope todo<cr>",
  "TODOs",
}

local success, _ = pcall(require, 'leap')
if success then
  -- based on set_default_keymaps in leap:lua/leap/user.lua
  -- but omitting gs (cross-window search) to avoid conflict with LSP bindings
  -- and replacing visual and operator-pending s/S with z/Z to avoid conflict with vim-surround
  local leap_keymaps = {
    { { "n" },           "s",  "<Plug>(leap-forward-to)",                "Leap forward to" },
    { { "n" },           "S",  "<Plug>(leap-backward-to)",               "Leap backward to" },
    { { "x", "o" },      "z",  "<Plug>(leap-forward-to)",                "Leap forward to" },
    { { "x", "o" },      "Z",  "<Plug>(leap-backward-to)",               "Leap backward to" },
    { { "x", "o" },      "x",  "<Plug>(leap-forward-till)",              "Leap forward till" },
    { { "x", "o" },      "X",  "<Plug>(leap-backward-till)",             "Leap backward till" },
    { { "n", "x", "o" }, "\\", function() require 'leap-ast'.leap() end, "Leap AST" },
  }

  for _, keymap in ipairs(leap_keymaps) do
    local modes = keymap[1]
    local lhs = keymap[2]
    local rhs = keymap[3]
    local desc = keymap[4]
    for _, mode in ipairs(modes) do
      vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
    end
  end
end
