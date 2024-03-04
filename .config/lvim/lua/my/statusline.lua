lvim.builtin.lualine.on_config_done = function(lualine)
  local todo = require 'telescope-todo'
  local config = lualine.get_config()
  table.insert(config.sections.lualine_c, todo.todo_count)
  lualine.setup(config)
end
