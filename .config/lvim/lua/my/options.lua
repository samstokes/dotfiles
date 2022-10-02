local o = vim.o

o.wildmode = 'longest,list'

-- override lunarvim settings
o.wrap = true
o.whichwrap = 'b,s' -- Don't want Left/Right wrapping to next line. Restore vim default.
