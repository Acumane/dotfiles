local set = vim.keymap.set
local M = {'n','v','o'}

-- Verb rotation. Bare key = motion form; capital and doubled = whole line.
local verbs = {
  { 'c', 'y',     'yy'    },   -- (c)opy
  { 'x', 'd',     'dd'    },   -- x (cut)
  { 'r', '"_c',   '"_cc'  },   -- (r)eplace blackhole
  { 'd', '"_d',   '"_dd'  },   -- true (d)elete blackhole
}
for _, v in ipairs(verbs) do
  local lhs, motion_rhs, line_rhs = v[1], v[2], v[3]
  set(M, lhs, motion_rhs)
  set('n', lhs:upper(), line_rhs)
  set('n', lhs..lhs, line_rhs)
end

-- Disable 'down' in motions; `i` is still insert
for _, op in ipairs({'c','d','r','x'}) do
  set('n', op..'k', '<Nop>')
end

-- visual paste preserves register
set('v', 'p', '"_dP')

-- H = (a)ppend
set('n', 'H',  'a',         { desc = 'Append after cursor' })
set('v', 'H',  'A',         { desc = 'Append after selection' })

-- Canonical functions
set('n', '<C-a>', 'gg^vG$h',       { desc = 'Select all' })
set('v', '<C-a>', 'gg^oG$h')
set('i', '<C-a>', '<Esc>gg^vG$h')
set('t', '<Esc>', '<C-\\><C-n>')

set('v', '<C-c>', 'y',  { desc = 'Copy (visual)' })
set('v', '<C-x>', 'x',  { desc = 'Cut (visual)' })

set(M,   '<C-u>', 'u',          { desc = 'Undo' })
set('i', '<C-u>', '<C-o>u')
set(M,   'u',     '<Nop>')

-- ~ toggle case
set('n', '~', '~h')
set('v', '~', '~gv')

-- sane <inc|dec>rement
set('n', '=', '<C-a>', { desc = 'Increment' })
set('n', '+', '<C-a>', { desc = 'Increment' })
set('n', '-', '<C-x>', { desc = 'Decrement' })
