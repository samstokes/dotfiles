-- see https://github.com/kiyoon/telescope-insert-path.nvim
-- ported to LunarVim

local _, tip = pcall(require, 'telescope_insert_path')

local extra_mappings = {
  n = {
    ["p"] = tip.insert_reltobufpath_a_visual,
    ["P"] = tip.insert_reltobufpath_i_visual,
  }
}

for mode, mappings in pairs(extra_mappings) do
  for lhs, rhs in pairs(mappings) do
    lvim.builtin.telescope.defaults.mappings[mode][lhs] = rhs
  end
end
