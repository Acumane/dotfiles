-- No-op when `commentstring` is empty
require('mini.comment').setup({
  mappings = {
    comment        = 'gc',     -- operator: gc{motion}
    comment_line   = '<C-_>',  -- normal: toggle current line
    comment_visual = '<C-_>',  -- visual: toggle selection
    textobject     = 'gc',
  },
})

-- <C-/> reaches nvim as either <C-_> (terminal byte form) or <C-/> (kitty proto)
vim.keymap.set({'n','x'}, '<C-/>', '<C-_>', { remap = true, desc = 'Toggle comment' })
