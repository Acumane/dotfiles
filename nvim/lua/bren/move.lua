-- mini.move on arrow keys (keyd: ctrl+ijkl -> arrows)

local L, R, D, U = '<Left>', '<Right>', '<Down>', '<Up>'
require('mini.move').setup({
  mappings = {
    left = L, right = R, down = D, up = U,                       -- visual selection
    line_left = L, line_right = R, line_down = D, line_up = U,   -- normal line
  },
  options = { reindent_linewise = false },
})
