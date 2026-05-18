-- Surround via mini.surround:
--   s<ch>    surround word     (saiw<ch>)
--   d<ch>    delete surround   (sd<ch>)
--   r<a><b>  replace surround  (sr<a><b>)

local P = require('bren.pairs')

local custom = {}
for letter, pair in pairs(P.mnemonics) do
  custom[letter] = {
    input  = P.input(pair[1], pair[2]),
    output = { left = pair[1], right = pair[2] },
  }
end

require('mini.surround').setup({
  custom_surroundings = custom,
  search_method = 'cover_or_nearest',
})

-- surround shortcuts
local chars = {
  'p', 'b', 'B', 't', 'q', 'u', 'e', 'm',
  ')', ']', '}', '>', '"', "'", '`', '*', '_', '$',
  '(', '[', '{', '<',
}

local set = vim.keymap.set
local recursive = { remap = true }

for _, ch in ipairs(chars) do
  set('n', 's' .. ch, 'saiw' .. ch, recursive)
  set('n', 'd' .. ch, 'sd'   .. ch, recursive)
end

-- pair replace
for _, a in ipairs(chars) do
  for _, b in ipairs(chars) do
    set('n', 'r' .. a .. b, 'sr' .. a .. b, recursive)
  end
end
