local set = vim.keymap.set

-- use Tab
set('n', '<Tab>',   '>>',         { desc = 'Indent line' })
set('n', '<S-Tab>', '<<',         { desc = 'Dedent line' })
set('v', '<Tab>',   '>><Esc>gv',  { desc = 'Indent selection' })
set('v', '<S-Tab>', '<<<Esc>gv',  { desc = 'Dedent selection' })

-- block mode (C-v is paste)
set('v', 'b', '<C-v>', { desc = 'Block visual' })

-- non-VSCode keymaps
if not vim.g.vscode then
  set('n', '<C-q>',    ':q<CR>',  { desc = 'Quit' })
  set('n', '<S-Del>',  'dvb',     { desc = 'Word-kill (matches kitty)' })
  set('i', '<S-Del>',  '<C-w>')
  set('c', '<S-Del>',  '<C-w>')
end
