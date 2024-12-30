local M = {
  todo_count = function()
    return require("todo-txt").todo_count()
  end,
}

return {
  { "samstokes/todo-txt.nvim" },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "todo-txt.nvim" },
    opts = function(_, opts)
      table.insert(opts.sections.lualine_c, 1, M.todo_count)
      return opts
    end,
  },
}
