local set = vim.keymap.set

-- (S-)enter: newline OR search
local function newline_or_step(no_search, in_search)
  return function() return vim.fn.getreg('/') == '' and no_search or in_search end
end
set('n', '<CR>',   newline_or_step('o', 'n'), { expr = true })
set('n', '<S-CR>', newline_or_step('O', 'N'), { expr = true })

-- (f)ind <cword>
set('n', '<C-f>', function()
  local w = vim.fn.expand('<cword>')
  vim.fn.setreg('/', w)
  vim.opt.hlsearch = true
  vim.fn.feedkeys('/' .. w)
end, { silent = true, desc = 'Find <cword>' })

set('v', '<C-f>', 'y:let @/=@" <bar>:set hls<CR>gn',
  { silent = true, desc = 'Find selection' })

-- clear search pattern register (@/)
set('n', '<Esc>', '<Cmd>nohl<CR><Cmd>let @/ = ""<CR>')
