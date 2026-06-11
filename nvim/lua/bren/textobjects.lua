-- Text objects via mini.ai. h<x> = inner, a<x> = around.
--   Mnemonics: p () b [] B {} t <> q " u _ e * m $

local P = require('bren.pairs')

local custom = {}
for letter, pair in pairs(P.mnemonics) do
  custom[letter] = P.input(pair[1], pair[2])
end

-- new text objects
custom['*'] = P.input('*', '*')
custom['_'] = P.input('_', '_')
custom['$'] = P.input('$', '$')

require('mini.ai').setup({
  n_lines = 50,
  mappings = {
    around       = 'a',  inside      = 'h',
    around_next  = 'an', inside_next = 'hn',
    around_last  = 'al', inside_last = 'hl',
    -- Jump motions disabled 
    goto_left    = '',   goto_right  = '',
  },
  custom_textobjects = custom,
})

-- Stock textobjects via h<x>/a<x> (mini.ai inside='h' doesn't fall back)
local set = vim.keymap.set
for letter, suffix in pairs({ w = 'w', W = 'W', s = 's', P = 'p' }) do
  set({'o','x'}, 'h' .. letter, 'i' .. suffix)
  set({'o','x'}, 'a' .. letter, 'a' .. suffix)
end

-- (P)aragraph text objects
set('o', 'iP', 'ip')

-- Route i<mnemonic> -> h<mnemonic> (in visual use h<x>)
for letter in pairs(P.mnemonics) do
  set('o', 'i' .. letter, 'h' .. letter, { remap = true })
end
