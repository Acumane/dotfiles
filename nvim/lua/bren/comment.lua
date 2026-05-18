-- No-op when `commentstring` is empty
require('mini.comment').setup({
  mappings = {
    comment        = 'gc',     -- operator: gc{motion}
    comment_line   = '<C-_>',  -- normal: toggle current line
    comment_visual = '<C-_>',  -- visual: toggle selection
    textobject     = 'gc',
  },
})

-- free since cword-search uses <C-f>
local set = vim.keymap.set
set({'n','x'}, '<C-/>', '<C-_>', { remap = true, desc = 'Toggle comment' })
set({'n','x'}, '/',     '<C-_>', { remap = true, desc = 'Toggle comment' })
