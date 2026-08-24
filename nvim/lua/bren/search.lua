local set = vim.keymap.set

-- (S-)enter: newline OR step through matches
set('n', '<CR>',   function() return vim.fn.getreg('/') == '' and 'o' or 'n' end, { expr = true })
set('n', '<S-CR>', function() return vim.fn.getreg('/') == '' and 'O' or 'N' end, { expr = true })

-- Seeded w/ word below cursor 
set('n', '/', '/<C-r><C-w>', { desc = 'Search the word under the cursor' })

-- Seeded w/ single-line visual selection
set('x', '/', function()
  local sel = vim.fn.getregion(vim.fn.getpos('v'), vim.fn.getpos('.'),
    { type = vim.fn.mode() })
  local seed = #sel == 1 and vim.fn.escape(sel[1], '\\/.*$^~[]') or ''
  vim.fn.feedkeys(vim.keycode('<Esc>') .. '/' .. seed, 'n')
end, { desc = 'Search the selection' })

-- clear search pattern register (@/)
set('n', '<Esc>', '<Cmd>nohl<CR><Cmd>let @/ = ""<CR>')
